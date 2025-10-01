kind: autotools
description: |
  Cryptographic library.

  We use a precompiled binary of libsodium, as the upstream code
  is non-trivial to build.

build-depends:
  - freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
  - freedesktop-sdk.bst:components/util-linux.bst

sources:
- kind: tar
  url: libsodium:libsodium-1.0.20.tar.gz
  ref: ebb65ef6ca439333c2bb41a0c1990587288da07f6c7fd07cb3a18cc18d30ce19
