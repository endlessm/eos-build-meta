kind: eos_sb_signer
description: |
  Sign systemd-boot binary using eos-sb-signer service.

  This is signed with the PAYG certificate as systemd-boot is only
  used for PAYG systems.

  See `doc/overview/signing.md` for context.

build-depends:
- components/systemd-base.bst

config:
  input: "/usr/lib/systemd/boot/efi/systemd-bootx64.efi"
  output: "%{install-root}/usr/lib/systemd/boot/efi/systemd-bootx64.efi"
  certificate: payg_uefi

# Allow this element to overwrite the binary from systemd-boot in filesystem.bst.
public:
  bst:
    overlap-whitelist:
    - |
      /usr/lib/systemd/boot/efi/systemd-bootx64.efi
