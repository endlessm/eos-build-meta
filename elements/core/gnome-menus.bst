kind: autotools
sources:
- kind: tar
  url: gnome_downloads:gnome-menus/3.36/gnome-menus-3.36.0.tar.xz
  ref: d9348f38bde956fc32753b28c1cde19c175bfdbf1f4d5b06003b3aa09153bb1f
build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
depends:
- sdk/glib.bst
- sdk/gobject-introspection.bst
- freedesktop-sdk.bst:bootstrap-import.bst
