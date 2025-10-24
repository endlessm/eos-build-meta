# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-24.08.23 components/flatpak.bst

kind: meson
description: |
  Overridden to modify elements/include/flatpak.yml to apply patches.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/docbook-xsl.bst
- freedesktop-sdk.bst:components/xmlto.bst
- freedesktop-sdk.bst:components/gettext.bst
- freedesktop-sdk.bst:components/gobject-introspection.bst
- freedesktop-sdk.bst:components/libxslt.bst
- freedesktop-sdk.bst:components/python3-pyparsing.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/xmlto.bst

depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/bubblewrap.bst
- freedesktop-sdk.bst:components/gpgme.bst
- freedesktop-sdk.bst:components/libarchive.bst
- freedesktop-sdk.bst:components/libxml2.bst
- freedesktop-sdk.bst:components/curl.bst
- freedesktop-sdk.bst:components/xorg-lib-xau.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:components/fuse3.bst
- freedesktop-sdk.bst:components/json-glib.bst
- freedesktop-sdk.bst:components/appstream.bst
- freedesktop-sdk.bst:components/libseccomp.bst
- freedesktop-sdk.bst:components/polkit.bst
- freedesktop-sdk.bst:components/systemd-libs.bst
- freedesktop-sdk.bst:components/xdg-dbus-proxy.bst


variables:
  meson-local: >-
    -Dgtkdoc=disabled
    -Dsystem_bubblewrap=bwrap
    -Dhttp_backend=curl
    -Ddconf=disabled
    -Dmalcontent=disabled
    -Dselinux_module=disabled
    -Dtests=false
    -Dsystem_dbus_proxy=xdg-dbus-proxy

sources:
- kind: git_repo
  url: github:flatpak/flatpak.git
  track: 1.1[02468]*
  ref: 1.16.1-0-gb676905d91aa3c4e524ca663784d4cf085c465d7
# Override: Apply patches.
- kind: patch
  path: patches/flatpak/revert-extra-data-sandbox.patch
