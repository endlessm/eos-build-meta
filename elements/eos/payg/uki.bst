kind: script
description: |
  EOS7 Pay-As-You-Go UKI construction using Dracut.

  This builds a Unified Kernel Image (Linux + initramfs) for use in Endless OS
  Pay-As-You-Go variants, using Dracut and systemd-stub.

  Dracut builds the initramfs based on configuration files in `/etc/dracut`:

    * endless.conf, from `eos/eos-boot-helper.bst`
    * ostree.conf, from `freedesktop-sdk.bst:components/ostree.bst`

  The UKI is written inside `/usr/lib/modules/` alongside the regular initramfs,
  and signed by a later element. The signed binary is deployed to the ESP by a
  codepath in the custom Endless version of OSTree, when `OSTREE_DEPLOY_PAYG`
  is set in the environment.

build-depends:
- eos/eos-boot-helper.bst
- eos/initramfs/deps.bst
- eos/payg/eos-payg.bst
- eos/payg/eos-payg-nonfree.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:components/python3-pefile.bst
- gnome-build-meta.bst:core-deps/systemd.bst

config:
  commands:
  - mkdir -p /tmp
  - mkdir -p /var/tmp
  - mkdir -p /efi

  - |
    sysroot=/
    version="$(ls -1 /lib/modules | head -n1)"
    echo "Running depmod" 1>&2

    for version in $(ls "${sysroot}"/lib/modules/); do
        depmod -b "${sysroot}" -a "${version}";
    done

  # Dracut uses this information to find loadable shared objects.
  - |
    echo '%{libdir}' >> /etc/ld.so.conf

  # Build the initramfs using dracut.
  #
  # We tee stderr to a file for post-processing.
  - |
    version="$(ls -1 /lib/modules | head -n1)"
    mkdir -p "%{install-root}/usr/lib/modules/${version}"
    dracut %{install-root}/usr/lib/modules/${version}/payg-image.efi ${version} \
        -k /usr/lib/modules/${version} --uefi \
        --uefi-stub=%{install-root}/usr/lib/systemd/boot/efi/linuxx64.efi.stub \
        --kernel-cmdline "eospayg efi_no_storage_paranoia rd.shell=0" \
        --kernel-image /boot/vmlinuz \
        --force-drivers "endlessdog" \
        --add "eos-payg eos-payg-nonfree"

  # Dracut treats errors as warnings. In practice, errors often mean a
  # broken initramfs, so we detect them here and raise an error.
  - |
    if grep "ERROR:" /var/tmp/dracut.log; then
        echo "Errors detected in Dracut log file."
        exit 1
    fi
