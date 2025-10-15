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
