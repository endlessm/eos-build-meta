kind: manual
description: |
  Override Freedesktop SDK's systemd sysusers config

  These changes ensure that systems running EOS6 can be updated to EOS7,
  by setting some specific static UIDs and group names that differed from
  upstream defaults in previous versions of Endless OS.

  The script runs when the final filesystem is being assembled in `repo.bst`,
  so it can operate on all installed files in `usr/lib/sysusers.d`.

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

runtime-depends:
- freedesktop-sdk.bst:components/python3.bst

config:
  install-commands:
  - |
    install -Dm 755 -t "%{install-root}%{bindir}" systemd_sysusers_override.py

sources:
- kind: local
  path: files/systemd-sysusers-override/systemd_sysusers_override.py

public:
  initial-script:
    script: |
      SYSROOT="${1}"

      # Apply Endless OS specific configuration to systemd-sysusers config.
      #
      # These changes are needed for backwards compatibility with existing EOS6
      # systems.
      #
      # We post-process the filesystem in preference to patching or
      # reconfiguring systemd.bst in order to reuse the systemd build from
      # Freedesktop SDK.
      #
      # See `doc/sysusers.md` for more information.
      # Rename 'wheel' group to 'sudo'
      sed -e 's/^g wheel/g  sudo/' -i $SYSROOT/usr/lib/sysusers.d/basic.conf

      systemd_sysusers_override.py $SYSROOT/usr/lib/sysusers.d/basic.conf --group adm --static-id 4
      systemd_sysusers_override.py $SYSROOT/usr/lib/sysusers.d/basic.conf --group lp --static-id 7
      systemd_sysusers_override.py $SYSROOT/usr/lib/sysusers.d/basic.conf --group sudo --static-id 27
      systemd_sysusers_override.py $SYSROOT/usr/lib/sysusers.d/basic.conf --group utmp --static-id 43
      ls -al $SYSROOT/usr/lib/sysusers.d/polkit.conf
      systemd_sysusers_override.py $SYSROOT/usr/lib/sysusers.d/polkit.conf --user polkitd --static-id 105
      systemd_sysusers_override.py $SYSROOT/usr/lib/sysusers.d/systemd-journal.conf --group systemd-journal --static-id 121
      systemd_sysusers_override.py $SYSROOT/usr/lib/sysusers.d/systemd-timesync.conf --user systemd-timesync --static-id 133

      # Update tmpfiles.d configs for 'wheel' group rename.
      ls -l $SYSROOT/usr/lib/tmpfiles.d/cups.conf
      sed -e 's/ wheel / sudo /' -i $SYSROOT/usr/lib/tmpfiles.d/cups.conf
      sed -e 's/:group:wheel:/:group:sudo:/' -i $SYSROOT/usr/lib/tmpfiles.d/systemd.conf
