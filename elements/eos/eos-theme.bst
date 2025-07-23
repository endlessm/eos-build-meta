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
  ref: 521a13fc801a911c0dd3e9802055eefe2e626cfe

build-depends:
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- gnome-build-meta.bst:core-deps/dconf.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/librsvg.bst
