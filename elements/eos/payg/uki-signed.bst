kind: script
description: |
  Install the UKI where Endless's OSTree fork will find it.

  The UKI is written inside `/usr/lib/modules/` alongside the regular initramfs.
  The signed binary is deployed to the ESP by a codepath in the custom Endless
  version of OSTree, when `OSTREE_DEPLOY_PAYG` is set in the environment.

build-depends:
  - freedesktop-sdk.bst:bootstrap-import.bst
  - components/linux.bst

(?):
  - signed_boot == 'endless':
      build-depends:
        (>):
          - signing/payg/signed-uki-endless.bst
  - signed_boot == 'snakeoil':
      build-depends:
        (>):
          - signing/payg/signed-uki-snakeoil.bst

config:
  commands:
    - |
      version="$(ls -1 /lib/modules | head -n1)"
      mkdir -p %{install-root}/usr/lib/modules/${version}
      cp /usr/share/efi_binaries_payg/payg-image-signed.efi %{install-root}/usr/lib/modules/${version}/

