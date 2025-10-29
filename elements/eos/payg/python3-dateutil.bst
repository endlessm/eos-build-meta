kind: pyproject
description: |
  Useful extensions to the standard Python datetime features

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst
- freedesktop-sdk.bst:components/python3-setuptools-scm.bst

depends:
- freedesktop-sdk.bst:components/python3.bst

runtime-depends:
- freedesktop-sdk.bst:components/python3-six.bst

sources:
- kind: git_repo
  url: github:dateutil/dateutil
  track: '*.*.*'
  ref: 2.9.0-0-gdb9d018944c41ddc740015cf5f64717c2ba64a5c
