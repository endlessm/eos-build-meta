# This file was adapted from gnome-build-meta `gnomeos/initramfs/signed-modules.bst`

kind: manual
description: |
  Sign kernel modules with the snakeoil signing key.

build-depends:
- filename: freedesktop-sdk.bst:components/linux.bst
  strict: true
- freedesktop-sdk.bst:components/sign-file.bst
- freedesktop-sdk.bst:components/zstd.bst

config:
  install-commands:
  - |
    mkdir -p "%{install-root}/usr/lib"
    cp -rT /usr/lib/modules "%{install-root}/usr/lib/modules"

  - |
    version="$(ls -1 /usr/lib/modules | head -n1)"
    cp /boot/vmlinuz "%{install-root}/usr/lib/modules/${version}"

  - |
    openssl x509 -inform PEM -outform DER -in "MODULES-snakeoil.crt" -out "linux-module-cert.cer"


  - |
    find '%{install-root}/usr/lib/modules' -type f -name "*.ko.xz" -exec unxz {} ';'

  - |
    find '%{install-root}/usr/lib/modules' -type f -name "*.ko" -exec sign-file sha512 MODULES-snakeoil.key linux-module-cert.cer {} ';' -exec xz --lzma2=dict=2MiB {} ';'

variables:
  strip-binaries: ''

sources:
- kind: local
  path: files/boot-keys/MODULES-snakeoil.key
- kind: local
  path: files/boot-keys/MODULES-snakeoil.crt
