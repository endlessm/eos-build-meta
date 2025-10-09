# This is derived from gnome-build-meta 48.3, ensure to update it when rebasing.

kind: meson

sources:
- kind: tar
  url: gnome_downloads:gnome-shell/48/gnome-shell-48.3.tar.xz
  ref: fb0203fc748593f14e51732618e1f042525fd719764a0fdb0ee3f6fe413a9b2b

build-depends:
- gnome-build-meta.bst:sdk-deps/sassc.bst
- gnome-build-meta.bst:core-deps/jasmine-gjs.bst
- freedesktop-sdk.bst:components/python3-docutils.bst
- freedesktop-sdk.bst:components/perl.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

runtime-depends:
- gnome-build-meta.bst:core-deps/libgweather.bst
- gnome-build-meta.bst:core/tecla.bst
- freedesktop-sdk.bst:components/geoclue-libs.bst

depends:
- gnome-build-meta.bst:core-deps/NetworkManager.bst
- gnome-build-meta.bst:core-deps/accountsservice.bst
- gnome-build-meta.bst:core-deps/dconf.bst
- gnome-build-meta.bst:core-deps/evolution-data-server.bst
- gnome-build-meta.bst:core-deps/gnome-autoar.bst
- gnome-build-meta.bst:core-deps/startup-notification.bst
- gnome-build-meta.bst:core-deps/upower.bst
- gnome-build-meta.bst:core/gdm.bst
- gnome-build-meta.bst:core/gnome-bluetooth.bst
- gnome-build-meta.bst:core/gnome-desktop.bst
- gnome-build-meta.bst:core/gnome-settings-daemon.bst
- gnome-build-meta.bst:core/mutter.bst
- gnome-build-meta.bst:sdk/adwaita-icon-theme.bst
- gnome-build-meta.bst:sdk/gcr.bst
- gnome-build-meta.bst:sdk/gjs.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/libsoup.bst
- freedesktop-sdk.bst:components/gstreamer.bst
- freedesktop-sdk.bst:components/gstreamer-plugins-base.bst
- freedesktop-sdk.bst:bootstrap-import.bst

variables:
  meson-local: >-
    -Dextensions_app=false
    -Dextensions-tool:bash_completion=disabled
