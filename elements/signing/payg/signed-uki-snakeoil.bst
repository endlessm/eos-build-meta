kind: manual
description: |
  Sign the PAYG UKI with the insecure "snakeoil" key.

build-depends:
- eos/payg/uki.bst
- freedesktop-sdk.bst:components/sbsigntools.bst

config:
  install-commands:
  - |
    version="$(ls -1 /lib/modules | head -n1)"
    mkdir -p "%{install-root}/usr/lib/modules/${version}"
    sbsign \
        --key VENDOR-snakeoil.key \
        --cert VENDOR-snakeoil.crt \
        --output=%{install-root}/usr/lib/modules/${version}/payg-image.efi \
        "/usr/lib/modules/${version}/payg-image.efi"

sources:
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.key
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.crt
