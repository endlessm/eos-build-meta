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

runtime-depends:
- freedesktop-sdk.bst:components/efitools.bst

sources:
- kind: git_repo
  url: github:endlessm/eos-payg-nonfree
  track: master
  ref: Release_6.0.7-8-g4dc4892a7fad5129324f279a9a1e702f178d7e9a

variables:
  meson-local: >-
    -Dfactorylibexecdir=/usr/lib/eos-payg-nonfree
