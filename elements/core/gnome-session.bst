# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.beta core/gnome-session.bst

kind: meson
description: |
  Overriden to apply patches from patches/gnome-session and to install the
  "Endless on Wayland" session.

sources:
- kind: tar
  url: gnome_downloads:gnome-session/51/gnome-session-51.beta.tar.xz
  ref: 2e3e3b6da20c9746741750df9bd71abad02b2a8c8602e4d97c5cc7f8359c8d04
# Override: Extra sources for Endless OS.
- kind: patch
  path: patches/gnome-session/hide-gnome-session.patch
- kind: local
  path: files/gnome-session/endless-wayland.desktop

build-depends:
- (@): gnome-build-meta.bst:include/gcc-for-recc.yml
- gnome-build-meta.bst:buildsystems/meson.bst
- freedesktop-sdk.bst:components/docbook-xsl.bst
- freedesktop-sdk.bst:components/libxslt.bst
- freedesktop-sdk.bst:components/xmlto.bst

depends:
- gnome-build-meta.bst:core-deps/upower.bst
- gnome-build-meta.bst:core/gnome-desktop.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/json-glib.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  meson-local: >-
    -Dmimeapps=false

# Override: Install the "Endless on Wayland" session.
config:
  install-commands:
    (>):
    - install -Dm644 endless-wayland.desktop %{install-root}/usr/share/wayland-sessions/
