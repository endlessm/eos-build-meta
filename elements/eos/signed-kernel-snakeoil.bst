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
        --output "%{install-root}/boot/vmlinuz" \
        "/boot/vmlinuz"

sources:
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.key
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.crt
