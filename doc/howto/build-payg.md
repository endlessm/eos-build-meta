# How to build PAYG images of Endless OS

## Introduction

This is a guide for Endless staff working on the PAYG variant of Endless OS.
We assume you already followed [`doc/howto/build.md`](doc/howto/build.md)
and are able to build the OSTree and Image stages for the regular version of
Endless OS.

Information here is up-to-date as of 2025-10-27.

## OSTree stage (payg=true)

The PAYG feature includes some private components. The regular version of
Endless OS is completely open, and the default build configuration of
eos-build-meta skips the PAYG components.

Automated builds in CI always include the PAYG components, and builds
from 'main' are signed with the Endless PAYG certificate.

The PAYG early boot support is compiled into a UKI available at:

    /usr/lib/modules/$kernel_version/payg-image.efi.

For PAYG to work as intended, this must be signed with the Endless PAYG UEFI
certificate, which can only be done in CI. Local builds will sign the UKI with
the 'snakeoil' certificate.

Here are instructions on how to enable the PAYG feature and build it.

### A Github Access Token in your `~/.netrc` file

BuildStream needs a credential to access the private repositories. This
is done by creating a Github access token, and adding it to your user's
netrc file.

To create a token, go to <https://github.com/settings/personal-access-tokens>.
(Or access Github's "Settings" screen, choose "Developer Settings", "Personal
access token" and then "Fine-grained tokens").

Click "New". You may get an authentication check at this point.

Set the "Resource owner" to "endlessm" so the token is managed by the Endless
Github org.

Choose a meaningful "Token name" and a useful "Expiration" time.

Under "Repository access", select "All repositories".

Under "Permissions" > "Add permissions", select "Contents".

Click "Generate token", and copy the resulting private token to the clipboard.
Now, create or modify your a file named `.netrc` in your user's home directory on the build
machine. Following [netrc format](https://everything.curl.dev/usingcurl/netrc.htmlpyth), add
an entry for machine `github.com`, with `login` set to your Github username, and `password`
set to the private token.

For example:

```
machine github.com
login ssssam
password github_pat_123456789
```

Make sure the file is readable only by your user:

    chmod 0600 ~/.netrc

The
[`git_repo` source plugin](https://buildstream.gitlab.io/buildstream-plugins-community/sources/git_repo.html)
will then authenticate as you when pulling from Github, and the token will grant
access to private repos in the Endless Github organisation.

### Building with `-o payg true`

To build the OSTree stage with PAYG enabled, follow the usual instructions
with the following changes:

  * Pass `-o payg true` to `bst`
  * Pass `BST="bst -o payg true" to `make`

That's it!

## Image stage (eosimpact-amd64-payg-base)

Automated nightly builds happen in Jenkins in the nightly-master-pipeline.

Images can be downloaded from [images.endless.org](https://images.endlessos.org/)
inside the following directory:

  * <https://images.endlessos.org/files/nightly/eosimpact-amd64-payg/master/base/>

For local builds, clone the internal repo endless-image-config.git alongside
eos-image-builder.git.

Run the following to build the PAYG image:

    sudo ../eos-image-builder/eos-image-builder --localdir .  --product=eosimpact --arch=amd64 --platform=payg --personality=base master 

This `doc/overview/images.md` for more details on how the PAYG image build is
special.
