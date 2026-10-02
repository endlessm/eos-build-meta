# This is derived from gnome-build-meta 51.0, ensure to update it when rebasing.

kind: meson

sources:
- kind: git_repo
  url: github:endlessm/gnome-shell.git
  track: 236-rebase-gnome-shell-51.0
  ref: fae5e14f48918bc86eba63bd0acebe24f56b1b9c
- kind: git_repo
  url: gnome:libgnome-volume-control.git
  directory: subprojects/gvc
  ref: d2442f455844e5292cb4a74ffc66ecc8d7595a9f
- kind: git_repo
  url: gnome:libshew.git
  directory: subprojects/libshew
  ref: d16afc40412b565d2bbecf80335f54a19a978009

build-depends:
- (@): gnome-build-meta.bst:include/gcc-for-recc.yml
- gnome-build-meta.bst:buildsystems/meson.bst
- gnome-build-meta.bst:sdk-deps/sassc.bst
- gnome-build-meta.bst:core-deps/jasmine-gjs.bst
- gnome-build-meta.bst:core-deps/umockdev.bst
- freedesktop-sdk.bst:components/python3-docutils.bst
- freedesktop-sdk.bst:components/perl.bst

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
- gnome-build-meta.bst:sdk/glycin.bst
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/libsoup.bst
- freedesktop-sdk.bst:components/gstreamer.bst
- freedesktop-sdk.bst:components/gstreamer-plugins-base.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  meson-local: >-
    -Dextensions-tool:bash_completion=disabled
