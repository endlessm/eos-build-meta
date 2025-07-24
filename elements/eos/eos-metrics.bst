kind: autotools

sources:
- kind: git_repo
  url: github:endlessm/eos-metrics.git
  track: Release_*
  ref: Release_6.0.7-0-g893939f7be0996b3244dfcdf08aadc5accac8801

build-depends:
- freedesktop-sdk.bst:components/python3-dbus.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- gnome-build-meta.bst:core-deps/python-dbusmock.bst
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/gtk-doc.bst
- gnome-build-meta.bst:sdk/yelp-tools.bst
- gnome-build-meta.bst:sdk/yelp-xsl.bst

depends:
- gnome-build-meta.bst:sdk/glib.bst

variables:
  conf-local: >-
   --enable-strict-flags
   --enable-gtk-doc
   --enable-gir-doc

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{includedir}/eosmetrics*/*'
        - '%{libdir}/libeosmetrics*.so'
        - '%{libdir}/pkgconfig/eosmetrics*.pc'
        - '%{datadir}/eos-metrics/com.endlessm.Metrics.xml'
        - '%{datadir}/gir-1.0/EosMetrics*.gir'
