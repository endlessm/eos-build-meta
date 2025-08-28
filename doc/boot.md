# How Endless OS boots

This document was up-to-date as of 2025-08-28.

## Introduction

Here we talk about the pieces involved in booting EOS7, how they are built and
how they should work.

There will be some references to EOS6, Freedesktop SDK and GNOME OS as well.

But first we need to talk about what EOS7 is, and how it is deployed.

### Variants of Endless OS

EOS7 supports one architecture: `amd64` with modern UEFI-compliant firmware. 

EOS7 has a Pay-as-you-Go variant with a special boot process. We label
the regular version `normal` and the PAYG variant `payg`.

### Deployment scenarios for Endless OS

The `normal` variant of EOS7 can be deployed in several ways.

  * Booting the live EOS7 installer media (labelled `iso`)
  * Booting an pre-installed EOS7 disk image (labelled `disk`)
  * Booting an existing EOS6 installation, and installing EOS7 as an update (`update`)

We need to consider these invidually as the bootloader deployment is different.

Note that [eos-installer](https://github.com/endlessm/eos-installer) works
by copying a pre-installed EOS7 disk image. So we don't need to treat the
eos-installer case specially.

Also note that EOS7 does not explicitly support dual boot. Although existing
EOS6 systems may have dual-boot set up.

The `payg` variant is only available pre-installed from by device vendors,
i.e. the `disk` scenario.

## Concepts

You'll need to know about the following things for this to make sense. I've
included an incomplete summary of each topic. Please read the references and
search online for more info.

### UEFI

UEFI (Universal Extensible Firmware Interface) is a specification that describes
how modern PC firmwares can load applications from storage and run them. OS
bootloaders are one kind of UEFI application.

Each PC vendor implements UEFI in their firmware, and each operating system
vendor provides an ESP with a UEFI bootloader that is the entry point for their
operating system.

(For virtual machines, OVMF (Open Virtual Machine Firmware) from the [TianoCore
project](https://www.tianocore.org/) provides a UEFI-compatible firmware).

### UEFI Secure Boot

UEFI Secure Boot is a protocol defined as part of the UEFI specification.
When enabled, a firmware will only load a UEFI application if it is trusted
according the firmware's Signature Databases.

In practice, PC vendors enable Secure Boot and use Microsoft as the root of
trust.  Modern PC firmwares will only run UEFI bootloaders that have been
signed by Microsoft, by default.

Roughly, the chain of trust in UEFI Secure Boot is like this:

  1. Platform Key: toplevel key, set in the firmware by the PC vendor
  2. Key Exchange Keys: additional keys, which give control over the the
     Signature Databases
  3. Signature Databases (db and dbx): allowlist and blocklist of signing
     certificates and image hashes.

There are two ways that a specific UEFI application can be trusted here:

  1. The hash of the binary itself is stored in the allowlist.
  2. The public part of an X.509 certificate is stored in the allowlist.
     The firmware then accepts any binary that contains a digital signature from
     that X.509 certificate.

Usually the PC vendor only ships Key Exchange Keys that allow themselves and
Microsoft to update the Signature Databases. It's difficult for the owner
of the PC to update it.

References:

  * Microsoft Windows Hardware Developer docs: [Learn > Windows > Secure Boot](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-secure-boot)

### Shim, Machine Owner Keys and SBAT

[Shim](https://github.com/endlessm/shim) is a UEFI application commonly used to
load Linux distributions.

Each Linux distribution generates a signing cert and builds a Shim binary with
the public part of the cert embedded. They request Microsoft to sign that
binary, so it can be booted on all UEFI Secure Boot systems.

The Shim adds more links into the chain of trust:

  * Any binary signed by the embedded X.509 certificate is trusted.
  * There is an additional signature database, 
  * Any  Machine Owner Key

There is also a blocklist, using a format named SBAT.
The allows distributions to produce as many bootloader, initramfs and kernel
binaries as they want wi

Machine Owner Keys are an additional step in the chain of trust, implemented
in a UEFI application named [Shim](https://github.com/rhboot/shim), and
specific to the Linux ecosystem.

The idea is to make 


## Components

These are the pieces involved in booting the system.

## Firmware

When the computer boots, it looks on one or more of the disks for an ESP
(EFI System Partition), loads the UEFI applications, and runs one or more of
them.

### ESP (EFI System Partition)

The ESP is a partition on the chosen disk.  The computer firmware finds the ESP
using the GUID Partition Table (GPT), and loads all the UEFI applications.

UEFI defines a standard file path for the default bootloader application. On amd64
this is: `EFI/BOOT/BOOTX64.EFI`. That's what the firmware runs on boot, unless
someone configured it to do something else.

The ESP in Endless OS 6 contains the following files:

  * `EFI/BOOT/BOOTX64.EFI`: Endless's UEFI shim loader
  * `EFI/BOOT/bootia32.efi`: 
  * `EFI/BOOT/fbx64.efi`
  * `EFI/BOOT/mmx64.efi`
  * `EFI/endless/grubx64.efi`
  * `EFI/endless/BOOTX64.CSV`
  * `EFI/endless/mmx64.efi`
  * `EFI/endless/shimx64.efi`

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
