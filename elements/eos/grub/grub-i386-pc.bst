kind: autotools
description: |
  GRUB bootloader -- legacy BIOS version (i386-pc).

  This builds an Endless-specific version of GRUB, adapted from the
  `grub2-common` and `grub-pc` packages in the EOS6 build.

  This element performs a standard install of GRUB into `/usr` which
  is deployed in all EOS7 systems.

  The `grub-install` program is also used by eos-image-builder when creating
  the disk images.

  Note that all new EOS7 installs use UEFI, but existing systems with BIOS boot
  are still supported.

build-depends:
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patch.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

variables:
  autogen: >
    ./bootstrap
    --no-git
    --gnulib-srcdir=%{build-root}/gnulib

  conf-local: >
    --with-platform=pc
    --libdir=%{prefix}/lib
    --libexecdir=%{prefix}/lib

  # Enable selected extras from grub-extras.git.
  grub-extras: "915resolution ntldr-img"

  # Override the default Freedesktop SDK CFLAGS to disable things we can't use in GRUB:
  #
  #   * No control-flow protection as it doesn't work on i686
  #   * No stack protector, it requires linking a library, but the bootloader is special
  #   * Avoid certain -Werror build failures (this is an old version of GRUB)
  configure: |
    CFLAGS="$CFLAGS -fcf-protection=none -fno-stack-protector -Wno-error=maybe-uninitialized" %{conf-cmd} %{conf-args} %{conf-local}

  # GRUB does its own stripping.
  strip-binaries: ""

environment:
  GRUB_CONTRIB: ./grub-extras-enabled

config:
  configure-commands:
    (<):
      - |
        mkdir ./grub-extras-enabled
        for extra in %{grub-extras}; do
          echo "Enabling grub-extra: $extra"
          cp -a ./grub-extras/$extra ./grub-extras-enabled
        done

(@):
- elements/eos/grub/grub-common-sources.yml
