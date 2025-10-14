kind: meson

sources:
- kind: tar
  url: gnome_downloads:gnome-initial-setup/48/gnome-initial-setup-48.1.tar.xz
  ref: b3dabf7e79b665ff12241fbdba615489513d886224759986af8f48657592315e
build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

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
- gnome-build-meta.bst:core/gnome-keyring.bst
- gnome-build-meta.bst:sdk/adwaita-icon-theme.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/libadwaita.bst
- gnome-build-meta.bst:sdk/webkitgtk-6.0.bst
- freedesktop-sdk.bst:components/geoclue-libs.bst
- freedesktop-sdk.bst:components/gstreamer.bst
- freedesktop-sdk.bst:components/pwquality.bst
- freedesktop-sdk.bst:bootstrap-import.bst

variables:
  meson-local: >-
    -Dparental_controls=enabled
