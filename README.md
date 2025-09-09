# Endless OS Build Metadata

The Endless OS Build Metadata repository is where the Endless OS team manages
build metadata for Endless OS.

The content of this repository is a
[BuildStream](https://www.buildstream.build/) project.
It is derived from [GNOME OS](https://os.gnome.org/), which is defined in the
[GNOME Build Metadata](https://gitlab.gnome.org/GNOME/gnome-build-meta/)
project.

EOS7 has documentation in this repository, starting with this README.

  * [`doc/howto/build.md`](./doc/howto/build.md), how to build EOS7

Overview documentation for understand the EOS7 architecture is in `doc/overview`:

  * [`doc/overview/boot.md`](./doc/overview/boot.md), covering how
    components involved in the EOS7 boot process are built and configured.
  * [`doc/overview/sysusers.md`](./doc/sysusers.md), covering how system
    users IDs are allocated.

## Build outputs

All versions of Endless OS are deployed using OSTree.

This repo contains one toplevel element, `eos/repo.bst` which outputs
an artifact with an OSTree repo containing a filesystem tree. This tree
can be deployed as an update to existing systems, or used to build a
bootable image.

The build and release workflows are implemented using Github Actions,
in this repo.

## Maintaining

### Overriding Elements

Files from a junction can be overriden to make them diverge.
For files in `gnome-build-meta`, this is done by checking out the file to
override from it.

Overridden files are prefixed with a comment like this, remember to add it to
newly overriden files:
```yml
# This is derived from gnome-build-meta 48.3, ensure to update it when rebasing.
```

Overridden files may refer to elements from where they are junctioned from, e.g.
from `gnome-build-meta`.
You will need to prefix references to these element name with their junction's
namespace, e.g. `some-dep.bst` becomes `my-junction.bst:some-dep.bst`.

### Rebasing

To rebase Endless OS on a newer version of GNOME OS, first update the reference
in the `elements/gnome-build-meta.bst` element.

Then overriden elements must be updated, which requires manual work.

Update the overriden elements to the matching version, removing the ones which
got removed, and moving the one which got moved.

Use the following to get the versions of the files from tag 48.3.
Note it doesn't remove the removed files and it doesn't move the moved files.

```sh
find elements -type f -name '*.bst' -exec git checkout 48.3 {} \;
```

Use the following command to know which files where created, removed, or moved
between the two versions.

```sh
git diff -M --summary 48.2 48.3
```

The overriden elements may refer to other files, e.g. sources in the `files/`
directory.
These files must be updated, removed, or moved accordingly.

Overridden elements and other files must have the prefix specifying they are
overriden be updated accordingly.

If an element was overridden to backport some changes and there is nothing more
to get from the junction, the junctioned element and its files can be removed.
