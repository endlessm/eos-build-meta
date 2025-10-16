# utils/update-elements.sh: Derived from gnome-build-meta.bst 48.3 gnomeos/os-release-user.bst

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
