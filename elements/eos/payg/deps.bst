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
          
  - payg == true and signed_boot == "snakeoil":
      depends:
        (>):
          - signing/payg/signed-uki-snakeoil.bst
