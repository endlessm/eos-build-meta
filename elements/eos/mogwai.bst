# utils/update-elements.sh: Derived from gnome-build-meta.bst 48.3 core-deps/mogwai.bst

kind: meson
description:
  A scheduler for downloading

  Mogwai allows systems to take advantage of reduced cost bandwidth at off-peak
  times of day. It provides a monitoring daemon which checks bandwidth usage, a
  scheduling daemon which prioritises downloads to minimise cost, and a tariff
  library which describes different data plans.

sources:
- kind: git_repo
  url: github:endlessm/mogwai.git
  track: Release_*
  ref: Release_6.0.7-0-gc482cda428bd5f6753ae1a1fe8ae2b4d43c89647

build-depends:
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- gnome-build-meta.bst:core-deps/python-dbusmock.bst
- gnome-build-meta.bst:sdk/gtk-doc.bst
- gnome-build-meta.bst:sdk/libsoup.bst

depends:
- freedesktop-sdk.bst:components/libgsystemservice.bst
- gnome-build-meta.bst:core-deps/NetworkManager.bst
- gnome-build-meta.bst:sdk/glib.bst

public:
  bst:
    split-rules:
      devel:
        (>):
        - usr/include/mogwai-schedule-client-0
        - usr/lib/*/pkgconfig/mogwai-schedule-client-0.pc
        - usr/include/mogwai-tariff-0
        - usr/lib/*/pkgconfig/mogwai-tariff-0.pc
