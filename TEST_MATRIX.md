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

We currently test these variants:

  1. eos-amd64-amd64-base
  2. eosimpact-amd64-payg-base
  3. eosinstaller-amd64-amd64-base

### `eos-amd64-amd64-base`

The "regular" Endless OS 7 image.

Test that the disk image boots in a machine with UEFI Secure Boot enabled
and the default chain of trust.

Also test that the ISO boots into a working live media. (This requires some
special services defined in
[eos-boot-helper](https://github.com/endlessm/eos-boot-helper)).

### `eosimpact-amd64-payg-base`

The Pay As You Go image.

See the (internal) repository eos-payg-nonfree for the `eos-payg-demo` tool,
and see the (internal) documentation on PAYG.

### `eosinstaller-amd64-amd64-base`

The installer image.

This requires further work, see: #15 ["Make eos-installer work"](https://github.com/endlessm/eos-build-meta/issues/15).
