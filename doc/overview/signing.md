# Endless OS signing process

This document give an overview of how components in Endless OS 7 are signed.
It's up to date as of 2025-09-26.

Endless OS is developed in the open. All proposed changes are reviewed by
the Endless OS team, and are only merged to the 'main' branch of
eos-build-meta.git if they meet expected quality and security standards.

When the Endless build servers produce images from the 'main' branch,
components of the OS are signed with secret keys owned by Endless, which
certifies them as official builds of Endless OS.

In all other cases, the components are signed with 'snakeoil' keys. These
are not kept secret (in fact, they are commited to this repo), so there's
no guarantee you can trust an image signed with the 'snakeoil' keys. This
setup is used for development and testing of new versions of Endless OS.

## Components that are signed

The following components carry a signature:

 1. Shim, the first stage bootloader.
 2. GRUB, the second stage bootloader.
 3. Linux, the kernel.
 4. Kernel modules built from the Linux source tree.
 5. The OSTree commit containing the system root filesystem.

## Signing methods

### Signing Shim

The [endless/shim-review](https://github.com/endlessm/shim-review/) project
on Github tracks requests for Microsoft to sign prebuilt binaries of the
first-stage bootloader (Shim) with a standard "Microsoft Corporation UEFI CA"
key.

We request a Microsoft signature for Shim because almost all machine firmwares
ship with the "Microsoft UEFI CA" certificate in their default chain of trust,
so this allows Endless OS to work out-of-the-box everywhere.

The Shim binary embeds a "EOS UEFI Signing" certificate which can be used to
validate the second stage bootloader and the kernel.

### Signing GRUB

The second stage bootloader is signed in one of two ways, depending on the
`signed_boot` project option.

When `signed_boot == "snakeoil"`, the element `eos/signed-grub-snakeoil.bst`
produces a signed GRUB using the public `VENDOR-snakeoil` key.

When `signed_boot == "endless"`, the element `eos/signed-grub.bst`
requests an official signature from the internal eos-sb-signer service.

GRUB loads the kernel and verifies its signature against the chain of trust
provided by Shim via the `shim_lock` API.

### Signing Linux and kernel modules

The kernel is signed in one of two ways, depending on the `signed_boot` project
option.

When `signed_boot == "snakeoil"`, the element `signing/signed-kernel-snakeoil.bst`
produces a signed kernel using the public `VENDOR-snakeoil` key.

In this case, the kernel embeds the `MODULES-snakeoil` certificate and can
use that to validate modules.

When `signed_boot == "endless"`, the element `signing/signed-kernel-endless.bst`
requests an official signature from the private eos-sb-signer service.

In this case, the kernel generates a new private key and certificate as part
of the build process. It signs the modules with the key, and embeds the
certificate for verification. At the end of the build the key is discarded,
so that when the kernel checks signatures, it'll only ever load modules that
were signed as part of the given build.

Key generation and signing is done by the Linux build system.
For more details, see the Linux kernel user's and administrator's guide,
under:
["Core-kernel subsystems > Kernel module signing facility"](https://www.kernel.org/doc/html/latest/admin-guide/module-signing.html)

## Signing the OSTree commit

The final OSTree commit is built in `repo.bst`. At this point it isn't
signed.

In local builds using the Makefile, the user needs to run `make ostree-gpg`
the first time they build. This creates a new PGP keypair. The `update-ostree`
make target then calls `utils/update-repo.sh`, which checks out the
`repo.bst` artifact and imports it into the local OSTree repo `./ostree-repo`.
The commit in `ostree-repo.bst` is signed with the local private key.

When deploying a locally built OSTree stage, the public part of the key is
imported into the target machine. This is documented in
[`doc/howto/test.md`](./doc/howto/test.md)

When building a local image, the public part of the key needs to be added
to eos-image-builder as it will verify the OSTree commit.

In official builds on Endless build machines, "EOS OSTree Signing Key"
is available to sign the OSTree. The public part of this key is shipped
in existing and new versions of Endless OS, so users can seamlessly update to
new official versions.

# Further reading

See [`doc/overview/boot.md`](./boot.md) for an overview of the boot process,
including the UEFI Secure Boot signature checks.
