# GRUB build inputs

## SBAT metadata

This directory contains the SBAT metadata for the GRUB bootloader used in
Endless OS 7.

SBAT is metadata format used in UEFI Secure Boot to identify bootloaders
with known security vulnerabilities and blocklist them.

The SBAT metadata needs to correspond with the version of GRUB built in the
`eos/grub/grub-i386-pc.bst` and `eos/grub/grub-x86_64-efi.bst` elements.

## Standalone UEFI images builder

The `built-sa-efi-images` is taken from the EOS6 Debian package of GRUB:
<https://github.com/endlessm/grub/blob/debian-master/debian/build-sa-efi-images>.
