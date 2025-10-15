kind: eos_sb_signer
description: |
  Sign the PAYG UKI using eos-sb-signer service.

build-depends:
- eos/payg/uki.bst

config:
  input: "/usr/share/efi_binaries_payg/payg-image.efi"
  output: "%{install-root}/usr/share/efi_binaries_payg/payg-image-signed.efi"
  certificate: payg_uefi
