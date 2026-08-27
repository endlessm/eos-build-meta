kind: autotools
description: |
  GRUB bootloader -- UEFI version (x86_64-efi).

  This builds an Endless-specific version of GRUB, adapted from the
  `grub-efi-amd64-image-signed` package in the EOS6 build.

  The element builds a standalone UEFI binary of GRUB and installs it to
  `/usr/lib/efi_binaries/` in the filesystem tree, and installed in the EFI
  System Partition by eos-image-builder when creating disk images.

build-depends:
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/freetype.bst
- freedesktop-sdk.bst:components/git.bst
- freedesktop-sdk.bst:components/patch.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

variables:
  autogen: >
    ./bootstrap
    --no-git
    --gnulib-srcdir=%{build-root}/gnulib

  conf-local: >
    --with-platform=efi
    --target=amd64-pe
    --libdir=%{prefix}/lib
    --libexecdir=%{prefix}/lib
    --enable-grub-mkfont

  # Override the default Freedesktop SDK CFLAGS to disable things we can't use in GRUB:
  #
  #   * No stack protector, it requires linking a library, but the bootloader is special
  #   * Avoid certain -Werror build failures (this is an old version of GRUB)
  configure: |
    CFLAGS="$CFLAGS -fno-stack-protector -Wno-error=maybe-uninitialized" %{conf-cmd} %{conf-args} %{conf-local}
  # GRUB does its own stripping.
  strip-binaries: ""

config:
  build-commands:
    (>):
      # Build standalone UEFI executable.
      #
      # This step is adapted from the EOS6 GRUB package build.
      - make unicode.pf2
      - |
        ./build-sa-efi-images \
          grub-mkstandalone \
          grub-core \
          images/x86_64-efi/ \
          x86_64-efi grubx64 \
          grub_embedded_image.cfg \
          $(pwd)/sbat.endless.csv

  install-commands:
    # Install standalone UEFI executable.
    #
    # This is used by `eos-image-builder`.
    - |
      mkdir -p %{install-root}/usr/lib/efi_binaries/EFI/endless/
      install -Dm644 images/x86_64-efi/grubx64.efi %{install-root}/usr/lib/efi_binaries/EFI/endless/grubx64.efi

(@):
- elements/eos/grub/grub-common-sources.yml

sources:
  (>):
    - kind: local
      path: files/grub/sbat.endless.csv

    - kind: local
      path: files/grub/build-sa-efi-images

    - kind: local
      path: files/grub-config/grub_embedded_image.cfg
