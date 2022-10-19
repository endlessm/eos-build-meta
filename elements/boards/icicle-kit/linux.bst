kind: manual

sources:
- kind: git_tag
  url: https://github.com/polarfire-soc/linux.git
  track: mpfs-linux-5.12.x
  track-tags: false
  directory: linux
  ref: v5.12-3919-g30aca10363987018dedf93a239be72382766f740
- kind: local
  path: files/boards/icicle-kit/linux/
  directory: linux
- kind: git_tag
  url: git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
  track: master
  directory: linux-firmware

  ref: 20211027-25-gf5d519563ac9d2d1f382a817aae5ec5473811ac8
depends:
- freedesktop-sdk.bst:components/kmod.bst

build-depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/bc.bst
- freedesktop-sdk.bst:components/gzip.bst

variables:
  bootdir: /boot
  kernel_arch: riscv
  image-name: arch/riscv/boot/Image
  dtb-name: arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dtb
  command-subdir: linux

environment:
  ARCH: '%{kernel_arch}'

config:
  configure-commands:
  - |
    # Generate the default kernel config for the target architecture
    make icicle_kit_amdgpu_defconfig
    scripts/config -e PROC_DEVICETREE
    scripts/config -e PROC_FS
    scripts/config -e SYSFS
    scripts/config -e DRM_AMDGPU_CIK
    scripts/config -e DRM_AMDGPU_SI

  build-commands:
  - |
    make Image modules dtbs

  install-commands:
  - |
    install -Dm644 %{image-name} '%{install-root}%{bootdir}/Image'
    install -Dm644 %{dtb-name} '%{install-root}%{bootdir}/microchip-mpfs-icicle-kit.dtb'
    install -Dm644 System.map '%{install-root}%{bootdir}/System.map'
    make INSTALL_MOD_PATH='%{install-root}%{prefix}' modules_install

    rm %{install-root}%{indep-libdir}/modules/*/{source,build}

  - |
    make INSTALL_DTBS_PATH='%{install-root}%{bootdir}/dtbs' dtbs_install

public:
  bst:
    integration-commands:
    - |
      cd '%{indep-libdir}/modules'
      for version in *; do
        depmod -b '%{prefix}' -a "$version";
      done

    split-rules:
      devel:
        (>):
        - '%{bootdir}/System.map'
