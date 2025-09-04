kind: manual
description: |
  BusyBox, used in the Endless OS initramfs.

sources:
- kind: tar
  url: busybox:busybox-1.37.0.tar.bz2
  ref: 3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4

build-depends:
- freedesktop-sdk.bst:bootstrap-import.bst

variables:
  build-dir: "%{build-root}/build"
  make-args: >-
    KCONFIG_NOTIMESTAMP=1

config:
  configure-commands:
  - |
    mkdir %{build-dir}
    # Busybox's default config has everything enabled
    make O="%{build-dir}" defconfig

  build-commands:
  - |
    cd %{build-dir} && make %{make-args}

  install-commands:
  - |
    cd %{build-dir} && make install CONFIG_PREFIX=%{install-root}
