kind: meson
description: |
  Tools and configuration to integrate the Kolibri flatpak with Endless OS.

sources:
- kind: git_repo
  url: github:endlessm/eos-kolibri.git
  ref: c31e4183156b5e780895d84ed84add99b41fa13b

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- freedesktop-sdk.bst:components/systemd.bst

runtime-depends:
- freedesktop-sdk.bst:components/flatpak.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-click.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/pygobject.bst
