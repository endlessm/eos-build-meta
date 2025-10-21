kind: meson
description: |
  Private components of PAYG systems.

  Source for this element is only available within Endless. Use the `payg` build option
  to opt in to building it.

build-depends:
- eos/black.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- eos/payg/eos-payg.bst
- eos/payg/libsodium.bst

sources:
- kind: git_repo
  url: github:endlessm/eos-payg-nonfree
  track: master
  ref: Release_6.0.7-6-ge1a4545cf194cae4cd047d6896995764e6b6cdca

variables:
  meson-local: >-
    -Dfactorylibexecdir=/usr/lib/eos-payg-nonfree
