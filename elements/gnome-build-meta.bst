kind: junction

sources:
- kind: git_repo
  url: gnome:gnome-build-meta.git
  track: 48*
  ref: 48.2-0-g5d5d8f32365d766001d9b48a6643d6962a9dc94a

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
