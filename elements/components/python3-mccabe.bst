kind: pyproject

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst

depends:
- freedesktop-sdk.bst:components/python3.bst

sources:
- kind: git_repo
  url: github:PyCQA/mccabe.git
  track: '*.*.*'
  ref: '0.7.0-0-g835a5400881b7460998be51d871fd36f836db3c9'
