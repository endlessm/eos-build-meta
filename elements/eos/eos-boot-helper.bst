kind: autotools
description: |
  Endless OS boot helpers.

  This provides a grab-bag of stuff including:

    * Initramfs configuration
    * Migration scripts for old versions of EOS

build-depends:
- freedesktop-sdk.bst:components/dbus.bst
- freedesktop-sdk.bst:components/efivar.bst
- freedesktop-sdk.bst:components/polkit.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

depends:
# For `record-boot-success` program.
- components/python3-systemd.bst

variables:
  conf-local: "--with-modprobedir=%{prefix}/lib/modprobe.d --libexecdir=%{prefix}/lib/eos-boot-helper"

sources:
- kind: git_repo
  url: github:endlessm/eos-boot-helper
  track: master
  ref: Release_6.0.5-25-g005b2198c55c0dfe362cf283c5c4202a305d1bf2

public:
  bst:
    split-rules:
      devel:
        (>):
        # Dracut config is used in the `eos/initramfs.bst` element. It
        # shouldn't go into the root filesystem. EOS7 doesn't build an
        # initramfs at runtime.
        - '/etc/dracut/*'

