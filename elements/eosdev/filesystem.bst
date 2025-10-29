kind: compose
description: |
  Apply split-rules to the `eos/deps.bst` artifact.

  This tree includes everything in `eos/filesystem`, plus
  development headers and documentation, but no debug symbols.

build-depends:
- eos/deps.bst

config:
  exclude:
  - debug
