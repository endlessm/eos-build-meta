kind: autotools
description: |
  Provides Endless OS theme.

  * eos-default-settings: Default settings for Endless OS, including GSettings
    overrides and X11 environment defaults, among others.
  * eos-extra-faces: Extra avatar used by Endless OS.
  * eos-extra-fonts: Extra fonts used by Endless applications.
  * eos-icon-theme: Default icon theme used by Endless OS.
  * eos-logos: Endless OS logos.

sources:
- kind: git_repo
  url: github:endlessm/eos-theme.git
  track: 174-use-update-ca-trust
  ref: 43acff2553cb0c03f1dc5b0d522e9790aa13bc70

build-depends:
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- gnome-build-meta.bst:core-deps/dconf.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/librsvg.bst
