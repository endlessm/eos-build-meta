# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-24.08.26 components/ostree.bst

kind: autotools
description: |
  OSTree with customizations by Endless.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- freedesktop-sdk.bst:components/git-minimal.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/bison.bst

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

(@):
- elements/include/ostree-source.yml
