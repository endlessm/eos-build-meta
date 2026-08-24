# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.beta gnomeos/os-release.bst

kind: meson
sources:
- kind: local
  path: files/os-release
build-depends:
- (@): gnome-build-meta.bst:include/gcc-for-recc.yml
- gnome-build-meta.bst:buildsystems/meson.bst
- freedesktop-sdk.bst:components/appstream-minimal.bst
depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
variables:
  meson-local: >-
    -Dbranch=%{branch}
    -Dimage-version=%{image-version}
    -Dvariant=user
