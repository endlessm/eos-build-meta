kind: compose
description: |   
  Compose the initramfs deps into a single element.

  The EOS PAYG feature adds a requirement that the initramfs has no
  GPL3-licensed code. 

  TBD

build-depends:
  - components/linux.bst
  - eos/initramfs/busybox.bst
  - eos/initramfs/dash.bst
#  - eos/initramfs/deps.bst

config:
  exclude: [devel, debug, doc]
    
