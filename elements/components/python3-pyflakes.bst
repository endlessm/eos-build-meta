kind: pyproject

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst

depends:
- freedesktop-sdk.bst:components/python3.bst

sources:
- kind: git_repo
  url: github:PyCQA/pyflakes.git
  track: '*.*.*'
  ref: '3.4.0-0-g59ec4593efd4c69ce00fdb13c40fcf5f3212ab10'
