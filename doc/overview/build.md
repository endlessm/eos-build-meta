# Endless OS 7 build process

This document gives an overview of the tools used to build Endless OS 7.

For guidance on how to build EOS7, see: [`doc/howto/build.md`](doc/howto/build.md).

## OSTree build stage

This stage is defined in
[eos-build-meta.git](https://github.com/endlessm/eos-build-meta/) using the BuildStream build tool.

It uses some 3rd party BuildStream plugins, which are listed in `project.conf`.

It uses elements from Freedesktop SDK and GNOME Build Metadata via the junction
elements `freedesktop-sdk.bst` and `gnome-build-meta.bst`.

More details on each of these concepts below.

### BuildStream

BuildStream's documentation is available at:
<https://docs.buildstream.build/>.

Note that BuildStream is a plugin-based tool. Source fetching is done via
*source plugins*, and element builds are handled by *element plugins*.

The core of BuildStream ships a small set of plugins. Their documentation
is found in the BuildStream manual under
["Reference > Plugin specific documentation"](https://docs.buildstream.build/master/core_plugins.html).

### BuildStream Plugins

The BuildStream Plugins project is a set of source and element plugins
maintained by the BuildStream core team.

Documentation for BuildStream Plugins is available at:
<https://apache.github.io/buildstream-plugins/>.

### BuildStream Community Plugins

The BuildStream Community Plugins project is a set of 3rd party source and
element plugins. Some of these are developed and maintained as part of the
Freedesktop SDK project.

Documentation for BuildStream Community Plugins is available at:
<https://buildstream.gitlab.io/buildstream-plugins-community/>.

### Freedesktop SDK

Freedesktop SDK provides integration instructions for a Linux runtime,
using components commonly used in many Linux distributions.

Some documentation for Freedesktop SDK is available at:
<https://freedesktop-sdk.gitlab.io/documentation/>.

Freedesktop SDK defines elements for many open source components in the
[`components/` subdirectory](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/tree/master/elements/components).
These roughly map to packages available in package-based Linux distros.

Higher level groupings are available as stacks in the
[`public-stacks/` subdirectory](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/tree/master/elements/public-stacks?ref_type=heads).
These can be useful as dependencies when defining your own elements.

### GNOME Build Metadata

The GNOME project maintains build instructions for the entire GNOME platform
in the repo
[gnome-build-meta.git](https://gitlab.gnome.org/GNOME/gnome-build-meta/).

This repo is a BuildStream project which uses Freedesktop SDK to provide the
base platform (via a junction in
[freedesktop-sdk.bst](https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/master/elements/freedesktop-sdk.bst)).

GNOME OS is also defined in gnome-build-meta.git, with most of the integration
instructions in the
[gnomeos/ subdirectory](https://gitlab.gnome.org/GNOME/gnome-build-meta/-/tree/master/elements/gnomeos). Note that GNOME OS defines the image build process using BuildStream,
unlike Endless OS which uses eos-image-builder for that.

### Endless OS Build Metadata

Now we get to [eos-build-meta.git](https://github.com/endlessm/eos-build-meta)
where the magic happens.

The base platform for EOS7 is Freedesktop SDK, included via the
[freedesktop-sdk.bst junction element](https://github.com/endlessm/eos-build-meta/blob/main/elements/freedesktop-sdk.bst).
This provides build tools and many system components. In eos-build-meta,
the junctioned elements are referred to via the junction, e.g.
`components/podman.bst` becomes `freedesktop-sdk.bst:components/podman.bst`.

The integration instructions for some Freedesktop SDK elements are overridden to
alter how they are built or configured for EOS. Some of these overrides have to
be copied manually from GNOME OS.

All of GNOME is brought in via the
[gnome-build-meta.bst junction element](https://github.com/endlessm/eos-build-meta/blob/main/elements/gnome-build-meta.bst).
There are some overrides here too. In particular, the nested junction element
`gnome-build-meta.bst:freedesktop-sdk.bst` is overriden with our own local
junction element.

The eos-build-meta project defines integration instructions for more Endless specific
components.

It also defines the final filesystem trees for EOS7.

The base tree `eos` is defined in the following elements:

  * [`eos/deps.bst`](https://github.com/endlessm/eos-build-meta/blob/main/elements/eos/deps.bst),
    a stack element which lists each element to include.
  * [`eos/filesystem.bst`](https://github.com/endlessm/eos-build-meta/blob/main/elements/eos/filesystem.bst),
    a compose element that defines which *artifacts* to include, based on *split rules*.

The developer tree `eosdev` is defined in:

  * [`eosdev/filesystem.bst`](https://github.com/endlessm/eos-build-meta/blob/main/elements/eosdev/filesystem.bst)
    a compose element which includes additional 'devel' and 'doc' artifacts.

All the trees are exported in
[`repo.bst`](https://github.com/endlessm/eos-build-meta/blob/main/elements/repo.bst),
which a script element that creates the final filesystem trees and commits them
as branches in a sngle OSTree repository, ready for exporting.

The purpose the `filesystem.bst` elements is to exclude certain types of file
from the final image. For example, we don't want to include developer tools in
the base tree. For more information on how this works, see the BuildStream
manual's section on
["Using > Handling files > Composition"](https://docs.buildstream.build/master/handling-files/composition.html).

## Image build stage

This stage is defined in [eos-image-builder.git](https://github.com/endlessm/eos-image-builder).

For more information on this stage, see:

  * [`doc/overview/images.md`](./doc/overview/images.md)
  * The eos-image-builder
    [README](https://github.com/endlessm/eos-image-builder/blob/master/README.md)
  * The Endless Support & Training page
    ["Endless OS Image Builder"](https://support.endlessos.org/en/deployment/image-builder)
