kind: manual
description: |
  Configuration files for GRUB.

  These are used by eos-image-builder when creating disk images and ISOs
  with the GRUB UEFI application.

  EOS7 supports only UEFI boot. Legacy BIOS boot is not supported.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - mkdir -p '%{install-root}/usr/lib/grub/conf/'
  - install -Dm644 grub.cfg '%{install-root}/usr/lib/grub/conf/'
  - install -Dm644 grub_embedded_image.cfg '%{install-root}/usr/lib/grub/conf/'

sources:
- kind: local
  path: files/grub-config/grub.cfg
- kind: local
  path: files/grub-config/grub_embedded_image.cfg
