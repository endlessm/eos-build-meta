# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.beta core-deps/accountsservice.bst

kind: meson
description: |
  UNIX account management tool, from the pre-systemd days.

  Overridden so we can name the admin group "sudo" for backwards compatibility
  with Endless OS 6. https://phabricator.endlessm.com/T35801

sources:
- kind: git_repo
  url: freedesktop:accountsservice/accountsservice.git
  track: refs/tags/*
  ref: 26.27.3-0-g4e254d9624cc48224c9920b9509df0b144f7be0c

build-depends:
- (@): gnome-build-meta.bst:include/gcc-for-recc.yml
- gnome-build-meta.bst:buildsystems/meson.bst
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/vala.bst
- freedesktop-sdk.bst:components/sed.bst
- freedesktop-sdk.bst:components/systemd.bst

depends:
- gnome-build-meta.bst:sdk/glib.bst
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:components/polkit.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  # Overridde: name the admin group "sudo".
  meson-local: >-
    -Dadmin_group=sudo
