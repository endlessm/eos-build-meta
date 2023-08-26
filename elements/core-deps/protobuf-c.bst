kind: autotools

sources:
- kind: git_tag
  url: github:protobuf-c/protobuf-c.git
  track: v*
  ref: v1.4.1-0-gabc67a11c6db271bedbb9f58be85d6f4e2ea8389
# Fix build with protobuf 23
- kind: patch
  path: files/protobuf-c/protobuf-23.patch

build-depends:
  - freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
  - freedesktop-sdk.bst:components/protobuf.bst

# variables:
# https://github.com/protocolbuffers/protobuf/issues/9916
# local_flags: -std=c++17
