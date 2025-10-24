kind: stack
description: |
  All dependencies of PAYG features, if enabled.

depends: []

(?):
  - payg == true:
      depends:
        (>):
          - eos/payg/eos-payg.bst
          - eos/payg/eos-payg-nonfree.bst
          - eos/payg/uki-signed.bst

      (?):
        - signed_boot == 'endless':
            depends:
              (>):
                - signing/payg/signed-systemd-boot-endless.bst
        - signed_boot == 'snakeoil':
            depends:
              (>):
                - signing/payg/signed-systemd-boot-snakeoil.bst
