# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: make

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- freedesktop-sdk.bst:components/perl.bst

config:
  configure-commands:
  - perl Makefile.PL PREFIX="%{prefix}" DESTDIR="%{install-root}"
  install-commands:
  - make -j1 install
  - "%{install-extra}"

sources:
- kind: tar
  url: cpan:authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz
  ref: 4c3c21992a9d42be3a79dd74a3c83d27d38057269d65509a2f555ea0fb2bc5b0
