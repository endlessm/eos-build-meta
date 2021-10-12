kind: manual

sources:
- kind: tar
  url: ftp://ftp.denx.de/pub/u-boot/u-boot-2021.04.tar.bz2
- kind: local
  path: files/boards/icicle-kit/u-boot/conf/
- kind: patch
  path: files/boards/icicle-kit/u-boot/patch/0001-riscv-icicle-kit-add-i2c-support.patch

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

build-depends:
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/gzip.bst
- freedesktop-sdk.bst:components/bc.bst

variables:
  board: smode

config:
  configure-commands:
  - make "%{board}_defconfig"

  build-commands:
  - make V=1 all
  - |
    sed -i "/^load mmc.*/i setenv bootargs 'earlyprintk debug root=/dev/mmcblk0p3 rootwait uio_pdrv_genirq.of_id=generic-uio radeon.vm_size=1 radeon.vramlimit=512'" uEnv_s-mode.txt
    tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d uEnv_s-mode.txt boot.scr

  install-commands:
  - install -Dm644 -t "%{install-root}%{indep-libdir}/u-boot/%{board}" u-boot.bin
  - install -Dm644 -t "%{install-root}%{indep-libdir}/u-boot/%{board}" boot.scr
  - install -Dm755 -t "%{install-root}%{bindir}" tools/mkimage
