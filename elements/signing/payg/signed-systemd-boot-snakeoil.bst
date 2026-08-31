kind: manual
description: |
  Sign systemd-boot binary with the insecure "snakeoil" key.

build-depends:
- components/systemd.bst
- freedesktop-sdk.bst:components/_private/sbsigntools.bst

config:
  install-commands:
  - |
    mkdir -p "%{install-root}/usr/lib/systemd/boot/efi/"
  - |
    sbsign \
        --key VENDOR-snakeoil.key \
        --cert VENDOR-snakeoil.crt \
        --output "%{install-root}/usr/lib/systemd/boot/efi/systemd-bootx64.efi" \
        "/usr/lib/systemd/boot/efi/systemd-bootx64.efi"

sources:
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.key
- kind: local
  path: files/boot-keys/VENDOR-snakeoil.crt

# Allow this element to overwrite the binary from systemd-boot in filesystem.bst.
public:
  bst:
    overlap-whitelist:
    - |
      /usr/lib/systemd/boot/efi/systemd-bootx64.efi
