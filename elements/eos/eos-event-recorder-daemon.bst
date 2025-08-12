kind: meson
description: |
  Endless OS Event Recorder Daemon

  Daemon for aggregating and recording metrics data in Endless OS.

sources:
- kind: git_repo
  url: github:endlessm/eos-event-recorder-daemon.git
  track: Release_*
  ref: Release_6.0.7-0-g5101c7d1acef9b013ad8566bd2d708db3ce57d2a

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- gnome-build-meta.bst:core-deps/python-dbusmock.bst

depends:
- eos/eos-metrics.bst
- freedesktop-sdk.bst:components/ca-certificates.bst
- freedesktop-sdk.bst:components/libsoup.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:components/polkit-gobject.bst
- freedesktop-sdk.bst:components/python3-dbus.bst
- freedesktop-sdk.bst:components/systemd.bst
- gnome-build-meta.bst:sdk/glib.bst

variables:
  meson-local: >-
    -Ddefault_metrics_server_url='https://${environment}.metrics.endlessm.com'
