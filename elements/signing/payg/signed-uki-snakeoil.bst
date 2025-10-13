kind: manual
description: |
  Sign the PAYG UKI with the insecure "snakeoil" key.

build-depends:
- eos/payg/uki.bst
- freedesktop-sdk.bst:components/sbsigntools.bst

config:
  install-commands:
  - |
    mkdir -p "%{install-root}/usr/share/efi_binaries_payg/"
    sbsign \
        --key VENDOR-snakeoil.key \
        --cert VENDOR-snakeoil.crt \
        --output=%{install-root}/usr/share/efi_binaries_payg/payg-image-signed.efi \
        "/usr/share/efi_binaries_payg/payg-image.efi"

sources:
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.key
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.crt
