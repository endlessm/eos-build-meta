kind: script
description: |
  EOS7 initramfs construction using Dracut.

  The initramfs is systemd-based. It includes OSTree's Dracut module which runs
  `ostree-prepare-root.service` at boot time to set up the root filesystem.

build-depends:
- eos/eos-boot-helper.bst
- eos/initramfs/deps.bst
- eos/initramfs/initial-scripts.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/linux.bst
- freedesktop-sdk.bst:components/ostree.bst

config:

  commands:
  - mkdir -p /tmp
  - mkdir -p /var/tmp
  - mkdir -p /efi

  - |
    initial_scripts=/etc/fdsdk/initial_scripts
    sysroot=/
    for i in "${initial_scripts}"/*; do
        [[ -e "$i" ]] || break
        echo "Running $(basename "${i}")" 1>&2
        "${i}" "${sysroot}"
    done

  - |
    sysroot=/
    version="$(ls -1 /lib/modules | head -n1)"
    echo "Running depmod" 1>&2

    for version in $(ls "${sysroot}"/lib/modules/); do
        depmod -b "${sysroot}" -a "${version}";
    done

  - |
    mkdir -p "%{install-root}/usr/lib/"
    cp -r /usr/lib/modules "%{install-root}/usr/lib/"

  # Build the initramfs using dracut.
  #
  # Note that the Dracut config is installed into /etc/ from the `eos/eos-boot-helper.bst`.
  - |
    version="$(ls -1 /lib/modules | head -n1)"
    mkdir -p "%{install-root}/usr/lib/modules/${version}"
    dracut -v --reproducible \
           --kver "${version}" \
           "%{install-root}/usr/lib/modules/${version}/initramfs"
