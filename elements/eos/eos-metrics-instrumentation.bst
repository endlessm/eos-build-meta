kind: meson

sources:
- kind: git_repo
  url: github:endlessm/eos-metrics-instrumentation.git
  track: Release_*
  ref: Release_6.0.7-0-g5ddf715a179184b8a67616190348094826881b77

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- gnome-build-meta.bst:core-deps/python-dbusmock.bst

depends:
- eos/eos-metrics.bst
- freedesktop-sdk.bst:components/flatpak.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:components/python3-dbus.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/util-linux.bst
- gnome-build-meta.bst:core-deps/libgtop.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/json-glib.bst
