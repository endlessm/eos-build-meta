# How to build EOS7

## Introduction 

This is a guide for developers, integrators and testers working on EOS7,
documenting how to build it.

*See `doc/overview/build.md` to understand the different components of the
build process.*

*See `doc/howto/test.md` for a guide on testing the thing you built.*

  * FIXME: not yet written

The EOS7 build process is split into two stages, and so is this guide:

  1. OSTree build (defined in [eos-build-meta.git](https://github.com/endlessm/eos-build-meta/))
  2. Image build (defined in [eos-image-builder.git](https://github.com/endlessm/eos-image-builder))

In many cases you only need to run the ostree build, as you can test a new ostree build
by deploying it as an update to an existing machine, as documented in `doc/howto/test.md`.

## OSTree build stage

### Automated Builds

Github Actions runs the OSTree build stage for each pull request open in
eos-build-meta.  It does not push the resulting OSTree anywhere, so you
can't use it directly. It does push all artifacts to the Endless cache server,
and you can pull these locally as part of your local build. Read on for how.

When a pull request lands in eos-build-meta's `main` branch, Github Actions
runs the OSTree build stage, and pushes the result to `os/eos/amd64/master`.
If you are looking to test something that is already merged to eos-build-meta's
`main` branch you don't need to build it yourself.

  * FIXME: This is not yet true, but should be soon. Currently it pushes to
    `os/eos/amd64/master`.

### Important note on local builds

A modern operating system contains many components. The BuildStream elements in
eos-build-meta define a pipeline that builds Endless OS from source code, using
only a minimal "binary-seed".
(See [bootstrappable.org](https://bootstrappable.org/) for why this is good).

Building every element in Endless OS from source takes a loooong time.
Endless provide an artifact cache with prebuilt artifacts for each element.
With correct configuration, BuildStream should download prebuilt artifacts
where possible and will only build elements locally if you have local changes
to that element or something that dependends on it.

In particular, if you see BuildStream building elements with names that
begin `freedesktop-sdk.bst:bootstrap/`, then stop, check your configuration,
and ask for help. This should only happen if you modified the
`freedesktop-sdk.bst` junction, and it means your build will take a very long
time.

### Prerequisites

 * Fast hardware & network.

### Setup steps

#### Install BuildStream

Install BuildStream and the necessary plugins and dependencies. It's recommended
to do this in venv, using [uv](https://docs.astral.sh/uv/), as follows:

    uv venv ./bst.venv
    uv pip install -p ./bst.venv dulwich requests tomlkit

You might need to add more packages on your machine. See also:

  * The BuildStream reference manual's
    ["Installing Dependencies"](https://docs.buildstream.build/master/main_install.html#installing-dependencies)
    section.
  * Freedesktop SDK guide's
    ["Prerequisites and dependencies"](https://freedesktop-sdk.gitlab.io/documentation/getting-started/prerequisites/)
    section

#### Configure BuildStream for Endless OS

It's important to set the configuration 

 * BuildStream configuration & tweaking.
 * Clone repo.
 * Make local signing keys

### Build steps

### Testing

It is possible to build and deploy development-only builds of Endless OS
manually.

You'll need to set up BuildStream with the necessary plugins and their
dependencies.

You can then use the Makefile to do the following:

  * Create fake signing keys: `make ostree-gpg`
  * Create/update a local OSTree repo from the `eos/repo.bst` element: `make ostree-repo`
  * Serve the repo over HTTP: `make ostree-serve`
See `

## Image build stage

### Automated builds

Image builds run nightly in an internal Jenkins instance. The results are
**TBD**.

### Prerequisites

  * Root

### Setup steps

  * Clone repo

### 

  * Run it
