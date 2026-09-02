kind: manual
description: |
  BusyBox, used in the Endless OS initramfs.

sources:
- kind: tar
  url: busybox:busybox-1.37.0.tar.bz2
  ref: 3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst

variables:
  build-dir: "%{build-root}/build"
  make-args: >-
    KCONFIG_NOTIMESTAMP=1
    CONFIG_PREFIX=%{install-root}%{prefix}

config:
  configure-commands:
  - |
    mkdir %{build-dir}
  # Build the default config, with everything enabled.
  - |
    make O="%{build-dir}" %{make-args} defconfig
  # Disable applet symlinks. The dracut 'busybox' module only needs the 'busybox' binary.
  - |
    sed -e 's@^CONFIG_INSTALL_APPLET_SYMLINKS=y@# CONFIG_INSTALL_APPLET_SYMLINKS is not set@' -i %{build-dir}/.config
    sed -e 's@.*CONFIG_INSTALL_APPLET_DONT.*@CONFIG_INSTALL_APPLET_DONT=y@' -i %{build-dir}/.config
    sed -e 's@^CONFIG_TC=y@# CONFIG_TC is not set@' -i %{build-dir}/.config

  build-commands:
  - |
    cd %{build-dir} && make %{make-args}

  install-commands:
  - |
    cd %{build-dir} && make install %{make-args}
