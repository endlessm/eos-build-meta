kind: pyproject

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-hatchling.bst
- freedesktop-sdk.bst:components/python3-hatch-fancy-pypi-readme.bst
- freedesktop-sdk.bst:components/stripper.bst

depends:
- freedesktop-sdk.bst:components/python3.bst

sources:
- kind: git_repo
  url: github:psf/black
  track: '*.*.*'
  ref: 26.10.0-0-g4f1883b1f15305a0e83a7c87991f46292bf09f85
