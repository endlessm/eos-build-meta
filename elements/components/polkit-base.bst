# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 components/_private/polkit-base.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: meson
description: |
  Overridden so we can name the privileged group "sudo" for backwards compatibility
  with Endless OS 6. https://github.com/endlessm/eos-build-meta/issues/91

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/gtk-doc.bst
- freedesktop-sdk.bst:components/perl-xml-parser.bst
- freedesktop-sdk.bst:components/strace.bst
- freedesktop-sdk.bst:components/systemd.bst

depends:
- freedesktop-sdk.bst:components/duktape.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/linux-pam.bst
- freedesktop-sdk.bst:components/systemd-libs.bst

variables:
  meson-local: >-
    -Dsession_tracking=logind
    -Dprivileged_group=sudo
  local_flags: -std=gnu++17

public:
  cpe:
    product: polkit
  bst:
    split-rules:
      polkit-gobject:
      - '%{includedir}/polkit-1/polkit'
      - '%{includedir}/polkit-1/polkit/**'
      - '%{datadir}/gettext'
      - '%{datadir}/gettext/**'
      - '%{libdir}/libpolkit-gobject-1.so*'
      - '%{libdir}/pkgconfig/polkit-gobject-1.pc'
      - '%{libdir}/girepository-1.0/Polkit-1.0.typelib'
      - '%{datadir}/gir-1.0/Polkit-1.0.gir'

sources:
- kind: git_repo
  url: github:polkit-org/polkit.git
  track: '[0-9]*'
  ref: 127-0-g9e4894c969eecf26a3ba762f4f7a268aa0fb3e51
  version-guess-pattern: '\d+'
