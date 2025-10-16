# utils/update-elements.sh: Derived from gnome-build-meta.bst 48.3 gnomeos/linux-module-cert.bst

kind: manual
description: |
  Linux kernel module certificates.

  This is embedded into the kernel and the kernel will check modules for the
  given signature. Depending on the kernel config and its commandline, it can
  refuse to load modules that aren't signed with the corresponding key(s).

build-depends:
  - freedesktop-sdk.bst:bootstrap-import.bst

config:
  install-commands:
    - |
      mkdir %{install-root}/keys/
    - |
      cp MODULES-snakeoil.crt %{install-root}/keys/linux-module-cert.crt

sources:
- kind: local
  path: files/boot-keys/MODULES-snakeoil.crt
