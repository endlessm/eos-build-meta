#!/bin/bash

set -eu

args=()
cmdline=()
creds=()

while [ $# -gt 0 ]; do
    case "$1" in
        --reset)
            reset=1
            ;;
        --reset-secure-state)
            reset_secure=1
            ;;
        --buildid)
            shift
            buildid="$1"
            ;;
        --notpm)
            no_tpm=1
            ;;
        --cmdline)
            shift
            cmdline+=("$1")
            ;;
        --debug)
            cmdline+=("systemd.debug-shell=ttyS0" "rd.systemd.debug-shell=ttyS0")
            ;;
        --credential)
            shift
            creds+=("$1")
            ;;
        --help)
            echo "USAGE: $0 [OPTIONS] [ELEMENT]"
            echo "Options:"
            echo "    --reset                   Completely wipe the VM and start over"
            echo "    --reset-secure-state      Wipe out the VM's TPM chip, but keep data in tact (you'll need the recovery key)"
            echo "    --buildid                 Boot a specific build ID, instead of the building and booting the current"
            echo "    --notpm                   Disable the TPM"
            echo "    --credential ARG          Pass through a systemd credential"
            echo "    --cmdline ARG             Append an ARG to the kernel command line. Can be repeated multiple times"
            echo "    --debug                   Turn on the systemd debug shell on the serial console"
            echo "Args:"
            echo "    ELEMENT                   The element to boot. Defaults to 'vm-secure/image.bst'"
            exit
            ;;
        *)
            args+=("$1")
            ;;
    esac
    shift
done

: ${STATE_DIR:="${PWD}/current-secure-vm"}
: ${SWTPM_STATE:="${STATE_DIR}/swtpm-state"}
: ${TPM_SOCK:="${STATE_DIR}/swtpm-sock"}
: ${TPM_LOG:="${STATE_DIR}/swtpm-log"}
: ${TYPE11:="${STATE_DIR}/type11.txt"}
: ${BST:=bst}
: ${IMAGE_ELEMENT:="vm-secure/image.bst"}

BST_OPTIONS=()

if [ "${#args[@]}" -ge 1 ]; then
    IMAGE_ELEMENT="${args[0]}"
fi
if [ "${#args[@]}" -ge 2 ]; then
    echo "Too many parameters" 1>&2
    exit 1
fi

if [ "${buildid+set}" = set ]; then
    mkdir -p "${STATE_DIR}/builds"
    if ! [ -f "${STATE_DIR}/builds/disk_${buildid}.img.xz" ]; then
        wget "https://1270333429.rsc.cdn77.org/nightly/${buildid}/disk_${buildid}.img.xz" -O "${STATE_DIR}/builds/disk_${buildid}.img.xz.tmp"
        mv "${STATE_DIR}/builds/disk_${buildid}.img.xz.tmp" "${STATE_DIR}/builds/disk_${buildid}.img.xz"
    fi
fi

if ! [ "${no_tpm+set}" = set ]; then
    if [ "${reset_secure+set}" = set ] ; then
        rm -rf "${SWTPM_STATE}"
    fi

    [ -d "${SWTPM_STATE}" ] || mkdir -p "${SWTPM_STATE}"

    # Launch the software TPM
    trap 'kill $(jobs -p)' EXIT
    swtpm socket --tpm2 --tpmstate dir="${SWTPM_STATE}" --ctrl type=unixio,path="${TPM_SOCK}" --log file="${TPM_LOG}" &
fi

cleanup_dirs=()
cleanup() {
    if [ "${#cleanup_dirs[@]}" -gt 0 ]; then
        rm -rf "${cleanup_dirs[@]}"
    fi
}
trap cleanup EXIT

if [ "${reset+set}" = set ] || ! [ -f "${STATE_DIR}/disk.img" ]; then
    checkout="$(mktemp -d --tmpdir="${STATE_DIR}" checkout.XXXXXXXXXX)"
    cleanup_dirs+=("${checkout}")

    if [ "${buildid+set}" = set ]; then
        cp "${STATE_DIR}/builds/disk_${buildid}.img.xz" "${checkout}/disk.img.xz"
    else
        make -C files/boot-keys generate-keys
        "${BST}" "${BST_OPTIONS[@]}" build "${IMAGE_ELEMENT}"
        "${BST}" "${BST_OPTIONS[@]}" artifact checkout "${IMAGE_ELEMENT}" --directory "${checkout}"
    fi
    unxz "${checkout}/disk.img.xz"
    truncate --size 50G "${checkout}/disk.img"
    mv "${checkout}/disk.img" "${STATE_DIR}/disk.img"
    rm -rf "${checkout}"
