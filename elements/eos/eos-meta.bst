kind: meson
description: eos-meta provides Endless OS engineering scripts and mimeapps.list.

sources:
- kind: git_repo
  url: github:endlessm/eos-meta.git
  ref: 99a2e64ab8e42b8d3e589bdaa76d320f59999798

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
