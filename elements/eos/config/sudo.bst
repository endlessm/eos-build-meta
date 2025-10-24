# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-25.08.1 vm/config/sudo.bst

kind: manual
description: |
  Configuration for `sudo`.

  Overridden to rename the 'wheel' groupe to 'sudo', for backwards compatibility
  with Endless OS 6.

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- freedesktop-sdk.bst:components/sudo.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - |
    # Override: Rename 'wheel' group to 'sudo'
    install -Dm644 -t "%{install-root}%{sysconfdir}/sudoers.d" sudo

sources:
# Borrow: Similar to files/vm/sudo-config in freedesktop-sdk where wheel is
# replaced by sudo, and wheel-nopasswd is dropped.
- kind: local
  path: files/sudo-config
