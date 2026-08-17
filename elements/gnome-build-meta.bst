kind: junction

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: 51*
  ref: 51.beta-0-gff0d30522ed46fc9cacada85172623d610b857b9

config:
  overrides:
    core/meta-gnome-core-apps.bst: core/meta-gnome-core-apps.bst
    core/gnome-initial-setup.bst: core/gnome-initial-setup.bst
    core/gnome-session.bst: core/gnome-session.bst
    core/gnome-shell.bst: core/gnome-shell.bst
    core-deps/accountsservice.bst: components/accountsservice.bst
    core-deps/colord.bst: components/colord.bst
    core-deps/systemd-base.bst: components/systemd-base.bst
    freedesktop-sdk.bst: freedesktop-sdk.bst
    gnomeos/os-release-user.bst: eos/os-release-user.bst

    plugins/buildstream-plugins.bst: plugins/buildstream-plugins.bst
    plugins/buildstream-plugins-community.bst: plugins/buildstream-plugins-community.bst
