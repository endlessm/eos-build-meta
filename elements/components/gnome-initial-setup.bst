# Adapted from elements/core/gnome-initial-setup.bst in gnome-build-meta 48.3.
kind: meson
description: |
  GNOME Initial Setup with Endless customizations.

sources:
- kind: git_repo
  url: github:endlessm/gnome-initial-setup
  track: master

  ref: Release_6.0.7-2-g8cd2a68439d45bc84f0236af34ea05eab3f38197
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
- eos/eos-metrics.bst

variables:
  meson-local: >-
    -Dparental_controls=enabled
