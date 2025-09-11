kind: eos_sb_signer
description: |
  Sign the GRUB UEFI bootloader binary using eos-sb-signer service.

  See `doc/overview/signing.md` for context.

build-depends:
- eos/grub/grub-x86_64-efi.bst

config:
  input: "/usr/lib/efi_binaries/EFI/endless/grubx64.efi"
  output: "%{install-root}/usr/lib/efi_binaries/EFI/endless/grubx64.efi"
