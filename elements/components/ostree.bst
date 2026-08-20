# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 components/ostree.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: autotools
description: |
  OSTree with customizations by Endless.

(@):
- elements/include/ostree-source.yml

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- freedesktop-sdk.bst:components/_private/git-minimal.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/systemd.bst

depends:
- freedesktop-sdk.bst:components/avahi-libs.bst
- freedesktop-sdk.bst:components/avahi.bst
- freedesktop-sdk.bst:components/composefs.bst
- freedesktop-sdk.bst:components/curl.bst
- freedesktop-sdk.bst:components/e2fsprogs.bst
- freedesktop-sdk.bst:components/fuse3.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/gnupg.bst
- freedesktop-sdk.bst:components/gpgme.bst
- freedesktop-sdk.bst:components/libarchive.bst
- freedesktop-sdk.bst:components/systemd-libs.bst

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
