# This is derived from gnome-build-meta 48.3, ensure to update it when rebasing.

kind: meson

sources:
- kind: git_repo
  url: github:endlessm/gnome-shell.git
  track: 12-gnome-shell-48.4
  ref: efb5b00df43795246915880dd271b67dfd99fa66
- kind: git_module
  url: gnome:gi-docgen.git
  path: subprojects/gi-docgen
  ref: 58433f82d1187f11c25311c6c68c44739d9b3b00
- kind: git_module
  url: gnome:libgnome-volume-control.git
  path: subprojects/gvc
  ref: 5f9768a2eac29c1ed56f1fbb449a77a3523683b6

build-depends:
- gnome-build-meta.bst:sdk-deps/sassc.bst
- gnome-build-meta.bst:core-deps/jasmine-gjs.bst
- freedesktop-sdk.bst:components/python3-docutils.bst
- freedesktop-sdk.bst:components/perl.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- eos/eos-metrics.bst

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
