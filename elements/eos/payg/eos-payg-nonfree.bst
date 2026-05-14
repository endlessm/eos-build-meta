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
- freedesktop-sdk.bst:components/curl.bst
- freedesktop-sdk.bst:components/openssl.bst

runtime-depends:
- freedesktop-sdk.bst:components/efitools.bst

sources:
- kind: git_repo
  url: github:endlessm/eos-payg-nonfree
  track: master
  ref: 4c4749b7d97438e4186267e6da25dffa5699efc8

variables:
  meson-local: >-
    -Dfactorylibexecdir=/usr/lib/eos-payg-nonfree
