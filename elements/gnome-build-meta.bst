kind: junction

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: 48*
  ref: 48.5-0-gd834ceadb81f4d040f1f40da141631888c35aa3d

config:
  overrides:
    core/meta-gnome-core-apps.bst: core/meta-gnome-core-apps.bst
    core/gnome-session.bst: core/gnome-session.bst
    core/gnome-shell.bst: core/gnome-shell.bst
    core-deps/accountsservice.bst: components/accountsservice.bst
    core-deps/colord.bst: components/colord.bst
    core-deps/systemd-base.bst: components/systemd-base.bst
    freedesktop-sdk.bst: freedesktop-sdk.bst
    gnomeos/os-release-user.bst: eos/os-release-user.bst

    plugins/buildstream-plugins.bst: plugins/buildstream-plugins.bst
    plugins/buildstream-plugins-community.bst: plugins/buildstream-plugins-community.bst
