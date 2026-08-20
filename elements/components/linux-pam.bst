# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 components/linux-pam.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: manual
description: |
  Base configuration files for PAM authentication system.

  PAM is an authentication framework, used by most Linux operating systems to
  authenticate and manage user logins. The PAM client library and the plugins
  are provided by `components/linux-pam-base.bst`.

  This element provides a default configuration which you should review and
  adapt for your use case. Other elements can install PAM configuration
  for specific utilities. In particular, see `components/shadow.bst` which
  includes a `/usr/bin/login` implementation and PAM configuration.

  The "Linux PAM System Administrators' Guide" is recommended reading to
  understand PAM configuration, it is available in the linux-pam source code
  repository at `doc/sag`.

  This element is intended for system integration, it is not included
  in Flatpak or OCI images.

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

build-depends:
- freedesktop-sdk.bst:bootstrap/bash.bst
- freedesktop-sdk.bst:bootstrap/coreutils.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst

runtime-depends:
- freedesktop-sdk.bst:components/linux-pam-base.bst
- freedesktop-sdk.bst:components/pwquality.bst

variables:
  pamconfdir: "%{sysconfdir}/pam.d"
  strip-binaries: ''

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
