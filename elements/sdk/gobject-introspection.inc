sources:
- kind: tar
  url: gnome_downloads:gobject-introspection/1.81/gobject-introspection-1.81.2.tar.xz
  ref: ec973bf5c2c2e69d14642df38e508c24ae91a254b6c38d2828022c71f2a144e0
build-depends:
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- sdk/gtk-doc.bst

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{datadir}/gobject-introspection-1.0'
        - '%{datadir}/gobject-introspection-1.0/**'
        - '%{libdir}/libgirepository-1.0.so'
