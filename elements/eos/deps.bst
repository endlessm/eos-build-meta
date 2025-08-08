kind: stack
description: |
  Top level stack that defines the contents of Endless OS.

  This defines everything in the filesystem tree that is built by
  BuildStream. Extra content can be injected later by `eos-image-builder`.
  Endless OS specific elements.

depends:
# Low level OS elements.
- eos/config/ostree.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:vm/boot/efi-ostree.bst

# GNOME OS elements.
- gnome-build-meta.bst:gnomeos-deps/deps.bst
- gnome-build-meta.bst:gnomeos/os-release-user.bst

# Endless additions to GNOME OS.
- eos/eos-media.bst
- eos/eos-meta.bst
- eos/eos-theme.bst
