# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 components/linux.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: make
description: |
  Linux kernel configured for use in Endless OS 7.

  See `doc/overview/signing.md` for an overview of how module signing works.

  Overridden to use Endless' Ubuntu-derived kernel instead. See also
  elements/include/linux.yml.

  The element diverged significantly from the one we derived it from, so it may
  not make sense to include further changes from the source element, include
  them at your discretion.

(@):
- elements/include/linux.yml

(?):
  - signed_boot == "endless":
      sources:
        (>):
          - kind: local
            path: files/linux/x509.genkey
  - signed_boot == "snakeoil":
      sources:
        (>):
          - kind: local
            path: files/boot-keys/MODULES-snakeoil.key
          - kind: local
            path: files/boot-keys/MODULES-snakeoil.crt

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/cpio.bst  # loongarch64 build enabled CONFIG_IKHEADERS by default
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/bc.bst
- freedesktop-sdk.bst:components/gzip.bst
- freedesktop-sdk.bst:components/openssl.bst # Override: Added.
- freedesktop-sdk.bst:components/pahole.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/rsync.bst
- freedesktop-sdk.bst:components/rust.bst
- freedesktop-sdk.bst:components/rust-bindgen.bst
- freedesktop-sdk.bst:components/rust-src.bst
# The build process uses `hexdump`
- freedesktop-sdk.bst:components/util-linux.bst
- freedesktop-sdk.bst:components/zstd.bst
# Override: Dropped components/linux-module-cert.bst

environment:
  ARCH: '%{kernel_arch}'
  # compile.h has hardcoded timestamp, let's seed it
  KBUILD_BUILD_TIMESTAMP: 'Thu Nov 10 15:00:00 UTC 2011'
  KBUILD_BUILD_USER: 'tomjon'
  MAXJOBS: "%{max-jobs}"
  # arch/x86/Makefile hardcodes -march=x86-64 -mtune=generic, overriding
  # gcc's --with-arch_64 default. KCFLAGS is appended after KBUILD_CFLAGS,
  # so a later -march wins.
  (?):
  - x86_64_v3:
      KCFLAGS: "-march=x86-64-v3 -mtune=skylake"

environment-nocache:
- MAXJOBS

variables:
  bootdir: /boot
  kernel_arch: '%{arch}'
  src-arch: x86 # Override: We explicitely only support x86.
  image-name: '$(make -s image_name)'
  optimize-debug: False
  modules-key: certs/signing_key.pem # Override: Added.
  (?): # Override: Debian-style arch names for debian/scripts/misc/annotations.
  - arch == "x86_64":
      debian_arch: amd64
  - arch == "aarch64":
      debian_arch: arm64
  strip-binaries: ""

config:
  configure-commands:
  - |
    # Generate the default kernel config for the target architecture
    make defconfig

  - |
    python3 debian/scripts/misc/annotations --export --arch "%{debian_arch}" --flavour generic > .config

  - |
    scripts/config -e DEBUG_INFO_NONE

  - |
    make -j1 olddefconfig


  install-commands:
  - |
    install -Dm644 "%{image-name}" '%{install-root}%{bootdir}/vmlinuz'
    install -Dm644 System.map '%{install-root}%{bootdir}/System.map'
    install -Dm644 .config '%{install-root}%{bootdir}/config'
    ZSTD_CLEVEL=19 make INSTALL_MOD_PATH='%{install-root}%{prefix}' modules_install

  - |
    release=$(make -s kernelrelease)
    targetdir="%{install-root}%{prefix}/src/linux-${release}"

    rm "%{install-root}%{indep-libdir}/modules/${release}"/build

    to_copy=(
      Makefile
      Module.symvers
      .config
      "arch/%{src-arch}/include"
      "arch/%{src-arch}/Makefile"
      scripts
      include
    )
    if [ "$(scripts/config -s OBJTOOL)" = y ]; then
      to_copy+=(tools/objtool/objtool)
    fi
    for file in "${to_copy[@]}"
    do
      targetfile="${targetdir}/${file}"
      dir="$(dirname "${targetfile}")"
      [ -d "${dir}" ] || install -d "${dir}"
      cp -aT "${file}" "${targetfile}"
    done

    ln -sr "${targetdir}" "%{install-root}%{indep-libdir}/modules/${release}/build"

  - |
    %{install-extra}

  # BuildStream can cache the content of the buildtree in some cases.
  # For successful builds, we must ensure the private key is deleted so that it
  # can't be pushed to the public artifact cache server.
  - |
    echo "Removing module signing key."
    rm %{modules-key}

  (?):
    - signed_boot == "snakeoil":
        configure-commands:
          (<):
            - |
              mkdir -p ./certs
              cat ./MODULES-snakeoil.key ./MODULES-snakeoil.crt > %{modules-key}
    - signed_boot == "endless":
        configure-commands:
          (<):
            - |
             mkdir -p ./certs
             cp x509.genkey ./certs/x509.genkey

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{bootdir}/System.map'
    overlap-whitelist:
    - "%{project_licensedir}"
    - "%{project_licensedir}/**"
