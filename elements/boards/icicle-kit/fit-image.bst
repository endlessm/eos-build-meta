kind: manual

build-depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/dtc.bst
- boards/icicle-kit/u-boot.bst
- boards/icicle-kit/linux.bst

variables:
  bootdir: '/boot'

config:
  configure-commands:
  - |
    cat << EOF > fit-image.its
    /dts-v1/;

    / {
            description = "U-Boot fitImage for testing";
            #address-cells = <1>;

            images {
                    kernel1 {
                            description = "Linux kernel";
                            data = /incbin/("kernel.lzma");
                            type = "kernel";
                            arch = "riscv";
                            os = "linux";
                            compression = "lzma";
                            load = <0x80200000>;
                            entry = <0x80200000>;
                            hash@1 {
                                    algo = "sha256";
                            };
                    };
                    fdt {
                            description = "Flattened Device Tree blob";
                            data = /incbin/("dtb.lzma");
                            type = "flat_dt";
                            arch = "riscv";
                            compression = "lzma";
                            load = <0x82200000>;
                            hash@1 {
                                    algo = "sha256";
                            };
                    };
            };

            configurations {
                    default = "conf_microchip_icicle-kit-es-a000-microchip.dtb";
                    conf_microchip_icicle-kit-es-a000-microchip.dtb {
                            description = "1 Linux kernel, FDT blob";
                            kernel = "kernel1";
                            fdt = "fdt";

                            hash@1 {
                                    algo = "sha256";
                            };
                    };
            };
    };
    EOF
  build-commands:
  - |
    echo "Compressing kernel build objects"
    # compess the kernel and dtb (kernel the biggest, dtb not so useful?)
    lzma -z -9 < %{bootdir}/Image > kernel.lzma
    lzma -z -9 < %{bootdir}/microchip-mpfs-icicle-kit.dtb > dtb.lzma

    mkimage -f fit-image.its -A riscv -O linux -T flat_dt fitImage.fit

  install-commands:
  - |
    install -Dm644 fitImage.fit '%{install-root}%{bootdir}/fitImage.fit'

