# How to test EOS7

## Introduction 

This is a guide for developers, integrators and testers working on EOS7,
documenting how to test in-development versions.

See [TEST_MATRIX.md](../../TEST_MATRIX.md) for a formal list of the
deployment scenarios we test for EOS7.

It's possible to test in a virtual machine and on real hardware. Specific
guidance for virtual machines is written up separately here:

  * [`doc/howto/vm.md`](./vm.md)

## Testing the OSTree stage: Deploying as an upgrade to the latest eos6 or eos7 release

### Prerequisites

You will need the following.

1. A machine running EOS6 or EOS7

2. A machine serving the eos7 ostree that you want to test.

  * For automated builds, the Endless OSTree server (`https://ostree.endlessm.com`)
    has the tree.
  * For local builds, use the eos-build-meta `make ostree-serve` target.

3. The GPG key which signed the eos7 ostree

  * For automated builds, this is an Endless OSTree signing key, which should
    already be a trusted key for the remote in EOS6 and EOS7.
  * For local builds, this is found in `files/ostree-config/eos.gpg`.

### Test steps

For automated builds from eos-build-meta's 'main' branch, use the existing
`eos` remote, and follow the instructions at
["Endless OS master development version"](https://support.endlessos.org/en/dev/switch-master).

If it's a local build, add a new `local` OSTree remote in the target machine as
follows:

    # Replace `server` with address or hostname of the machine serving the repo. 
    sudo ostree remote add local http://server:8000

    # Paste in public key from `files/ostree-config/eos.gpg`, then CTRL-D.
    sudo ostree remote gpg-import local --stdin

Then deploy the new tree:

    sudo ostree pull local os/eos/amd64/master
    sudo ostree admin deploy os/eos/amd64/master

Reboot the machine to start the new version of EOS7.

### Notes

The `make ostree-serve` target runs `utils/run-local-repo.sh`. By default this
uses a slow webserver built into Python. If `caddy` is available it'll use that
and things will go much faster.

## Testing the Image stage

### Prerequisites

For testing in a VM, see: [`doc/howto/vm.md`](./vm.md).

### Test steps

1. Boot the disk image.

2. If necessary, enrol the 'snakeoil' certificate in the chain of trust. (See below).

3. Run through initial setup to create a user.

4. Ensure the desktop works as you expect.

### Enrolling the 'snakeoil' certificate in the UEFI Secure Boot chain of trust

Official builds of Endless OS are signed with a secret key that is signed by
Microsoft. You shouldn't need any extra setup in this case, assuming the
machine firmware has the default Microsoft chain of trust set up.

Local builds sign the boot components with an untrusted 'snakeoil' key that
anyone can use to sign software. When testing local builds, you can enrol the
corresponding certificate as a Machine Owner Key on first boot.

**NOTE: This bypasses any security guarantees you might get from Secure Boot. As
always, don't keep valuable data on machines that you use for testing software.**

The 'snakeoil' certificate is included in the EFI System Partition in local
builds, at `EFI/VENDOR-snakeoil.dep`. Here's how to enrol it in the chain of
trust:

1. Boot the machine. You should see the Shim "fallback" bootloader, followed by
   a "Verification failed" error from Shim itself.

2. Press "Enter" to continue, then press "Enter" again to open Mokmanager.

3. In the main "Perform MOK management" menu, select "Enroll key from disk".

4. Navigate to `EFI/VENDOR-snakeoil.dir` and select it.

5. Select "Continue" to reach the "Enrol the key?" menu. Then select "Yes".

6. Select "Reboot".

There is a video available showing the process:
[test-enrol-snakeoil-cert.webm](./test-enrol-snakeoil-cert.webm).

For an overview of the components involved in booting Endless OS, see:
[`doc/overview/boot.md`](../overview/boot.md).
