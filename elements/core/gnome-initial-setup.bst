# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.0 gnome-initial-setup.bst

kind: meson

sources:
- kind: git_repo
  url: github:endlessm/gnome-initial-setup.git
  track: 237-rebase-51.0
  ref: dbd0087adcd40d69bc75764aca867a7a2dfc544a
build-depends:
- (@): gnome-build-meta.bst:include/gcc-for-recc.yml
- gnome-build-meta.bst:buildsystems/meson.bst

depends:
- gnome-build-meta.bst:core-deps/NetworkManager.bst
- gnome-build-meta.bst:core-deps/accountsservice.bst
- gnome-build-meta.bst:core-deps/geocode-glib.bst
- gnome-build-meta.bst:core-deps/gnome-online-accounts.bst
- gnome-build-meta.bst:core-deps/ibus-daemon.bst
- gnome-build-meta.bst:core-deps/libgweather.bst
- gnome-build-meta.bst:core-deps/libnma.bst
- gnome-build-meta.bst:core-deps/librest.bst
- gnome-build-meta.bst:core-deps/malcontent.bst
- gnome-build-meta.bst:core-deps/upower.bst
- gnome-build-meta.bst:core/gdm.bst
- gnome-build-meta.bst:core/gnome-desktop.bst
- gnome-build-meta.bst:sdk/adwaita-icon-theme.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/libadwaita.bst
- gnome-build-meta.bst:sdk/webkitgtk-6.0.bst
- freedesktop-sdk.bst:components/geoclue-libs.bst
- freedesktop-sdk.bst:components/gstreamer.bst
- freedesktop-sdk.bst:components/pwquality.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- eos/eos-license-service.bst
- eos/eos-metrics.bst

variables:
  meson-local: >-
    -Dparental_controls=enabled
