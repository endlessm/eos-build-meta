kind: manual
description: |
  Configuration files for GRUB.

  These are used by `grub-install` at bootloader install time.

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

variables:
  strip-binaries: ''

config:
  install-commands:
  - mkdir -p '%{install-root}/usr/lib/grub/conf/'
  - install -Dm644 grub.cfg '%{install-root}/usr/lib/grub/conf/'
  - install -Dm644 grub_embedded_bios.cfg '%{install-root}/usr/lib/grub/conf/'
  - install -Dm644 grub_embedded_image.cfg '%{install-root}/usr/lib/grub/conf/'

sources:
- kind: local
  path: files/grub-config/grub.cfg
- kind: local
  path: files/grub-config/grub_embedded_bios.cfg
- kind: local
  path: files/grub-config/grub_embedded_image.cfg
