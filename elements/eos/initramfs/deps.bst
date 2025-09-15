kind: stack
description: |
  Stack that defines the contents of the Endless OS initramfs.

  Based somewhat on
  <https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/master/elements/gnomeos/initramfs/deps.bst>.

depends:
- eos/initramfs/busybox.bst
- eos/initramfs/dash.bst
- freedesktop-sdk.bst:components/cpio.bst
- freedesktop-sdk.bst:components/efivar.bst
- freedesktop-sdk.bst:components/kmod.bst
- freedesktop-sdk.bst:components/linux-firmware.bst
- freedesktop-sdk.bst:components/shadow.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/wireless-regdb-bin.bst
- gnome-build-meta.bst:gnomeos-deps/plymouth-gnome-theme.bst
- gnome-build-meta.bst:gnomeos-deps/intel-ucode.bst
- gnome-build-meta.bst:gnomeos/os-release-user.bst
# FIXME: Signing modules will be useful. In EOS7 we need to do this
# differently vs GNOME OS.
#- gnome-build-meta.bst:gnomeos/initramfs/signed-modules.bst
#- gnomeos/initramfs/signed-nvidia-modules.bst
