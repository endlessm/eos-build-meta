kind: meson
description: |
  Send system activation/daily ping messages to Endless

  Installs a periodic systemd timer to send a one-off activation message (on
  first boot-up) and a daily ping to Endless, in order to discover how many
  Endless OS systems are started and how many remain active across the world.

  Note that this does not send any identifiable user data: it only transmits the
  originally installed operating system version, the current version, the
  machine vendor & product name, and whether the OS metrics system is enabled.
  The daily ping simply contains a cumulative count of how many pings have
  been sent.

sources:
- kind: git_repo
  url: github:endlessm/eos-phone-home.git
  ref: 9aa5ab4731bf913abc21a118a14c67398b2f793b

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- freedesktop-sdk.bst:bootstrap/attr.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-requests.bst
