# Based on compoments/ostree.bst from Freedesktop SDK 24.08.26.

kind: autotools
description: |
  OSTree with customizations by Endless.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- freedesktop-sdk.bst:components/git-minimal.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/gtk-doc.bst

depends:
- freedesktop-sdk.bst:components/composefs.bst
- freedesktop-sdk.bst:components/curl.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gpgme.bst
- freedesktop-sdk.bst:components/e2fsprogs.bst
- freedesktop-sdk.bst:components/fuse3.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/libarchive.bst
- freedesktop-sdk.bst:components/avahi.bst
- freedesktop-sdk.bst:components/gnupg.bst

variables:
  conf-local: >-
    --with-dracut
    --with-libsystemd
    --with-systemd
    --with-libarchive
    --with-avahi
    --with-curl
    --without-soup

public:
  bst:
    split-rules:
      devel:
        (>):
        - "%{libdir}/libostree.so"

sources:
- kind: git_repo
  url: github:endlessm/ostree.git
  track: master
  ref: Release_6.0.7-0-gf6848f2c8be006558c50175575ee8af9ae9b09d2
- kind: git_module
  path: libglnx
  url: gnome:libglnx.git
  ref: 07e3e49d3e47dfd4265ffb5495111439131715ca
- kind: git_module
  path: bsdiff
  url: github:mendsley/bsdiff.git
  ref: b817e9491cf7b8699c8462ef9e2657ca4ccd7667
- kind: git_module
  path: composefs
  url: github:containers/composefs.git
  ref: 412cb5e6aaf516c5e2a7f67e426a25ed2926e101
