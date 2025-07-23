kind: autotools

sources:
- kind: git_repo
  url: github:endlessm/eos-theme.git
  track: Release_*
  ref: Release_6.0.7-0-gab01c0fffbf0b5a1405bc78c83345b5c921ada1c

build-depends:
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- gnome-build-meta.bst:core-deps/dconf.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/librsvg.bst