fi

if ! [ -f "${STATE_DIR}/OVMF_CODE.fd" ] || ! [ -f "${STATE_DIR}/OVMF_VARS_TEMPLATE.fd" ]; then
    checkout="$(mktemp -d --tmpdir="${STATE_DIR}" checkout.XXXXXXXXXX)"
    cleanup_dirs+=("${checkout}")
    bst build freedesktop-sdk.bst:components/ovmf.bst
    "${BST}" "${BST_OPTIONS[@]}" artifact checkout freedesktop-sdk.bst:components/ovmf.bst --directory "${checkout}"
    cp "${checkout}/usr/share/ovmf/OVMF_CODE.fd" "${STATE_DIR}/OVMF_CODE.fd"
    cp "${checkout}/usr/share/ovmf/OVMF_VARS.fd" "${STATE_DIR}/OVMF_VARS_TEMPLATE.fd"
fi

if [ "${reset_secure+set}" = set ] || ! [ -f "${STATE_DIR}/OVMF_VARS.fd" ]; then
    virt-fw-vars \
        --input "${STATE_DIR}/OVMF_VARS_TEMPLATE.fd" \
        --output "${STATE_DIR}/OVMF_VARS.fd" \
        --set-pk OvmfEnrollDefaultKeys files/boot-keys/PK.crt \
        --add-kek OvmfEnrollDefaultKeys files/boot-keys/KEK.crt \
        --add-db OvmfEnrollDefaultKeys files/boot-keys/DB.crt \
        --sb
fi

QEMU_ARGS=()
QEMU_ARGS+=(-m 8G)
QEMU_ARGS+=(-M q35,accel=kvm)
QEMU_ARGS+=(-smp 4)
QEMU_ARGS+=(-net nic,model=virtio)
QEMU_ARGS+=(-net user)
QEMU_ARGS+=(-drive "if=pflash,file=${STATE_DIR}/OVMF_CODE.fd,readonly=on,format=raw")
QEMU_ARGS+=(-drive "if=pflash,file=${STATE_DIR}/OVMF_VARS.fd,format=raw")
if ! [ "${no_tpm+set}" = set ]; then
    QEMU_ARGS+=(-chardev "socket,id=chrtpm,path=${TPM_SOCK}")
    QEMU_ARGS+=(-tpmdev emulator,id=tpm0,chardev=chrtpm)
    QEMU_ARGS+=(-device tpm-tis,tpmdev=tpm0)
fi
QEMU_ARGS+=(-drive "if=virtio,file=${STATE_DIR}/disk.img,media=disk,format=raw")
QEMU_ARGS+=(-device virtio-vga-gl -display gtk,gl=on)
QEMU_ARGS+=(-full-screen)
QEMU_ARGS+=(-device ich9-intel-hda)
QEMU_ARGS+=(-audiodev pa,id=sound0)
QEMU_ARGS+=(-device hda-output,audiodev=sound0)

if [[ "${cmdline[*]}" =~ "ttyS0" ]]; then
        QEMU_ARGS+=(-serial mon:stdio)

        #trap reset EXIT
        reset

        cmdline+=("systemd.tty.rows.ttyS0=$(tput lines)" "systemd.tty.columns.ttyS0=$(tput cols)")
else
        QEMU_ARGS+=(-serial none)
fi

if [ ${#cmdline[@]} -gt 0 ]; then
    QEMU_ARGS+=(-smbios "type=11,value=io.systemd.stub.kernel-cmdline-extra=${cmdline[*]}")
fi

if [ ${#creds[@]} -gt 0 ]; then
    rm "$TYPE11" || true
    for cred in "${creds[@]}"; do
        echo "$cred" >> "$TYPE11"
    done
    QEMU_ARGS+=(-smbios "type=11,path=$TYPE11")
fi

qemu-system-x86_64 "${QEMU_ARGS[@]}"
