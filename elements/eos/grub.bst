kind: stack
description: |
  Stack containing the GRUB bootloader.

  There are multiple builds of GRUB as the eos-image-builder
  installs a UEFI and a legacy BIOS GRUB bootloader.

depends:
- eos/grub/grub-i386-pc.bst
- eos/grub/grub-x86_64-efi.bst
- eos/grub/grub-config.bst
