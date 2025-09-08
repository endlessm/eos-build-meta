# Endless OS Boot Process

This document gives an overview of how Endless OS 7 boots.
It's up to date as of 2025-09-08.

The components involved in booting EOS7 are:

  1. The machine firmware, based on UEFI
  2. The EFI System Partition (ESP), which is loaded by the firmware
  3. Shim, the first stage bootloader
  4. GRUB, the second stage bootloader
  5. Linux, our favourite kernel
  6. The initramfs, the first "userland" entry point
  7. The root filesystem, the main entrypoint into Endless OS.

For details on how each of these things can be configured, developed and
debugged, read on.

## 1. Machine firmware

The firmware is provided by the machine vendor.  Vendors can ship firmware
updates via the fwupd database.

The firmware configuration determines which UEFI application runs when the
machine turns on. If the configuration is empty, the default boot application
from the ESP is used (`EFI/BOOTX64.EFI`.).

The firmware configuration also determines if UEFI Secure Boot is enabled.
Vendors usually enable this by default. EOS7 provides a signature chain
that should allow booting on systems with UEFI Secure Boot in the default
configuration.

## 2. ESP

The ESP is the first partition of every EOS7 disk image. The partition is
constructed by eos-image-builder.

Endless OS's ESP provides two entries:

  * `EFI/BOOT`: the "default" entry, expected to run on first boot.
  * `EFI/endless`: the "endless" entry, run on subsequent boots.

The contents of these comes from the `eos/efi-binaries.bst` element,
including the configuration file for the "endless" entry.

## 3. Shim

Shim is the first-stage bootloader.

When UEFI Secure Boot is enabled, the firmware checks the Shim binary for a
trusted signature. In practice, vendor firmwares only trust Microsoft's
signature. So the main Shim binary is signed with Microsoft's key, requested
via the [shim-review repo](https://github.com/endlessm/shim-review).


This is done

As the first application loaded by the firmware, 

having to sign binaries with 
