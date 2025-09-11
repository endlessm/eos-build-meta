# How to test EOS7

## Introduction 

This is a guide for developers, integrators and testers working on EOS7,
documenting how to test in-development versions.

See [TEST_MATRIX.md](../../TEST_MATRIX.md) for a formal list of the
deployment scenarios we test for EOS7.

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
