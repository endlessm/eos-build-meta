kind: pyproject

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst

depends:
- freedesktop-sdk.bst:components/python3.bst

runtime-depends:
- components/python3-mccabe.bst
- components/python3-pycodestyle.bst
- components/python3-pyflakes.bst

sources:
- kind: git_repo
  url: github:PyCQA/flake8.git
  track: '*.*.*'
  ref: '7.3.0-0-gc48217e1fc006c2dddd14df54e83b67da15de5cd'
