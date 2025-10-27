# EOS7 Pay As You Go support

This is an overview of how PAYG variant of Endless OS differs from the regular system.
It's up to date as of 2025-10-27.

## Boot process

The PAYG image differs from the regular boot setup documented in
[`doc/overview/boot.md`](doc/overview/boot.md).

The components involved are:

 1. A UEFI machine firmware with a custom PAYG chain of trust.
 2. systemd-boot
 3. A Unified Kernel Image, which combines systemd-stub with Linux and an
    initramfs configured for PAYG.
 4. The root filesystem, which is the same as the regular Endless OS
    filesystem.

Read on for more details on each component.

### 1. Machine firmware

The machine's chain of trust is replaced with EOS PAYG-specific certificates.
This means that only Endless OS can be booted on the PAYG machine.

Kernel parameters are predefined in the EFI variables as well.

### 2. systemd-boot

PAYG requires customized versions of systemd-boot and ostree.

systemd-boot doesn't work with OSTree, as documented in ostree issue
#1719
["systemd-boot support"](https://github.com/ostreedev/ostree/issues/1719).
OSTree expects to control the bootloader configuration using a symlink.
Meanwhile, systemd-boot expects bootloader configuration to be defined in
the EFI System Partition which uses a filesystem that doesn't support
symlinks (FAT). Endless patches work around this issue by defining a "fake"
in the ESP at `/loader.sln`, which OSTree writes and systemd-boot reads.

The systemd patches are maintained in <https://github.com/endlessm/systemd/>.
The following patch is relevant here:

  * "sd-boot: Read fake symlinks": Support the `/loader.sln` file.

OSTree patches are maintained in <https://github.com/endlessm/ostree>. The
customizations include:

  * "deploy: Create fake symlinks when on FAT filesystems": Creates the
    `/loader.sln` file.
  * "deploy: Handle efi blobs": Support for installing the PAYG UKI when
    building PAYG images.

When deploying a PAYG OSTree, the image builder script
([eib_image](https://github.com/endlessm/eos-image-builder/blob/master/stages/eib_image))
sets `OSTREE_DEPLOY_PAYG=1` before running `ostree admin deploy`.

This causes OSTree to read the kernel binary from
`/usr/lib/modules/${version}/payg-image.efi`, instead of the usual file
`vmlinuz`. It is installed in to the ESP within `/ostree` under a name
like `payg-image-$(version).efi`.

OSTree writes a `loader.conf` file which instructs systemd-boot to boot the
UKI. Here's an example:

```
options rw splash plymouth.ignore-serial-consoles quiet loglevel=0 ostree=/ostree/boot.1/eos/062797f96d2205843b2278646feb7eb4b30d616090e96211020178425b4b54a4/0
efi /ostree/eos-062797f96d2205843b2278646feb7eb4b30d616090e96211020178425b4b54a4/payg-image-6.14.0-17-generic.efi
```

### 3. UKI

The UKI is built by element `eos/payg/uki.bst`, and is then signed and installed
in the image at the path expected by OSTree by `eos/payg/uki-signed.bst`. 

Control passes from systemd-boot to the UKI, and the entry point in the UKI is
[systemd-stub](https://www.freedesktop.org/software/systemd/man/latest/systemd-stub.html#).

The Endless patches to systemd include the following to systemd-stub:

  * "sd-boot: Combine command line parameters for payg".

This forces systemd-stub to read kernel parameters from an EFI variable. Only certain
parameters (such as `ostree`) are honoured from the `options` field of the
`loader.conf` file.

The kernel has several patches related to PAYG including a custom security module (LSM).
These patches are maintained in: <https://github.com/endlessm/linux/>.

The initramfs includes some extra PAYG dracut modules defined in
[eos-payg](https://github.com/endlessm/eos-payg) and eos-payg-nonfree.git.

### 4. Root filesystem

The root filesystem is the same as a regular Endless system.

The eos-payg service activates in PAYG boots.

There are patches to GNOME Shell maintained in <https://github.com/endlessm/gnome-shell>
which provide the PAYG user interface.
