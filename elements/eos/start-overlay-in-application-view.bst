kind: make

sources:
- kind: git_repo
  url: github:Hexcz/Start-Overlay-in-Application-View-for-Gnome-40-.git
  track: main
  ref: 544e1630556ab29f537c05bff765909b31f4b2eb

depends:
- gnome-build-meta.bst:core/gnome-shell.bst
