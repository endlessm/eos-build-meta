# Endless OS Boot Process

This document gives an overview of how Endless OS 7 boots.
It's up to date as of 2025-09-26.

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

See below for a note on old-school BIOS boot.

Some of these components are signed. For details on the signing processes,
see [`doc/overview/signing.md`](./signing.md).

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

Endless OS's ESP provides two boot entries:

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

The Shim binary is configured to load the second stage bootloader, and check
its signature against Endless's signing certificate.

Shim provides two supplementary applications:

  * `fbx64.efi`, the "fallback" bootloader. This runs if the machine's firmware
    configuration is empty. 
  * `mmx64.efi`, the MOK manager. This allows the machine owner to configure
    Shim's chain of trust.

Shim is currently not built from source in EOS7. Prebuilt signed binaries are
committed to eos-build-meta.git. These are added to the filesystem tree at
`/usr/share/efi_binaries`. From here, eos-image-builder copies them into the
ESP.

See also:

  * Issue 94: ["Build and ship Shim binaries in eos-build-meta"](https://github.com/endlessm/eos-build-meta/issues/94)

## 4. GRUB

EOS7 uses GNU GRUB to boot. 

The GRUB UEFI application is built by the element `eos/grub.bst` and installed
to `/usr/share/efi_binaries`, where eos-image-builder moves it into the ESP.

The GRUB UEFI application contains all necessary modules and fonts. Note that
most of the files found in the rootfs at `/boot/grub` are used only by the
legacy BIOS boot support. See below for more details.

GRUB configuration is also defined in this repo, and installed to
`/usr/lib/grub/conf` in the filesystem tree. This defines the path where
GRUB loads the initramfs and kernel. As EOS7 is deployed using OSTree,
the initramfs and kernel are deployed by OSTree to special paths.

## 5. Linux

The kernel is used directly from Freedesktop SDK. This is due to change
in [issue #10](https://github.com/endlessm/eos-build-meta/issues/10).

The built kernel is installed in the filesystem inside `/usr/lib/modules`
in the final `eos/repo.bst` element. Its configuration is available
alongside the kernel under the name `.config`.

## 6. initramfs

The initramfs is built specially for EOS7, and has some differences
compared to GNOME OS. Configuration is found in the
[eos-boot-helper](https://github.com/endlessm/eos-boot-helper) repo
in the `dracut/` subdirectory.

See the element `eos/initramfs.bst` for build rules.

On first boot, the initramfs resizes the root partition using the
`endless-repartition` module. This is similar to the more modern
systemd-repart tool.

The root filesystem is set up by the `switchroot` dracut module
provided by OSTree, based on configuration on the kernel commandline.

## 7. Root file system

The root filesystem is deployed using OSTree. This means the root
disk partition is not mounted at `/` like in most Linux systems, but
at `/sysroot`.

The top level directories found in `/` are created in the
element `eos/config/ostree.bst` and become part of the root
filesystem committed to OSTree. They are then recreated by
OSTree when the tree is deployed.

See also:

  * [OSTree documentation](https://ostreedev.github.io/ostree/introduction/)

## BIOS boot process

Endless OS 7 drops support for BIOS on new installations. This means EOS7 disk
images provide an EFI System Partition, but no BIOS boot record. See issue #87
["Drop support for BIOS boot"](https://github.com/endlessm/eos-build-meta/issues/87)
for details.

Some existing systems are set up to boot using the BIOS firmware interface,
and EOS7 preserves support for those systems. This means the `/boot` partition
in the EOS7 root filesystem contains a second version of GRUB that is only used
during BIOS boot.

Most EOS6 disk images use a "BIOS/GPT" configuration, where the first partition of
the disk is the ESP, and the second partition is a 1MB "BIOS boot partition" used
by GRUB.

In an EOS7 system that was upgraded from EOS6 and uses BIOS boot, the components
involved in booting are as follows:

  1. The machine firmware (BIOS, or a BIOS compatibility mode running in UEFI)
  2. The Master Boot Record, containing GRUB first stage (`boot.img`).
  3. The BIOS boot partition, containing GRUB second stage (`core.img`)
  4. The `/boot` directory in the rootfs, containing the remaining GRUB modules
  5. Linux
  6. The initramfs
  7. The root filesystem.

Note that there's no concept of "Secure Boot" when using BIOS boot.
