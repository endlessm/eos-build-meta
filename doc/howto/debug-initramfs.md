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

## Open a shell during early boot

If boot fails during the early boot / initramfs stage, Dracut should drop you
to a shell where you can log in as root. However a few things can block this
from working. Here are some tips.

### Ensure GRUB menu timeout is non-zero

If you're wondering *how* to pass kernel commandline options to Dracut -- you need to
use the GRUB bootloader menu, and press `e` to edit the boot commands before running them.

If you don't even see the menu, even when pressing ESC during startup, edit the file
`files/grub-config/grub.cfg` and append `timeout 30`. Rebuild the ostree and image and
enjoy the long, 30-second window of opportunity you should now get to interact with
the boot menu.

### The systemd.debug-shell option

The early debug shell, enabled via the `systemd.debug-shell` kernel commandline option,
runs on virtual terminal 9 (CTRL-ALT-F9). If you're lucky enough that virtual terminal
switching works by the time you see a failure, this gives you a way to run commands as
root just by editing commandline options.

See <https://systemd.io/DEBUGGING/> for more information.

### Unlock the root account in the initramfs

If you can't login because "The root account is locked", this requires reconfiguration
of the initramfs.

You can open a workspace for Dracut with `bst workspace open components/dracut.bst`.
A Git working tree will appear at `./components/dracut` at the top of your eos-build-meta
clone. Apply a patch like the following to set the root password to `root`:

diff --git a/modules.d/68systemd-sysusers/module-setup.sh b/modules.d/68systemd-sysusers/module-setup.sh
index 477b8e7..ca70040 100755
--- a/modules.d/68systemd-sysusers/module-setup.sh
+++ b/modules.d/68systemd-sysusers/module-setup.sh
@@ -28,4 +28,7 @@ install() {
     # set read and write permission for the current user
     [[ -f "$initdir/etc/gshadow" ]] && chmod u+rw "$initdir/etc/gshadow"
     [[ -f "$initdir/etc/shadow" ]] && chmod u+rw "$initdir/etc/shadow"
+
+    # TEMP: Set a root password
+    systemd-firstboot --root="$initdir" --force --root-password "root"
 }

You can now rebuild the ostree and image stages locally to get a build which should
let you open a shell when the initramfs fails.

### Use dracut debugging tools

You can pass options to Dracut via the kernel commandline. Some useful options are:

  * `rd.break={cmdline|pre-privot,...}`: open a debug shell at a given point during startup.
  * `rd.debug`: enable `set -x` in the initramfs scripts
  * `rd.shell`: ensure a debug shell appears in case of failure

See `man dracut.cmdline` for more details of these options.
