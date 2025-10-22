kind: collect_manifest
description: |
  This is a very common and simple element type, see the freedesktop-sdk and
  gnome-build-meta projects for many examples of similar elements, e.g.
  gnomeos/manifest.bst in gnome-build-meta.

build-depends:
- eos/deps.bst

config:
  path: /usr/manifest.json
