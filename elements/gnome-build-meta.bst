# This is derived from gnome-build-meta 48.3, ensure to update it when rebasing.

kind: junction

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: 48*
  ref: 48.3-0-g4a74edcfcfc5b0bf5b55d56e2343900fc4f94aae

config:
  overrides:
    core/meta-gnome-core-apps.bst: core/meta-gnome-core-apps.bst
    freedesktop-sdk.bst: freedesktop-sdk.bst
    gnomeos/fwupd-efi-signed.bst: gnomeos/fwupd-efi-signed.bst
    gnomeos/generate-initramfs.bst: gnomeos/generate-initramfs.bst
    gnomeos/import-deployment-pub-key.bst: gnomeos/import-deployment-pub-key.bst
    gnomeos/initramfs/signed-modules.bst: gnomeos/initramfs/signed-modules.bst
    gnomeos/initramfs/signed-nvidia-modules.bst: gnomeos/initramfs/signed-nvidia-modules.bst
    gnomeos/signed-boot.bst: gnomeos/signed-boot.bst
    gnomeos/signed-boot-common.bst: gnomeos/signed-boot-common.bst
    gnomeos/replace-signed-systemd-boot.bst: gnomeos/replace-signed-systemd-boot.bst
    gnomeos-deps/efitools.bst: gnomeos-deps/efitools.bst
    gnomeos-deps/nvidia-drivers.bst: gnomeos-deps/nvidia-drivers.bst
    gnomeos-deps/shim.bst: gnomeos-deps/shim.bst
    iso/signed-image.bst: iso/signed-image.bst
