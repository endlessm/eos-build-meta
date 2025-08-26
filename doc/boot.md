# How EOS7 boots

This document was last updated 2025-08-26, based on eos-build-meta commit
8c66f1be55b9.

## Introduction

Here we talk about the pieces involved in booting EOS7.

## Variants

EOS7 currently supports only `amd64` architecture.

There are two bootloader variants of EOS:

  * `grub` (the default)
  * `payg_sdboot` (pay-as-you-go devices, which use systemd-boot)

We'll consider these install scenarios here when considering the components, as
the scenario affects how they operate:

  * The live EOS7 installer media (iso)
  * An EOS7 disk image, preinstalled or set up by eos-installer (disk)
  * EOS7 installed as an update to EOS6 (update)

The pay-as-you-go variant is pre-installed by device vendors and isn't
otherwise available.

So the possible scenarios in practice are:

  * amd64-grub-iso
  * amd64-grub-disk
  * amd64-grub-update
  * amd64-payg_sdboot-disk

Note that whole-disk installations created by
[eos-installer](https://github.com/endlessm/eos-installer) should be
bit-for-bit identical to preinstalled disk images so they don't need
to be treated separately.

EOS7 does not explicitly support dual boot. Existing EOS6 systems
may be dual-boot setups, which the `update` scenario needs to consider.

## Components

These are the pieces involved in booting the system.

### UEFI

UEFI (Universal Extensible Firmware Interface) is a specification that describes
how modern PC firmwares can load applications from storage and run them. OS
bootloaders are one kind of UEFI application.

Each PC vendor implements UEFI in their firmware, and each operating system
vendor provides an ESP with a UEFI bootloader that is the entry point for their
operating system.

The [TianoCore project](https://www.tianocore.org/) develops a framework named
EDK2 (EFI Development Kit) which is the basis for some UEFI implementations.

The TianoCore project also develops OVMF (Open Virtual Machine Firmware), which
you need when setting up virtual machines with support for UEFI.

When the computer boots, it looks on one or more of the disks for an ESP
(EFI System Partition), loads the UEFI applications, and runs one or more of
them.

### ESP (EFI System Partition)

The ESP is a partition on the chosen disk.  The computer firmware finds the ESP
using the GUID Partition Table (GPT), and loads all the applications.

UEFI defines a standard file path for the default bootloader application. On amd64
this is: `EFI/BOOT/BOOTX64.EFI`.

#### What the Endless OS ESP contains

##### `amd64-grub`

There are these binaries in the ESP for GRUB systems:

    EFI/BOOT/bootia32.efi
    EFI/BOOT/fbx64.efi
    EFI/BOOT/mmx64.efi
    EFI/BOOT/BOOTX64.EFI
    EFI/endless/grubx64.efi
    EFI/endless/BOOTX64.CSV
    EFI/endless/mmx64.efi
    EFI/endless/shimx64.efi

##### `amd64-payg_sdboot`

TBD, but seems to be:

  * a single `EFI/BOOT/BOOTX64.EFI` file.
  * some symlinks

#### How it is built

The EOS7 disk image is built in eos-image-builder, in the
[`eib_image` stage](https://github.com/endlessm/eos-image-builder/blob/master/stages/eib_image).

The disk image has a GUID Partition Table (GPT) and partitions are labelled
with GUIDs following the
[Discoverable Partitions spec](https://www.freedesktop.org/wiki/Specifications/DiscoverablePartitionsSpec/).

The EFI System Partition is the first partition on the disk image and is created as follows:

##### `amd64-grub`

The `create_image` function runs and creates the disk image, with these partitions:

  * 1: EFI
  * 2: MBR
  * 3: root

It then sets up various bind mounts and runs `grub-install`. (This updates
the MBR partition, I guess?)

Then it copies files from the tree checkout (`/usr/lib/efi_binaries/EFI`)
into the EFI partition.

##### `amd64-payg_sdboot`

At some point during the build process, systemd-boot creates an EFI entry
and saves it to `/usr/lib/systemd/boot/efi/systemd-bootx64.efi`.

Then:

 1. `eib_image` creates an ESP-shaped disk image and mounts it at `/boot`
    inside the ostree checkout dir.
    ([eib_image#L84](https://github.com/endlessm/eos-image-builder/blob/master/stages/eib_image#L84))
 2. `ostree admin deploy` runs. A comment on line #95 suggests it creates some
    fake symlinks within `/boot`.
 3. The `create_image` function runs, and creates the disk image, with these partitions:

      * 1: EFI 
      * 2: root

 4. It copies the ESP-shaped disk image created earlier into the new ESP.
 5. It copies `BOOTX64.efi` application from the ostree checkout
    (`/usr/lib/systemd/boot/efi/systemd-bootx64.efi`) into the ESP.

#### How it is deployed

Each computer has one ESP. So deployment is different for each install scenario:

  * `iso`: FIXME: how is an ISO booted?
  * `disk`: The ESP is used directly from the disk image built by eos-image-builder.
  * `install`: 
