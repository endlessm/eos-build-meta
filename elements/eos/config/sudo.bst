kind: manual
description: |
  Configuration for `sudo`.

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- freedesktop-sdk.bst:components/sudo.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    install -Dm644 -t "%{install-root}%{sysconfdir}/sudoers.d" sudo

sources:
- kind: local
  path: files/sudo-config
