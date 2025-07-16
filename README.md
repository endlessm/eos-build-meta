# Endless OS Build Metadata

The Endless OS Build Metadata repository is where the Endless OS team manages
build metadata for Endless OS.

The content of this repository is a
[BuildStream](https://www.buildstream.build/) project.
It is derived from [GNOME OS](https://os.gnome.org/), which is defined in the
[GNOME Build Metadata](https://gitlab.gnome.org/GNOME/gnome-build-meta/)
project.

## Build outputs

Some of the possible build outputs are documented below.

### Endless OS

To build the Endless OS "secure boot" image locally:

1. Generate keys:
```
$ make -C files/boot-keys clean
$ make -C files/boot-keys
```

2. Build the disk image (first command) or the ISO installer (second command):
```
$ bst build gnome-build-meta.bst:gnomeos/image.bst
$ bst build gnome-build-meta.bst:iso/image.bst
```

3. Checkout the image or installer:
```
$ bst artifact checkout gnome-build-meta.bst:gnomeos/image.bst --directory ./disk
$ bst artifact checkout gnome-build-meta.bst:iso/image.bst --directory ./iso
```
