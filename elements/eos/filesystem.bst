kind: compose
description: |
  Apply split-rules to the `eos/deps.bst` artifact.

  The split-rules filter unwanted files from the system, such as development
  headers and debug symbols.

  This is a very common and simple element type, see the freedesktop-sdk and
  gnome-build-meta projects for many examples of similar elements, e.g.
  gnomeos/filesystem.bst in gnome-build-meta.

build-depends:
- eos/deps.bst

config:
  exclude:
  - debug
  - devel
  - doc
