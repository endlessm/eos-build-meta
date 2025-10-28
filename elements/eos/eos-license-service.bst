kind: autotools
description: |
   GJS service that extracts all the license files on demand.

sources:
- kind: git_repo
  url: github:endlessm/eos-license-service.git
  track: Release_*
  ref: Release_6.0.7-0-g56aba79154be06970fd3795f3a801d6d0676c208

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

depends:
- gnome-build-meta.bst:sdk/gjs.bst
- freedesktop-sdk.bst:components/systemd.bst
