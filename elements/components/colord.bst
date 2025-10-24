# utils/update-elements.sh: Derived from gnome-build-meta.bst 48.5 core-deps/colord.bst
#
# We bring forward colord-1.4.8 from GNOME 49, because the colord-1.4.7 release doesn't
# work due to bad systemd unit config.
#
# colord 1.4.7 fails on startup in eos7 as it cannot write /var/lib/colord/mapping.db.
# The fix is in:
# <https://github.com/hughsie/colord/commit/08a32b2379fb5582f4312e59bf51a2823df56276>.
kind: meson
sources:
- kind: tar
  url: freedesktop_software:colord/releases/colord-1.4.8.tar.xz
  ref: 21500bd68975312a7f0f3ce6019d9f75f42aacaa75ca7115ec720b5445406896
build-depends:
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/gtk-doc.bst
- gnome-build-meta.bst:sdk/vala.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
depends:
- gnome-build-meta.bst:sdk/glib.bst
- freedesktop-sdk.bst:components/lcms.bst
- freedesktop-sdk.bst:components/libgudev.bst
- freedesktop-sdk.bst:components/libgusb.bst
- freedesktop-sdk.bst:components/polkit.bst
- freedesktop-sdk.bst:bootstrap-import.bst
variables:
  meson-local: >-
    -Dargyllcms_sensor=false
    -Dbash_completion=false
    -Dlibcolordcompat=false
    -Dman=false
    -Dvapi=true
    -Ddocs=false
