kind: manual
description: |
  Sign the Linux kernel binary with the insecure "snakeoil" key.

build-depends:
- freedesktop-sdk.bst:components/linux.bst
- freedesktop-sdk.bst:components/sbsigntools.bst

config:
  install-commands:
  - |
    mkdir -p "%{install-root}/boot/"
  - |
    sbsign \
        --key VENDOR-snakeoil.key \
        --cert VENDOR-snakeoil.crt \
        --output "%{install-root}/boot/vmlinuz.signed" \
        "/boot/vmlinuz"
  - |
    echo "Installing signed kernel to location expected by OSTree."
    sysroot="$1"
    version="$(ls -1 /${sysroot}/usr/lib/modules | head -n1)"
    mkdir -p "%{install-root}/usr/lib/modules/${version}"
    cp "%{install-root}/boot/vmlinuz.signed" "%{install-root}/usr/lib/modules/${version}/vmlinuz"

sources:
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.key
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.crt
