kind: manual

sources:
- kind: tar
  url: ftp://ftp.denx.de/pub/u-boot/u-boot-2021.04.tar.bz2
  ref: 0d438b1bb5cceb57a18ea2de4a0d51f7be5b05b98717df05938636e0aadfe11a
- kind: local
  path: files/boards/icicle-kit/u-boot/conf/
- kind: patch
  path: files/boards/icicle-kit/u-boot/patch/0001-riscv-icicle-kit-add-i2c-support.patch
- kind: tar
  url: https://github.com/polarfire-soc/hart-software-services/releases/download/2021.04/hss-payload-generator-0.99.16-linux-x86_64.tar.gz
  ref: 090938c41a4568936e081631f236a5146dcde02389224fd87be29b3578a8a3b9
  base-dir: ''
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
    sed -i "/^load mmc.*/i setenv bootargs 'earlycon=sbi root=/dev/mmcblk0p3 rootwait console=ttyS0,115200n8 uio_pdrv_genirq.of_id=generic-uio pci-hpmemsize=0M libata.force=noncq radeon.vm_size=1 radeon.vramlimit=512'" uEnv_s-mode.txt
    tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d uEnv_s-mode.txt boot.scr

  - |
    # generate HSS payload
    ./hss-payload-generator -c icicle-kit-es-hsspayload.yaml -v hsspayload.bin

  install-commands:
  - install -Dm644 -t "%{install-root}%{indep-libdir}/u-boot/%{board}" u-boot.bin
  - install -Dm644 -t "%{install-root}%{indep-libdir}/u-boot/%{board}" hsspayload.bin
  - install -Dm644 -t "%{install-root}%{indep-libdir}/u-boot/%{board}" boot.scr
  - install -Dm755 -t "%{install-root}%{bindir}" tools/mkimage
