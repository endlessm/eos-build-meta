kind: pyproject
description: |
  Python wrappers for systemd functionality.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst
- freedesktop-sdk.bst:components/pkg-config.bst

depends:
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/systemd.bst

sources:
- kind: git_repo
  url: github:systemd/python-systemd
  track: v*
  ref: v235-0-gdc1dae2eaa00e2369c366f80f9bcd3f729b7abca
