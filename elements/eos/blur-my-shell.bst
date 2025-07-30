kind: make

sources:
- kind: git_repo
  url: github:aunetx/blur-my-shell.git
  track: v*
  ref: v68-2-0-25b200249400f45578947cc5ce8000e4abad3a4c

depends:
- gnome-build-meta.bst:core/gnome-shell.bst
