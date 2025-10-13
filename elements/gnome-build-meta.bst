kind: junction

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: 48*
  ref: 48.3-0-g4a74edcfcfc5b0bf5b55d56e2343900fc4f94aae

config:
  overrides:
    core/meta-gnome-core-apps.bst: core/meta-gnome-core-apps.bst
    core/gnome-session.bst: core/gnome-session.bst
    core-deps/accountsservice.bst: components/accountsservice.bst
    core-deps/systemd-base.bst: components/systemd-base.bst
    freedesktop-sdk.bst: freedesktop-sdk.bst
    gnomeos/os-release-user.bst: eos/os-release-user.bst
