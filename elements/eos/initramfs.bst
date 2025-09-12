kind: script
description: |
  EOS7 initramfs construction using Dracut.

  The initramfs is systemd-based. It includes OSTree's Dracut module which runs
  `ostree-prepare-root.service` at boot time to set up the root filesystem.

  Dracut builds the initramfs based on configuration files in `/etc/dracut`:

    * endless.conf, from `eos/eos-boot-helper.bst`
    * ostree.conf, from `freedesktop-sdk.bst:components/ostree.bst`

build-depends:
- eos/eos-boot-helper.bst
- eos/initramfs/deps.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/linux.bst
- freedesktop-sdk.bst:components/ostree.bst

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

  # FIXME: Installing kernel modules should move to a separate element. And we
  # need to sign them with the linux modules cert as done in GNOME OS.
  - |
    mkdir -p "%{install-root}/usr/lib/"
    cp -r /usr/lib/modules "%{install-root}/usr/lib/"

  # Build the initramfs using dracut.
  - |
    version="$(ls -1 /lib/modules | head -n1)"
    mkdir -p "%{install-root}/usr/lib/modules/${version}"
    dracut -v --reproducible \
           --kver "${version}" \
           "%{install-root}/usr/lib/modules/${version}/initramfs"
