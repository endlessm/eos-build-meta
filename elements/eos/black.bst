kind: pyproject

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-hatchling.bst
- freedesktop-sdk.bst:components/python3-hatch-fancy-pypi-readme.bst

runtime-depends:
- freedesktop-sdk.bst:components/python3.bst

sources:
- kind: git_repo
  url: github:psf/black
  track: '*.*.*'
  ref: 25.9.0-0-gaf0ba72a73598c76189d6dd1b21d8532255d5942
