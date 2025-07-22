kind: meson

sources:
- kind: git_repo
  url: github:endlessm/eos-meta.git
  ref: 117079ba9747c0b758d4155bd1837a9f32615f9b

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
