kind: autotools
description: "DASH shell.\nUsed in the EOS7 initramfs."

sources:
- kind: tar
  url: herbert_xu:dash/files/dash-0.5.12.tar.gz

  ref: 6a474ac46e8b0b32916c4c60df694c82058d3297d8b385b74508030ca4a8f28a
build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
