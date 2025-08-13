kind: manual
description: |
  systemd-sysusers-override tool.

  Available for use in filesystem preparation hooks to patch
  systemd-sysusers config files.

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

runtime-depends:
- freedesktop-sdk.bst:components/python3.bst

config:
  install-commands:
  - |
    install -Dm 755 -t "%{install-root}%{bindir}" systemd_sysusers_override.py

sources:
- kind: local
  path: files/systemd-sysusers-override/systemd_sysusers_override.py
