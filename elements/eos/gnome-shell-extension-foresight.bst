kind: make

sources:
- kind: git_repo
  url: github:pesader/gnome-shell-extension-foresight.git
  track: main
  ref: 9351f7bba16b47ede45d2bfa42f620f23ff70874

depends:
- gnome-build-meta.bst:core/gnome-shell.bst
