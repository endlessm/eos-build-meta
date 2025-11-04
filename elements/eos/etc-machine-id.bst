kind: manual
description: |
  Create an empty /etc/machine-id file.

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

public:
  initial-script:
    script: |
      # When systemd boots on a machine where /etc/machine-id is empty, its behaviour
      # depends on whether /etc is writable:
      #
      #   * writable /etc: generates a new machine ID and saves it to the file.
      #   * read-only /etc: generates a new machine ID and bind-mounts its in place.
      #
      # If /etc/machine-id is missing rather than empty, boot fails on systems where /etc
      # is read-only -- The Endless OS live media is readonly so we can't be having that.
      #
      # The presence of /etc/machine-id also stops the systemd-firstboot service from
      # running. (EOS7 uses gnome-initial-setup, rather than systemd-firstboot, so
      # this is by design).
      #
      # See also:
      #
      #   - <https://github.com/endlessm/eos-build-meta/issues/95>
      #   - <https://www.freedesktop.org/software/systemd/man/latest/machine-id.html#First%20Boot%20Semantics>.
      touch $SYSROOT/etc/machine-id
