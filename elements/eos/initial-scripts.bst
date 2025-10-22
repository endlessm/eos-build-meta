kind: collect_initial_scripts
description: |
  Collects any `initial-script` public data set by elements in `deps.bst`.

  This is written to a well-known location and used when preparing the
  filesystem, for example with `files/vm/prepare-image.sh`.

  This is a very common and simple element type, see the freedesktop-sdk and
  gnome-build-meta projects for many examples of similar elements, e.g.
  gnomeos/initial-scripts.bst in gnome-build-meta.

build-depends:
- eos/deps.bst

config:
  path: /etc/fdsdk/initial_scripts
