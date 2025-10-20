kind: stack
description: |
  All dependencies of PAYG features, if enabled.

depends:
- eos/payg/eos-payg.bst
- eos/payg/eos-payg-nonfree.bst

(?):
  - payg == true:
      depends:
        (>):
          - eos/payg/uki-signed.bst
