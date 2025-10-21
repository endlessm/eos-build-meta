kind: meson
description: |
  Endless OS pay-as-you-go daemon

build-depends:
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- gnome-build-meta.bst:sdk/gtk-doc.bst

depends:
- gnome-build-meta.bst:sdk/glib.bst
- eos/payg/libpeas-1.bst

sources:
- kind: git_repo
  url: github:endlessm/eos-payg.git
  track: master
  ref: Release_6.0.7-2-ge4c0993ad5748b3728c337d2a42cbae915cf025c
- kind: git_module
  path: subprojects/libglnx
  url: gnome:libglnx.git
  ref: b38235ac2d8f1a7b1b8b9960a109eb734b8ec4dd
- kind: git_module
  path: subprojects/libgsystemservice
  url: gnome_gitlab:pwithnall/libgsystemservice.git
  ref: 58468f2622e1415b5d1d2ffa06864ab31ab12c9a

variables:
  meson-local: >-
    -Ddefault_library=both
    -Dlibgsystemservice:default_library=static
