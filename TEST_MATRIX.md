# Test matrix for Endless OS (base operating system.)

This documents the set of variants of EOS and the test scenarios used to gate
changes and releases of EOS7.

The testing should ensure the following base OS functionality is working:

  * Boot process
  * Install process
  * Upgrade process
  * Core GNOME app functionality
  * Hardware support

As the build process is split into two stages (OSTree and Image),
so is the test matrix.

For information on how to test each scenario, see
[`doc/howto/test.md`](./doc/howto/test.md).

## Testing the OSTree stage

There is one variant of the ostree stage:

  * arch=amd64 (the user tree for all EOS7 systems)

The following scenarios need to be tested for the OSTree:

  1. Deploy as upgrade to the latest eos7 release (UEFI boot)
  2. Deploy as upgrade to the latest eos6 release (UEFI boot)
  3. Deploy as upgrade to the latest eos6 release (BIOS boot)

At least one test should be on a representative laptop so that we can see basic
hardware support is working. Others can be on a laptop or VM.

## Testing the Image stage

There is 1 variant of the image stage:

  * product=eos flavor=base platform=amd64

The following scenarios need to be tested for the image:

  1. Boot the disk image in a VM, using UEFI firmware with Secure Boot enabled.
