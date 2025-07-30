kind: make

sources:
- kind: git_repo
  url: github:micheleg/dash-to-dock.git
  track: extensions.gnome.org-v*
  ref: extensions.gnome.org-v101-0-g55489eed868dd42474e383b3fc2f47375de44896

depends:
- gnome-build-meta.bst:core/gnome-shell.bst
