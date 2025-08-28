kind: autotools
description: Endless factory tools.

sources:
- kind: git_repo
  url: github:endlessm/eos-factory-tools.git
  track: master
  ref: 15840dcdf5504f403053c99883f43b4b40632ec0

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:core-deps/udisks2.bst

runtime-depends:
- freedesktop-sdk.bst:components/dracut.bst
- gnome-build-meta.bst:core/gnome-console.bst
- gnome-build-meta.bst:core/mutter.bst
- freedesktop-sdk.bst:components/dracut.bst

variables:
  conf-local: >-
    --enable-systemd
