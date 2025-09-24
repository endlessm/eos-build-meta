kind: manual
description: |
  UEFI applications and bootloader configuration.

  This element collects all the UEFI applications and configuration involved in
  booting EOS7.

  These are installed to the well-known path `/usr/lib/efi_binaries` in the
  filesystem. When building images, eos-image-builder copies them into the
  EFI System Partition.

  At time of writing, the ESP is not updated on existing systems in any case.
  It could be done, using coreos bootupd or something similar.

build-depends:
  - freedesktop-sdk.bst:bootstrap-import.bst

(?):
  - signed_boot == "eos-sb-signer":
      depends:
        - eos/signed-grub.bst
  - signed_boot == "snakeoil":
      depends:
        - eos/signed-grub-snakeoil.bst

sources:
  # See `files/shim/README.md` for context about these files.
  - kind: local
    path: files/shim/bootx64.csv
  - kind: local
    path: files/shim/fbx64.efi
  - kind: local
    path: files/shim/mmx64.efi
  - kind: local
    path: files/shim/shimx64.efi

config:
  install-commands:
    - |
      mkdir -p %{install-root}/usr/lib/efi_binaries/EFI/endless/

    # File `grubx64.efi` is installed to `/usr/lib/efi_binaries` by grub/grub-x86_64-efi.bst.
    - |
      echo "Creating 'endless' UEFI entry"
      install -D -m644 ./bootx64.csv %{install-root}/usr/lib/efi_binaries/EFI/endless/
      install -D -m644 ./fbx64.efi %{install-root}/usr/lib/efi_binaries/EFI/endless/
      install -D -m644 ./mmx64.efi %{install-root}/usr/lib/efi_binaries/EFI/endless/
      install -D -m644 ./shimx64.efi %{install-root}/usr/lib/efi_binaries/EFI/endless/

    - |
      echo "Creating default UEFI entry"
      install -D -m644 ./shimx64.efi %{install-root}/usr/lib/efi_binaries/EFI/BOOT/BOOTX64.EFI
      install -D -m644 ./fbx64.efi %{install-root}/usr/lib/efi_binaries/EFI/BOOT/
      install -D -m644 ./mmx64.efi %{install-root}/usr/lib/efi_binaries/EFI/BOOT/
