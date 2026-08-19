# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 components/_private/cups-base.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: autotools
description:
  Printing system.

  Overridden to rename the 'wheel' group to 'sudo', and to add sysuser ids (cf.
  doc/overview/sysusers.md) for backwards compatibility with Endless OS 6.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- freedesktop-sdk.bst:components/avahi-libs.bst
- freedesktop-sdk.bst:components/gzip.bst
- freedesktop-sdk.bst:components/openssl.bst
- freedesktop-sdk.bst:components/systemd.bst

variables:
  license-files-extra: NOTICE
  # Makefiles not added to build-dir which makes it unusable
  build-dir: ''
  make-install-args: DSTROOT="%{install-root}" install
  conf-local: >-
    --enable-debug
    --with-components=all
    --with-dbusdir=/etc/dbus-1
    --with-tls=openssl
    --with-cups-group=lp
    --with-pkgconfpath="%{libdir}/pkgconfig"
    --with-system-groups=sudo
    --with-rundir=/run/cups
    localedir=/usr/share/locale
    DSOFLAGS="$CFLAGS $LDFLAGS"

config:
  install-commands:
    (>):
    - |
      tmpfilesdir="$(pkg-config --variable tmpfilesdir systemd)"
      install -Dm644 tmpfiles.conf "%{install-root}${tmpfilesdir}/cups.conf"

    - |
      sysusersdir="$(pkg-config --variable sysusersdir systemd)"
      install -Dm644 sysusers.conf "%{install-root}${sysusersdir}/cups.conf"

public:
  bst:
    split-rules:
      cups-libs:
      - '%{datadir}/locale'
      - '%{datadir}/locale/**'
      - '%{includedir}'
      - '%{includedir}/**'
      - '%{bindir}/cups-config'
      - '%{bindir}/lpr'
      - "%{libdir}/pkgconfig/cups.pc"
      - '%{libdir}/lib*.so'
      - '%{libdir}/lib*.so.*'
      - '%{debugdir}%{bindir}/lpr.debug'
      - '%{debugdir}%{libdir}/lib*.so.*'
      - '%{debugdir}/dwz'
      - '%{debugdir}/dwz/**'
      - '%{sourcedir}'
      - '%{sourcedir}/**'
      cups-license:
      - "%{project_licensedir}"
      - "%{project_licensedir}/**"
  cpe:
    product: cups

sources:
- kind: git_repo
  url: github:OpenPrinting/cups.git
  track: v*
  exclude:
  - "*a*"
  - "*b*"
  - "*rc*"
  - "*op*"
  ref: v2.4.19-0-g6ba0487abb05afc93d639f37676add8fd65d3756
- kind: local
  # Overridde: Modified to name the system group "sudo".
  path: files/cups/tmpfiles.conf
- kind: local
  # Overridde: Hardcodes the user ID for one of the sysusers, instead of
  # dynamically allocating one. Cf. doc/overview/sysusers.md.
  path: files/cups/sysusers.conf
