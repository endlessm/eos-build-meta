# This is derived from gnome-build-meta 48.3, ensure to update it when rebasing.

kind: meson
sources:
- kind: local
  path: files/os-release
build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/appstream-minimal.bst
depends:
- freedesktop-sdk.bst:bootstrap-import.bst
variables:
  meson-local: >-
    -Dbranch=%{branch}
    -Dvariant=user
    -Dimage-version=%{image-version}
