# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.0 gnome-control-center.bst

kind: meson

sources:
- kind: tar
  url: gnome_downloads:gnome-control-center/51/gnome-control-center-51.0.tar.xz
  ref: c8ca5b6a0ae44fd0d64aac5aa3b79a83c2445095b159a9d13d1c9cc172ac4fb9
- kind: git_repo
  url: gnome:libgxdp.git
  directory: subprojects/libgxdp
  ref: df896e3412b749947bc6f62a91a1aac8e6b6d19b

build-depends:
- (@): gnome-build-meta.bst:include/gcc-for-recc.yml
- gnome-build-meta.bst:buildsystems/meson.bst
# These two are more like runtime deps of the tests suite
- gnome-build-meta.bst:core-deps/setxkbmap.bst
- gnome-build-meta.bst:core-deps/xvfb.bst
- gnome-build-meta.bst:sdk/gtk-doc.bst
- gnome-build-meta.bst:sdk/blueprint-compiler.bst

runtime-depends:
- gnome-build-meta.bst:core-deps/power-profiles-daemon.bst

depends:
- gnome-build-meta.bst:core-deps/NetworkManager.bst
- gnome-build-meta.bst:core-deps/accountsservice.bst
- gnome-build-meta.bst:core-deps/colord-gtk.bst
- gnome-build-meta.bst:core-deps/colord.bst
- gnome-build-meta.bst:core-deps/gnome-online-accounts.bst
- gnome-build-meta.bst:core-deps/gsound.bst
- gnome-build-meta.bst:core-deps/ibus-daemon.bst
- gnome-build-meta.bst:core-deps/libgtop.bst
- gnome-build-meta.bst:core-deps/libnma.bst
- gnome-build-meta.bst:core-deps/malcontent.bst
- gnome-build-meta.bst:core-deps/samba.bst
- gnome-build-meta.bst:core-deps/system-config-printer.bst
- gnome-build-meta.bst:core-deps/udisks2.bst
- gnome-build-meta.bst:core-deps/upower.bst
- gnome-build-meta.bst:core-deps/boltd.bst
- gnome-build-meta.bst:core/gnome-bluetooth.bst
- gnome-build-meta.bst:core/gnome-color-manager.bst
- gnome-build-meta.bst:core/gnome-desktop.bst
- gnome-build-meta.bst:core/gnome-settings-daemon.bst
- gnome-build-meta.bst:core/tecla.bst
- gnome-build-meta.bst:sdk/adwaita-icon-theme.bst
- gnome-build-meta.bst:sdk/gdk-pixbuf.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gsettings-desktop-schemas.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/libadwaita.bst
- freedesktop-sdk.bst:components/gstreamer.bst
- freedesktop-sdk.bst:components/libwacom.bst
- freedesktop-sdk.bst:components/modemmanager.bst
- freedesktop-sdk.bst:components/pwquality.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  meson-local: >-
    -Ddocumentation=true
    -Dmalcontent=true
