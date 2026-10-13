# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.0 core-deps/dnsmasq.bst

kind: make
description: |
  Lightweight DNS forwarder and DHCP server.

  Overrides core-deps/dnsmasq.bst from gnome-build-meta, which installs the man
  page into /usr/local/share/man. That makes /usr/local a real directory, and it
  conflicts with the /usr/local -> /var/local symlink from eos/config/ostree.bst.

sources:
- kind: git_repo
  url: thekelleys:dnsmasq.git
  track: 'v*.*'
  exclude:
  - '*test*'
  - '*rc*'
  ref: v2.93-0-g3ff66da573a77c8783deca10ec8c6bba07cd85e6

build-depends:
- (@): gnome-build-meta.bst:include/gcc-for-recc.yml
- gnome-build-meta.bst:buildsystems/make.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  make-args: >-
    BINDIR=%{sbindir}
    MANDIR=%{mandir}
