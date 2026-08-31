kind: manual
description: |
  System-wide config for systemd-sysusers.

  In general, system users and groups should be defined with the corresponding system service,
  and should use dynamically allocated IDs.

  This element exists for EOS7 to reserve some UIDs and GIDs that already exist in EOS6 for
  future use.

  See `doc/sysusers.md` for more information.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst

config:
  install-commands:
  - mkdir -p '%{install-root}/%{prefix}/lib/sysusers.d/'
  - install -Dm644 colord.conf '%{install-root}/%{prefix}/lib/sysusers.d/'
  - install -Dm644 placeholders.conf '%{install-root}/%{prefix}/lib/sysusers.d/'
  - install -Dm644 obsolete.conf '%{install-root}/%{prefix}/lib/sysusers.d/'

sources:
- kind: local
  path: files/systemd-sysusers-config/colord.conf
- kind: local
  path: files/systemd-sysusers-config/placeholders.conf
- kind: local
  path: files/systemd-sysusers-config/obsolete.conf
