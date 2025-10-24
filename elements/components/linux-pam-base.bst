# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-24.08.22 components/linux-pam-base.bst

kind: meson
description: |
  Derived to enable usergroups for private user groups, the UMASK 0002, and to
  extend env PATH.

  ---
  From 31c080b4292ab01371ecf57ff4bfaba53af52564 Mon Sep 17 00:00:00 2001
  From: Jian-Hong Pan <jhp@endlessos.org>
  Date: Tue, 15 Apr 2025 17:03:25 +0800
  Subject: [PATCH 2/3] [Endless] linux-pam: Enable usergroups for private user
   groups, the UMASK 0002

  With every user having their own group, the "historical" umask of 0022
  is excessively restrictive. For example, create an user account "user1"
  on GNOME OS current version. The user will have username "user1" in
  primary group "user1" but umask is 0022. The main disadvantage is that
  it prevents setting up shared directories for common access.

  To enable this type of shared directories, add the pam_umask module
  configured with usergroups=true so that the default umask becomes 0002
  (instead of 0022). Then, new files in shared directories can be read &
  written by the users in the same group.

  AC:
  - Command "umask" should output 0002.
  - 1. Have two users: user1 and user2 on the system.
    2. Add user2 into user1's group "user1" by command:
       "sudo usermod -aG user1 user2".
    3. User1 creates a folder by command: "mkdir -p /tmp/test". Then,
       create a dummy file into it by "touch /tmp/test/dummy.txt".
    4. User1 logs out. And, login with user2. User2 should be able to
       modify "/tmp/test/dummy.txt".

  https://phabricator.endlessm.com/T31847
  https://phabricator.endlessm.com/T35802
  https://github.com/endlessm/eos-build-meta/pull/2#discussion_r2050472931
  ---
  From 87c594400353fd9ced64fffaacdceddb22133af9 Mon Sep 17 00:00:00 2001
  From: Jian-Hong Pan <jhp@endlessos.org>
  Date: Tue, 15 Apr 2025 16:16:42 +0800
  Subject: [PATCH 3/3] [Endless] linux-pam: Extend env PATH

  EOS 6 (including before) extends env PATH with more paths:
  "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
  * Users can access commands in /usr/sbin and /sbin without full path. It
    is useful for commands, such as reboot and poweroff.
  * Users may install applications into /usr/local/{bin, games, sbin}.

  GNOME OS provides env PATH as "/bin:/usr/bin" by default.
  * After check GNOME OS' filesystem, notice:
    - /bin is linked to /usr/bin
    - /sbin is linked to /usr/sbin
    - /usr/sbin is linked to /usr/bin
    Which means users already can access the commands in /usr/sbin and
    /sbin without full path directly.
  * EOS has an immutable filesystem maintained by OSTree and /usr/games is
    an empty directory.

  Consider the mentioned above, the new env PATH can be simplified as
  "/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games" and
  extended by configuring /etc/environment.

  Note: "$HOME/.local/bin" will be prepended by shell automatically.

  AC: Command "printenv PATH"'s output should include
  "/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games"

  https://phabricator.endlessm.com/T11289
  https://phabricator.endlessm.com/T35802
  ---

depends:
- freedesktop-sdk.bst:components/audit.bst
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/libeconf.bst

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/flex.bst

variables:
  meson-local: >-
    -Dpam_lastlog=enabled
    -Dexamples=false
    -Dlogind=disabled
    -Dnis=disabled
    -Dselinux=disabled
    -Ddocs=disabled
    -Dusergroups=true

config:
  install-commands:
    (>):
    - |
      rm -rf "%{install-root}/var/run"
      # Add PATH to /etc/environment if it's not present there or in
      # /etc/security/pam_env.conf
      if ! grep -qs ^PATH "%{install-root}"/etc/security/pam_env.conf; then
        if ! grep -qs ^PATH= "%{install-root}"/etc/environment; then
          echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games"' >> "%{install-root}"/etc/environment
        fi
      fi

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libpam.so'
        - '%{libdir}/libpam_misc.so'
        - '%{libdir}/libpamc.so'
      vm-only:
        # Most of this is only useful for VM.
        # We keep only libraries for dependencies.
      - '%{sysconfdir}'
      - '%{sysconfdir}/**'
      - '%{bindir}'
      - '%{bindir}/**'
      - '%{datadir}'
      - '%{datadir}/**'
  cpe:
    product: linux-pam

sources:
- kind: git_repo
  url: github:linux-pam/linux-pam.git
  track: v*
  ref: v1.7.0-0-gea980d991196df67cdd56b3f65d210b73218d08a
