# utils/update-elements.sh: Derived from gnome-build-meta.bst 48.3 core-deps/libpeas-1.bst

kind: meson
sources:
- kind: git_repo
  url: gnome:libpeas.git
  track: 1.36

  ref: libpeas-1.36.0-1-gc68ecac0025caa5fa2401deff41d3b1959062600
build-depends:
- gnome-build-meta.bst:sdk/gi-docgen.bst
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/vala.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- gnome-build-meta.bst:sdk/gjs.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/pygobject.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  meson-local: >-
    -Dpython3=true
    -Dlua51=false
    -Dintrospection=true
    -Dvapi=true
    -Dgtk_doc=true
