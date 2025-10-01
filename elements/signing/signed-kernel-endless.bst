kind: eos_sb_signer
description: |
  Sign the Linux kernel binary using eos-sb-signer service.

  See `doc/overview/signing.md` for context.

build-depends:
- components/linux.bst

config:
  # Path to the kernel binary in the dependency.
  # The exact path may vary based on the kernel version and configuration.
  input: "/boot/vmlinuz"

  # Output path for the signed kernel.
  output: "%{install-root}/boot/vmlinuz.signed"
