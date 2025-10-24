# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-24.08.22 components/bash-config.bst

kind: manual
description: |
  Default user configuration for Bash shell.

  Overridden to avoid installing files in `/root`, which is not the correct
  place on an OSTree system.

  See also, an upstream issue in FDSDK discussing other ways to configure Bash:
  <https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/issues/1875>.

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - install -Dm644 bashrc '%{install-root}%{sysconfdir}/bashrc'
  - install -Dm644 profile '%{install-root}%{sysconfdir}/profile'
  - install -Dm644 dot-profile '%{install-root}%{sysconfdir}/skel/.profile'
  - install -Dm644 dot-bashrc '%{install-root}%{sysconfdir}/skel/.bashrc'

sources:
- kind: local
  path: files/bash-config/profile
- kind: local
  path: files/bash-config/bashrc
- kind: local
  path: files/bash-config/dot-profile
- kind: local
  path: files/bash-config/dot-bashrc
