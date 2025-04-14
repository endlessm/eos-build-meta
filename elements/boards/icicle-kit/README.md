
These elements will produce a Gnome OS Image compatible with Microchip's Icicle Kit Devboards.
The devboard don't feature any graphical hardware of any kind, but do come with a PCIe slot, which is compatible with a limited number of graphics cards.

Of all the graphics cards we tested, we found we were only able to use a HD6450 successfully.
These cards can be found on ebay.

### Building

These elements work by leveraging Buildstream's conterisation by creating a Risc-V userland environment to trick the project into cross-compiling on an x86 build machine.
As such, in addition to the project's normal dependencies, qemu-riscv64-static must be installed, and binfmt-misc must be setup on the host.

The following commands will format an SDCard with gnome-os. In the commands, the sdcard is assumed to exist at /dev/mmcblk0, adjust as appropreate.

```
export SDCARD=/dev/mmcblk0
bst -o arch riscv64 build boards/icicle-kit/image.bst
bst -o arch riscv64 checkout boards/icicle-kit/image.bst checkout
sudo dd if=checkout/sdcard.img of=${SDCARD} bs=4k
```

The build step may take a number of days due to qemu trickery.

Once complete, you will be able to take the SD Card and boot from it on your icicle devkit.

