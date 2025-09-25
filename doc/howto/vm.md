# How to set up virtual machines for testing EOS7 images

## Introduction

This is a guide for engineers who want to test EOS7 images in virtual machines.

(If you're an end-user who wants to try Endless OS, see this guide instead:
[Support & Training > Installation](https://support.endlessos.org/en/installation).

We recommend using libvirt to create and manage VMs on Linux.  It acts as a
frontend to QEMU. This guide covers libvirt's commandline tools.  There is also
a graphical interface to libvirt called virt-manager.

It's possible to create a VM by calling QEMU's commandline tools directly
instead of going via libvirt. That's out of scope for this guide.

## Prerequisites

You need an `x86_64` machine running an up-to-date Linux distribution.

You will need to set up libvirt and QEMU. Check documentation for your
distribution, for example:

  * Debian: ["libvirt"](https://wiki.debian.org/libvirt)
  * Fedora: ["Virtualization – Getting Started"](https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/)
  * Ubuntu: ["Libvirt"](https://documentation.ubuntu.com/server/how-to/virtualisation/libvirt/)

Check your machine has the hardware virtualization CPU feature enabled,
by running this command and seeing if there is output:

    $ LC_ALL=C.UTF-8 lscpu | grep Virtualization

If there's no output, the machine firmware has probably disabled hardware
virtualization. Look for documentation from the manufacturer on how to enable
it in the firmware setup.

## Creating a VM from a raw disk image with `virt-install`

See [doc/howto/build.md](./build.md) for instructions on building images.

Take the raw image output, uncompress it and make it accessible by the `qemu`
user. A simple way to do that might be copying it inside
`/var/lib/libvirt/images`.

Then, run `virt-install`, which uses the libvirt API to create and provision a
new VM. Here's an example command:

    image=/var/lib/libvirt/images/eoscustom-master-amd64-amd64.250924-165621.base.img
    virt-install \
        --connect qemu:///system \
        --name eos-test-1 \
        --osinfo eos6.0 \
        --cpu host-model \
        --vcpus 2 \
        --memory 2048 \
        --boot uefi \
        --noautoconsole \
        --import \
        --disk path=$image,format=raw 

This creates a VM named `eos-test-1`. Note the following details:

  * `--boot uefi` forces use of UEFI firmware, with UEFI Secure Boot enabled,
    and the default Microsoft chain of trust.
  * `--noautoconsole` causes virt-install to exit once the VM is created,
    instead of waiting for a console to appear.
  * `--import` and `--disk` mean the raw disk image file will be used directly
    as the virtual machine's hard disk.

Read the
[virt-install manual](https://github.com/virt-manager/virt-manager/blob/main/man/virt-install.rst) 
for more details on the program.

If you are booting a locally built image, remember that the second stage bootloader
is signed with a "snakeoil" signing key that is not in the firmware's initial
chain of trust.

The first stage bootloader (Shim) is signed by Microsoft, so the firmware will load
Shim and you'll then see an error like "Verification failed". See `doc/howto/test.md`
for guidance on how to enrol the "snakeoil" key as a Machine Owner Key.
