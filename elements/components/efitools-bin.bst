# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: make

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
- freedesktop-sdk.bst:components/_private/gnu-efi.bst
- freedesktop-sdk.bst:components/help2man.bst
- components/perl-slurp.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- freedesktop-sdk.bst:components/openssl.bst
- freedesktop-sdk.bst:components/_private/sbsigntools.bst

variables:
  fdsdk-keys-uuid: 3eaca6a1-86fa-4580-9487-cccae358e9e4
  notparallel: true
  make-args: >-
    PREFIX='%{prefix}'
    CRTPATHS='%{libdir}'
    EXTRAKEYS=''
    EXTERNALKEYS=''
    KEYUPDATEAUTH=''
    KEYBLACKLISTAUTH=''
    KEYHASHBLACKLISTAUTH=''
    MYGUID=%{fdsdk-keys-uuid}

config:
  install-commands:
    (>):
    - rm -rvf "%{install-root}%{datadir}/efitools/efi/"

sources:
- kind: git_repo
  url: kernel:linux/kernel/git/jejb/efitools.git
  track: master
  ref: v1.9.2-4-gb988d20a7f8373cf19c30d5c9c459f3e87f28da2
- kind: patch
  path: patches/efitools/c99.patch
- kind: patch
  path: patches/efitools/gnu-efi.patch
- kind: patch
  path: patches/efitools/gcc15.patch
- kind: patch
  path: patches/efitools/binutils_2_46.patch
