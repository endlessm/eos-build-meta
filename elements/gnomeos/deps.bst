kind: stack

depends:
- gnomeos-deps/deps.bst

- gnomeos/repart-config.bst
- gnomeos/initramfs/signed-modules.bst
- gnomeos/sysupdate-config.bst
- gnomeos/ld-config.bst
- gnomeos/preset-all.bst
- gnomeos/import-deployment-pub-key.bst
- gnomeos/os-release-user.bst
- freedesktop-sdk.bst:components/btrfs-progs.bst
- gnomeos/fwupd-efi-signed-maybe.bst
- gnomeos/replace-signed-systemd-boot.bst
- gnomeos-deps/efitools-maybe.bst
- gnomeos/reload-sysext.bst
- gnomeos-deps/mokutil.bst

(?):
- arch in ["x86_64"]:
    depends:
      (>):
      - gnomeos/sysupdate-nvidia-config.bst
