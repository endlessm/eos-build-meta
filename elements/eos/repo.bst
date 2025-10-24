# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-24.08.22 vm/minimal-ostree/repo.bst

kind: script
description: |
  Prepare the filesystem tree and convert it to OSTree commit.

  The output artifact contains a `ostree/repo` directory which is an OSTree
  repo in `archive` format with a single commit and a single branch.

  The element diverged significantly from the one we derived it from, so it may
  not make sense to include further changes from the source element, include
  them at your discretion.

build-depends:
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:vm/deploy-tools.bst
- freedesktop-sdk.bst:vm/prepare-image.bst
- components/linux.bst
- eos/initial-scripts.bst
- tools/systemd-sysusers-override.bst
- filename: eos/filesystem.bst
  config:
    location: '/sysroot'

(?):
  - signed_boot == "endless":
      build-depends:
        (>):
          - signing/signed-kernel-endless.bst
  - signed_boot == "snakeoil":
      build-depends:
        (>):
          - signing/signed-kernel-snakeoil.bst

variables:
  uuidnamespace: 731a6fa6-5071-4d7b-8e0d-b81a66a590bc
  ostree-branch: "os/eos/amd64/master"

environment:
  OSTREE_REPO: "%{install-root}/ostree/repo"

config:

  commands:
  - mkdir -p /tmp
  - mkdir -p /efi

  # Prepare the filesystem tree, which includes:
  #
  #   * Running the scripts in `/etc/fdsdk/initial_scripts` (see the
  #     initial-scripts.bst element)
  #   * Setting up files in `/etc`
  #   * Runing `systemd-firstboot` and `systemctl preset-all` against the tree
  #   * Creating initial `/etc/fstab` with the root and boot partitions
  #
  # The `--noboot` option means: "Don't auto-mount the ESP via /etc/fstab".
  - |
    prepare-image.sh \
       --sysroot /sysroot \
       --seed "%{uuidnamespace}" \
       --rootsource /dev/gpt-auto-root \
       --noboot

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
  - |
    touch /sysroot/etc/machine-id

  # Move the kernel where OSTree will find it.
  - |
    version="$(ls -1 /sysroot/usr/lib/modules | head -n1)"
    mkdir -p "/sysroot/usr/lib/modules/${version}"
    cp /boot/vmlinuz.signed "/sysroot/usr/lib/modules/${version}/vmlinuz"
    cp /boot/config "/sysroot/usr/lib/modules/${version}/config"

  # Apply Endless OS specific configuration to systemd-sysusers config.
  #
  # These changes are needed for backwards compatibility with existing EOS6
  # systems.
  #
  # We post-processing the filesystem in preference to patching or
  # reconfiguring systemd.bst in order to reuse the systemd build from
  # Freedesktop SDK.
  #
  # See `doc/sysusers.md` for more information.
  - |
    # Rename 'wheel' group to 'sudo'
    sed -e 's/^g wheel/g  sudo/' -i /sysroot/usr/lib/sysusers.d/basic.conf
  - |
    systemd_sysusers_override.py /sysroot/usr/lib/sysusers.d/basic.conf --group adm --static-id 4
    systemd_sysusers_override.py /sysroot/usr/lib/sysusers.d/basic.conf --group lp --static-id 7
    systemd_sysusers_override.py /sysroot/usr/lib/sysusers.d/basic.conf --group sudo --static-id 27
    systemd_sysusers_override.py /sysroot/usr/lib/sysusers.d/basic.conf --group utmp --static-id 43
    systemd_sysusers_override.py /sysroot/usr/lib/sysusers.d/polkit.conf --user polkitd --static-id 105
    systemd_sysusers_override.py /sysroot/usr/lib/sysusers.d/systemd-journal.conf --group systemd-journal --static-id 121
    systemd_sysusers_override.py /sysroot/usr/lib/sysusers.d/systemd-timesync.conf --user systemd-timesync --static-id 133

  # Update tmpfiles.d configs for 'wheel' group rename.
  - |
    sed -e 's/ wheel / sudo /' -i /sysroot/usr/lib/tmpfiles.d/cups.conf
    sed -e 's/:group:wheel:/:group:sudo:/' -i /sysroot/usr/lib/tmpfiles.d/systemd.conf

  - mkdir -p "${OSTREE_REPO}"
  - ostree init --repo="${OSTREE_REPO}" --mode=archive
  - mv /sysroot/etc /sysroot/usr/etc
  - ostree commit --branch=%{ostree-branch} /sysroot
