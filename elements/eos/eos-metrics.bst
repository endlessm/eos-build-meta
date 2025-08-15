kind: autotools
description: |
  EndlessOS Metrics Kit.

  Library for recording and sending metrics data in EndlessOS.

sources:
- kind: git_repo
  url: github:endlessm/eos-metrics.git
  track: Release_*
  ref: Release_6.0.7-0-g893939f7be0996b3244dfcdf08aadc5accac8801
- kind: local
  path: files/eos-metrics/sysusers.d/metrics.conf

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

config:
  install-commands:
    (>):
      - mkdir -p "%{install-root}"/%{prefix}/lib/sysusers.d
      - install -Dm644 ./metrics.conf "%{install-root}"/%{prefix}/lib/sysusers.d/

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
      doc:
        (>):
        - '%{datadir}/gtk-doc/html/eosmetrics*/*'
