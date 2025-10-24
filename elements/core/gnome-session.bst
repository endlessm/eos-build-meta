# utils/update-elements.sh: Derived from gnome-build-meta.bst 49.alpha.1 core/gnome-session.bst

kind: meson
description: |
  Overriden to apply patches from patches/gnome-session and to install the
  "Endless on Wayland" session.

sources:
- kind: git_repo
  url: gnome:gnome-session.git
  track: main
  # Override: Adds one commit on top of 49.alpha.1, updating mimeapps.list to
  # drop Evince in favor of Papers and Loupe.
  ref: 49.alpha.1-1-g83410ba7d3e70b02bc8461e248ff15c9fa9a93ca
# Override: Extra sources for Endless OS.
- kind: patch
  path: patches/gnome-session/0001-doc-skip-validation-of-xml.patch
- kind: patch
  path: patches/gnome-session/hide-gnome-session.patch
- kind: local
  path: files/gnome-session/endless-wayland.desktop

build-depends:
- freedesktop-sdk.bst:components/docbook-xsl.bst
- freedesktop-sdk.bst:components/libxslt.bst
- freedesktop-sdk.bst:components/xmlto.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

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
