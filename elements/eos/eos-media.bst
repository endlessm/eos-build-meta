kind: meson
description: Endless OS wallpaper.

sources:
- kind: git_repo
  url: github:endlessm/eos-media.git
  track: Release_*
  ref: Release_6.0.7-0-g3f42869c4d20fe1343a43974ec1d3f2a0685ba3a

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
