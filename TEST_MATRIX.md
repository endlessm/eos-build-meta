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

The following project options meaningfully affect the output of the OSTree stage:

  * `arch`: the target CPU architecture
  * `payg`: whether PAYG components are included
  * `signed_boot`: which signing method is used.

The `arch` setting is currently always `x86_64` as there is only one
supported architecture.

Official builds produced in CI from the 'main' branch always set `-o payg true`
and `-o signed_boot endless`.

Local builds set `payg` to false, which should not affect the behaviour of
images apart from `eosimpact-amd64-payg-base`. See
[`doc/howto/build-payg.md`](doc/howto/build-payg.md) for more information.

Local builds also set `-o signed_boot snakeoil`, which means the resulting
image will not be trusted by UEFI firmwares with Secure Boot enabled.
See [`doc/howto/test.md`](doc/howto/test.md) for a workaround.

The following scenarios need to be tested for the OSTree:

  1. Deploy as upgrade to the latest eos7 release (UEFI boot)
  2. Deploy as upgrade to the latest eos6 release (UEFI boot)
  3. Deploy as upgrade to the latest eos6 release (BIOS boot)

At least one test should be on a representative laptop so that we can see basic
hardware support is working. Others can be on a laptop or VM.

## Testing the Image stage

Image variants are listed in [`doc/overview/images.md`](./doc/overview/images.md).

We currently test two of these variants:

  1. eos-amd64-amd64-base
  2. eosimpact-amd64-payg-base

The following scenarios need to be tested for each image:

  1. Boot the disk image in a VM, using UEFI firmware with Secure Boot enabled.
