kind: meson
description:
  System component of the OSTree based updater

  Contains the automatic update tool eos-autoupdater and the eos-updater daemon.
  eos-autoupdater is run by a systemd timer, and once running, communicates with
  eos-updater to initiate as much of the update process as is set to be
  automatic. Once that part of the process is complete, it exits.

sources:
- kind: git_repo
  url: github:endlessm/eos-updater.git
  track: Release_*
  ref: Release_6.0.11-0-gdf81cf7f9688e03553736b06060f1bd71e54c97d

build-depends:
- freedesktop-sdk.bst:components/avahi.bst
- freedesktop-sdk.bst:components/gnupg.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-flake8.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- gnome-build-meta.bst:sdk/gtk-doc.bst
- gnome-build-meta.bst:sdk/json-glib.bst
- gnome-build-meta.bst:sdk/libsoup.bst
- eos/eos-metrics.bst

depends:
- freedesktop-sdk.bst:components/flatpak.bst
- freedesktop-sdk.bst:components/libgsystemservice.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:components/systemd.bst
- gnome-build-meta.bst:core-deps/NetworkManager.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/pygobject.bst
- eos/mogwai.bst

public:
  bst:
    split-rules:
      devel:
        - usr/lib/*/libeos-updater-util-0.so
        - usr/lib/*/libeos-updater-flatpak-installer-0.so
        - usr/share/gir-1.0/EosUpdaterUtil-0.gir
        - usr/share/gir-1.0/EosUpdaterFlatpakInstaller-0.gir
        - usr/share/python-dbusmock/templates/eos_updater.py
      test:
        - usr/libexec/installed-tests/eos-updater-0
        - usr/libexec/installed-tests/libeos-updater-flatpak-installer-0
        - usr/libexec/installed-tests/libeos-updater-util-0
        - usr/share/installed-tests/eos-updater-0
        - usr/share/installed-tests/libeos-updater-flatpak-installer-0
        - usr/share/installed-tests/libeos-updater-util-0
