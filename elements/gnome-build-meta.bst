kind: junction

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: 51*
  ref: 51.0-0-ga50b8c9de35f51c6a646c8178cde3c2c176725b6

config:
  overrides:
    core/meta-gnome-core-apps.bst: core/meta-gnome-core-apps.bst
    core/gnome-initial-setup.bst: core/gnome-initial-setup.bst
    core/gnome-session.bst: core/gnome-session.bst
    core/gnome-shell.bst: core/gnome-shell.bst
    core-deps/accountsservice.bst: components/accountsservice.bst
    core-deps/systemd.bst: components/systemd.bst
    core-deps/systemd-base.bst: components/systemd-base.bst
    freedesktop-sdk.bst: freedesktop-sdk.bst
    gnomeos/os-release.bst: eos/os-release.bst

    plugins/buildstream-plugins.bst: plugins/buildstream-plugins.bst
    plugins/buildstream-plugins-community.bst: plugins/buildstream-plugins-community.bst
