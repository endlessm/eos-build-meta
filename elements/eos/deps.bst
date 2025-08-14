kind: stack
description: |
  Top level stack that defines the contents of Endless OS.

  This defines everything in the filesystem tree that is built by
  BuildStream. Extra content can be injected later by `eos-image-builder`.
  Endless OS specific elements.

depends:
# Low level OS elements.
- eos/config/ostree.bst
- eos/config/systemd-sysusers.bst
- eos/eos-keyring.bst
- eos/grub.bst
- freedesktop-sdk.bst:components/dracut.bst
- freedesktop-sdk.bst:components/fscrypt.bst
- freedesktop-sdk.bst:vm/boot/efi-ostree.bst

# GNOME OS elements.
- gnome-build-meta.bst:gnomeos-deps/deps.bst
- gnome-build-meta.bst:gnomeos/os-release-user.bst

# Developer tools which are in the GNOME OS `devel` addon,
# but in the core image of EOS.
- freedesktop-sdk.bst:components/podman.bst
- freedesktop-sdk.bst:components/podman-config.bst
- gnome-build-meta.bst:gnomeos-deps/toolbox.bst

# Endless additions to GNOME OS.
- freedesktop-sdk.bst:components/git.bst
- eos/eos-event-recorder-daemon.bst
- eos/eos-factory-tools.bst
- eos/eos-kolibri.bst
- eos/eos-media.bst
- eos/eos-meta.bst
- eos/eos-metrics.bst
- eos/eos-metrics-instrumentation.bst
- eos/eos-phone-home.bst
- eos/eos-shell-content.bst
- eos/eos-theme.bst

# Used by eos-image-builder. This could move into a separate tree.
# See: <https://github.com/endlessm/eos-build-meta/issues/81>
- components/pigz.bst

# GNOME Shell Extensions
- eos/gnome-shell-extensions.bst
