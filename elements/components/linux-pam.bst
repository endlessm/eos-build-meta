# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-24.08.22 components/linux-pam.bst

kind: manual
description: |
  Derived to allow weak passwords.

  ---
  From f87652e89d5f3051f95245b1bed2e1f75e43b2f9 Mon Sep 17 00:00:00 2001
  From: Jian-Hong Pan <jhp@endlessos.org>
  Date: Tue, 15 Apr 2025 14:17:54 +0800
  Subject: [PATCH 1/3] [Endless] linux-pam: Allow weak passwords

  Allow weak passwords by dropping pam_pwquality.so module check and
  pam_unix.so's use_authtok. If pam_unix.so keeps use_authtok, the new
  password still have to pass pam_pwquality.so test [1]. Here is an
  example of dropped pam_pwquality.so module, but pam_unix.so keeping
  use_authtok. Passwd prints "Authentication token manipulation error"
  directly:

  $ passwd
  Changing password for dev.
  Current password:
  passwd: Authentication token manipulation error
  passwd: password unchanged

  Besides, the default nullok_secure [2] setting only allows passwordless
  accounts to access services like sudo and polkit from certain types of
  terminals. Instead, nullok is configured here because EOS would like
  passwordless accounts to be usable in all contexts, including terminal
  apps running in the desktop environment.

  AC:
  - Command "passwd" can change current user's password to 111.
  - When logged into the desktop of passwordless account, running
    "sudo -s" in a Terminal gives a root shell without a password prompt.
  - When logged into the desktop of passwordless account, in Settings,
    choosing Users then clicking Unlock unlocks the panel without a
    password prompt.

  [1]: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/system-level_authentication_guide/pam_configuration_files#Sample_PAM_Configuration_Files
  [2]: https://manpages.debian.org/stretch/libpam-modules/pam_unix.8.en.html

  https://phabricator.endlessm.com/T14095
  https://phabricator.endlessm.com/T35802
  ---

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

runtime-depends:
- freedesktop-sdk.bst:components/linux-pam-base.bst
- freedesktop-sdk.bst:components/pwquality.bst

variables:
  pamconfdir: "%{sysconfdir}/pam.d"

config:
  build-commands:
  - for tty in tty{1..6}; do echo "${tty}"; done >securetty

  install-commands:
  - install -Dm 644 -t "%{install-root}%{pamconfdir}" pam.d/*
  - install -Dm644 -t "%{install-root}%{sysconfdir}" securetty

sources:
- kind: local
  path: files/linux-pam-config
  directory: pam.d
