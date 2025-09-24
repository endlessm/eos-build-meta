kind: manual
description: |
  Sign the GRUB UEFI bootloader binary with the insecure "snakeoil" key.

build-depends:
- eos/grub/grub-x86_64-efi.bst
- freedesktop-sdk.bst:components/sbsigntools.bst

config:
  install-commands:
  - |
    mkdir -p "%{install-root}/usr/lib/efi_binaries/EFI/endless/"
  - |
    sbsign \
        --key VENDOR-snakeoil.key \
        --cert VENDOR-snakeoil.crt \
        --output "%{install-root}/usr/lib/efi_binaries/EFI/endless/grubx64.efi" \
        "/usr/lib/efi_binaries/EFI/endless/grubx64.efi"

sources:
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.key
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.crt
