# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 vm/config/ostree.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: manual
description: |
  Root filesystem setup and OSTree configuration.

  Borrowed from freedesktop-sdk, where FreeDesktop-related files and
  configuration are replaced with Endless OS-specific ones.

build-depends:
- freedesktop-sdk.bst:public-stacks/runtime-gnu.bst
- freedesktop-sdk.bst:components/m4.bst

runtime-depends:
- components/ostree.bst
- freedesktop-sdk.bst:components/systemd.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - mkdir %{install-root}/boot
  - mkdir %{install-root}/efi
  - mkdir %{install-root}/etc
  - mkdir %{install-root}/mnt
  - mkdir %{install-root}/run
  - mkdir %{install-root}/opt
  - mkdir %{install-root}/sys
  - mkdir %{install-root}/tmp
  - mkdir %{install-root}/dev
  - mkdir %{install-root}/proc

  - mkdir -p "%{install-root}/sysroot"
  - ln -s sysroot/ostree "%{install-root}/ostree"
  # Though we use /var/home in /etc/passwd and this symlink should
  # be useless removing this symlink breaks --filesystem=host on
  # flatpak.
  - ln -s var/home "%{install-root}/home"
  - ln -s var/roothome "%{install-root}/root"
  - ln -s run/media "%{install-root}/media"

  - mkdir "%{install-root}/usr"
  - ln -sf /var/local "%{install-root}/usr/local"

  # Special undocumented support for encrypted file systems using fscrypt.
  # In Endless OS, the root partition is mounted at `/sysroot/`. The files in
  # `/` are put there by OSTree when it checks out a tree. This symlink helps
  # fscrypt to find its state directory.
  - ln -s sysroot/.fscrypt "%{install-root}/.fscrypt"

  - install -Dm644 -t "%{install-root}/usr/lib/tmpfiles.d" ostree.conf

sources:
# Borrow: Similar to files/vm/ostree-config in freedesktop-sdk where ostree.conf
# is borrowed unchanged, and eos.conf replaces freedesktop-sdk.conf.in.
- kind: local
  path: files/ostree-config
