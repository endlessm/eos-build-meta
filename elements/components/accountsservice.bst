# utils/update-elements.sh: Derived from gnome-build-meta.bst 48.3 core-deps/accountsservice.bst

kind: meson
description: |
  UNIX account management tool, from the pre-systemd days.

  Overridden so we can name the admin group "sudo" for backwards compatibility
  with Endless OS 6.

sources:
- kind: tar
  base-dir: ''
  url: freedesktop_software:accountsservice/accountsservice-23.13.9.tar.xz
  ref: adda4cdeae24fa0992e7df3ffff9effa7090be3ac233a3edfdf69d5a9c9b924f
build-depends:
- gnome-build-meta.bst:sdk/gobject-introspection.bst
- gnome-build-meta.bst:sdk/vala.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- gnome-build-meta.bst:sdk/glib.bst
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:components/polkit.bst
- freedesktop-sdk.bst:bootstrap-import.bst

variables:
  meson: meson %{build-dir} */ %{meson-args}
  # Overridde: name the admin group "sudo".
  meson-local: >-
    -Dadmin_group=sudo
  local_flags: >-
    -Wno-error=implicit-function-declaration
