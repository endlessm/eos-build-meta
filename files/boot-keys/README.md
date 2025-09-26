# Boot keys

This directory contains pre-generated keys for use with UEFI Secure Boot.
You can use these to produce local, signed builds of EOS7.

These keys are public and anyone can sign binaries with them, so they
provide no security whatsoever. They are labelled as "snakeoil" to make this
clear. (The name is a reference to fake medicines that were common in the 19th
century).

Official releases of Endless OS are signed with different keys which can only
be used by Endless to sign binaries that are reviewed and trusted.

The following keys are available:

  * `VENDOR-snakeoil`: Used to sign GRUB and kernel.
  * `MODULES-snakeoil`: Used to sign kernel modules.

The `MODULES-snakeoil` certificate is embedded in the built kernel, and the
kernel will only load modules signed with this key.

The first stage bootloader (Shim) and utilities are provided as
pre-signed binaries in `files/shim`.  The provided Shim binary will not load
software signed with the VENDOR-snakeoil key by
default.

You can use the `mokmanager` program to enrol `VENDOR-snakeoil` as a Machine
Owner Key so that you can boot your local build of EOS.  See
`doc/howto/test.md` for instructions on how to do that.
