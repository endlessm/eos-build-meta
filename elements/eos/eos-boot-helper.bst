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

variables:
  conf-local: "--with-modprobedir=%{prefix}/lib/modprobe.d --libexecdir=%{prefix}/lib/eos-boot-helper"

sources:
- kind: git_repo
  # url: github:endlessm/eos-boot-helper
  # track: master

  # FIXME: For now we use a fork
  url: github:ssssam/eos-boot-helper
  track: sam/eos7
  ref: 53a946a8e401c1175d61bd8c1f7bc769e70e9405

public:
  bst:
    split-rules:
      devel:
        (>):
        # Dracut config is used in the `eos/initramfs.bst` element. It
        # shouldn't go into the root filesystem. EOS7 doesn't build an
        # initramfs at runtime.
        - '/etc/dracut/*'

