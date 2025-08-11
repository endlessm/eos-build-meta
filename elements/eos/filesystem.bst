kind: compose
description: |
  Apply split-rules to the `eos/deps.bst` artifact.

  The split-rules filter unwanted files from the system, such as development
  headers and debug symbols.

build-depends:
- eos/deps.bst

config:
  exclude:
  - debug
  - devel
  - doc
