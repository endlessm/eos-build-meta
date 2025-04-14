kind: script

build-depends:
- boards/icicle-kit/filesystem.bst
- boards/icicle-kit/u-boot.bst
- boards/icicle-kit/fit-image.bst
- freedesktop-sdk.bst:integration/mtab.bst
- freedesktop-sdk.bst:components/genimage.bst
- freedesktop-sdk.bst:components/tar.bst
- freedesktop-sdk.bst:vm/prepare-image.bst

variables:
  bootdir: '/boot'
  board: smode
  bootloader: hsspayload.bin

config:
  layout:
  - element: ''
    destination: '/genimage'
  - element: integration/mtab.bst
    destination: '/'
  - element: components/genimage.bst
    destination: '/'
  - element: components/tar.bst
    destination: '/'
  - element: vm/prepare-image.bst
    destination: '/'
  - element: ''
    destination: /tmp
  - element: boards/icicle-kit/filesystem.bst
    destination: /sysroot
  - element: boards/icicle-kit/u-boot.bst
    destination: '/'
  - element: boards/icicle-kit/fit-image.bst
    destination: '/'

  commands:
  - |
    cd /sysroot
    mkdir -p {srv,sys,tmp,dev,sys,proc}
    touch etc/machine-id

  - |
    # Disable coredumps
    cat >/sysroot/etc/security/limits.conf <<EOF
    * hard core 0
    * soft core 0
    EOF
    cat >/sysroot/etc/sysctl.conf <<EOF
    fs.suid_dumpable=0
    kernel.core_pattern=|/bin/false
    EOF

  - |
    # Disable pipewire
    find /sysroot -name "pipewire*.service" -exec sed -i "s/Restart=.*/Restart=never/" {} \;

  - |
    # move r600 out of the way.
    mv /sysroot/usr/lib/riscv64-linux-gnu/GL/default/lib/dri/r600_dri.so{,.old}
    mv /sysroot/usr/lib/riscv64-linux-gnu/GL/default/lib/dri/r600_drv_video.so{,.old}

    # force gdm to use softpipe.
    echo GALLIUM_DRIVER=softpipe >> /sysroot/etc/environment
    sed -i "s/#DefaultEnvironment/DefaultEnvironment=GALLIUM_DRIVER=softpipe/" /sysroot/etc/systemd/system.conf
    sed -i "/^[Service].*/i Environment=GALLIUM_DRIVER=softpipe" /sysroot/usr/lib/systemd/user/org.gnome.Shell@wayland.service
    sed -i "/^[Service].*/i Environment=GALLIUM_DRIVER=softpipe" /sysroot/usr/lib/systemd/system/gdm.service

  - |
    prepare-image.sh \
       --sysroot /sysroot \
       --rootsource /dev/mmcblk0p3 \
       --rootfstype ext4 \
       --rootpasswd gnome \
       --noboot >/dev/null

  - |
    export BOOTLOADER_SIZE=$(((`stat -c%s %{indep-libdir}/u-boot/%{board}/%{bootloader}` + 511)/512*512))
    cat >/genimage/genimage.cfg <<EOF

    image boot.vfat {
        vfat {
            files = {
                "%{bootdir}/fitImage.fit",
                "%{indep-libdir}/u-boot/%{board}/boot.scr"
            }
        }
        size = 64M
    }
    image rootfs.ext4 {
        ext4  {
            label = "root"
            use-mke2fs = true
        }
        size = 6G
    }
    image sdcard.img {
        hdimage {
            gpt = true
        }
        partition uboot {
            image = "%{indep-libdir}/u-boot/%{board}/%{bootloader}"
            partition-type-uuid = 21686148-6449-6E6F-744E-656564454649 # HSS-PAYLOAD
            size = $BOOTLOADER_SIZE
    #        offset = 2048
        }
        partition kernel {
            partition-type = 0xC
            image = "boot.vfat"
            partition-type-uuid = 0FC63DAF-8483-4772-8E79-3D69D8477DE4 # Linux
        }
        partition root {
            partition-type = 0x83
            image = "rootfs.ext4"
            partition-type-uuid = 0FC63DAF-8483-4772-8E79-3D69D8477DE4 # Linux
        }
    }
    EOF

  - |
    cd /genimage
    genimage --rootpath /sysroot

  - |
    install -Dm644 -t "%{install-root}" genimage/images/sdcard.img

