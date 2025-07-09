kind: pyproject

sources:
- kind: git_repo
  url: github:dbnicholson/ostree-push.git
  track: 'v*.*.*'
  ref: v1.2.0-0-g2dc8d910010e2ebee4944f5e76eef6b865c2ad96

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst

depends:
- freedesktop-sdk.bst:components/openssh.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:components/pygobject.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-pyyaml.bst
