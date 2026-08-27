kind: pyproject

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst

depends:
- freedesktop-sdk.bst:components/python3.bst

sources:
- kind: git_repo
  url: github:PyCQA/pycodestyle.git
  track: '*.*.*'
  ref: '2.14.0-0-g814a0d1259444a21ed318e64edaf6a530c2aeeb8'
