kind: script
description: |
  EOS7 initramfs construction using Dracut.

  The initramfs is systemd-based. It includes OSTree's Dracut module which runs
  `ostree-prepare-root.service` at boot time to set up the root filesystem.

  Dracut builds the initramfs based on configuration files in `/etc/dracut`:

    * endless.conf, from `eos/eos-boot-helper.bst`
    * ostree.conf, from `freedesktop-sdk.bst:components/ostree.bst`

build-depends:
- freedesktop-sdk.bst:components/dracut.bst

# These build-depends provide dracut modules.
- eos/eos-boot-helper.bst
- freedesktop-sdk.bst:components/ostree.bst

# These build-depends provide programs used in the initramfs.
# We separate these from / as we want to avoid GPL3 binaries within /sysroot.
- filename: eos/initramfs/deps.bst
  config:
    location: /sysroot

config:

  commands:
  - mkdir -p /tmp
  - mkdir -p /var/tmp
  - mkdir -p /efi

  - |
    sysroot=/sysroot
    version="$(ls -1 ${sysroot}/lib/modules | head -n1)"
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
    sysroot=/sysroot
    version="$(ls -1 ${sysroot}/lib/modules | head -n1)"
    mkdir -p "%{install-root}/usr/lib/modules/${version}"
    dracut -v --reproducible \
           --kver "${version}" \
           --sysroot "${sysroot}" \
           --tmpdir /var/tmp \
           "%{install-root}/usr/lib/modules/${version}/initramfs" \
           2> >(tee /var/tmp/dracut.log >&2)

  # Dracut treats errors as warnings. In practice, errors often mean a
  # broken initramfs, so we detect them here and raise an error.
  - |
    if grep "ERROR:" /var/tmp/dracut.log; then
        echo "Errors detected in Dracut log file."
        exit 1
    fi

  - false
