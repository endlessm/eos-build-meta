# How to debug initramfs issues

The EOS7 initramfs build process uses Dracut.

See the `eos/initramfs.bst` element for an overview of the main initramfs.

See the `eos/payg/uki.bst` element for details on the UKI used in PAYG devices.

## Inspecting the built initramfs

Linux initramfs files are packed using cpio, an ancient technology from decades past.
Dracut builds a small cpio archive containing microcode, then appends the main body
of the initramfs as a separate blob. In EOS7 this blob is compressed with Zstd
compression. Extracting the initramfs contents is a fun job. Here's how you
might do it.

1. Checkout the built artifact from the artifact cache.

	bst artifact checkout --deps none eos/initramfs.bst --directory ./initramfs

    You should now have `initramfs/usr/lib/modules/$(version)/initramfs` available,
    change to that directory as well.

2. Use the `skipcpio` tool from Dracut which will write the body of the
   initramfs to stdout. Make sure dracut and zstd installed on your build
   machine, of course.

    /usr/lib/dracut/skipcpio initramfs | zstd -d > initramfs.body.cpio

3. You can now unpack the initramfs into a new, empty directory with `cpio`:

	mkdir extract
	cd extract
	cpio -idmv < ../initramfs.body.cpio

You can also compare it against a different initramfs using
[diffoscope](https://diffoscope.org/), which will unpack the cpio archive for you.

## Inspecting the PAYG UKI

The UKI is only used for PAYG devices.

Note that building the UKI is only possible within Endless. But you can find
the binary in all prebuilt EOS7 images at `/usr/lib/modules/$(version)/payg-image.efi`.

You can use `ukify inspect` to examine a UKI binary.

To extract contents of one of the sections, for example the initramfs, use `objdump`:

	objcopy --dump-section .initrd="./initramfs" ./payg-image.efi
