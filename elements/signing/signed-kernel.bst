kind: manual
description: |
  Install signed kernel to location expected by OSTree.

build-depends:
  - freedesktop-sdk.bst:bootstrap-import.bst
  - components/linux.bst

# Signed kernel
(?):
  - signed_boot == "endless":
      build-depends:
        (>):
          - signing/signed-kernel-endless.bst
  - signed_boot == "snakeoil":
      build-depends:
        (>):
          - signing/signed-kernel-snakeoil.bst

config:
  install-commands:
  - |
    echo "Installing signed kernel to location expected by OSTree."
    sysroot="$1"
    version="$(ls -1 /${sysroot}/usr/lib/modules | head -n1)"
    echo "version is ${version}"
    mkdir -p %{install-root}/usr/lib/modules/${version}
    cp /${sysroot}/boot/vmlinuz.signed %{install-root}/usr/lib/modules/${version}/vmlinuz
    cp /${sysroot}/boot/config %{install-root}/usr/lib/modules/${version}/config
