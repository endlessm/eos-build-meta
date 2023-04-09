kind: autotools

# This element is not be used directly. Use either:
#  - core-deps/qemu.bst
#  - vm/qemu-guest-agent.bst

sources:
- kind: tar
  url: https://download.qemu.org/qemu-7.2.0.tar.xz
  ref: 5b49ce2687744dad494ae90a898c52204a3406e84d072482a1e1be854eeb2157
- kind: local
  # https://sources.debian.org/data/main/q/qemu/1%3A7.2%2Bdfsg-5/debian/qemu-guest-agent.service
  path: files/qemu/qemu-guest-agent.service
- kind: local
  # https://sources.debian.org/data/main/q/qemu/1%3A7.2%2Bdfsg-5/debian/qemu-guest-agent.udev
  path: files/qemu/qemu-guest-agent.udev

build-depends:
- core-deps/spice-protocol.bst
- freedesktop-sdk.bst:components/perl.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- sdk/gtk+-3.bst
- core-deps/libcacard.bst
- core-deps/spice.bst
- core-deps/usbredir.bst
- core-deps/virglrenderer.bst
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/libcap.bst
- freedesktop-sdk.bst:components/dummy-gbm.bst
- freedesktop-sdk.bst:components/pixman.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/sdl2.bst
- freedesktop-sdk.bst:components/sdl2-image.bst
- freedesktop-sdk.bst:components/systemd-libs.bst
- freedesktop-sdk.bst:bootstrap-import.bst

variables:
  (?):
  - arch == "x86_64":
      targets: --target-list=x86_64-softmmu,i386-softmmu
  - arch == "i686":
      targets: --target-list=x86_64-softmmu,i386-softmmu
  - arch == "aarch64":
      targets: --target-list=aarch64-softmmu,arm-softmmu
  - arch == "arm":
      targets: --target-list=arm-softmmu
  - arch == "ppc64le":
      targets: --target-list=ppc64-softmmu
  - arch == "riscv64":
      targets: --target-list=riscv64-softmmu

  conf-local: >-
    --disable-werror
    --enable-system
    --disable-user
    --enable-spice
    --enable-smartcard
    --enable-usb-redir
    --enable-gtk
    --enable-sdl
    --enable-sdl-image
    --enable-virglrenderer
    --enable-guest-agent

  # --exec-prefix --disable-static are not accepted
  conf-args: >-
    %{targets}
    --prefix="%{prefix}"
    --bindir="%{bindir}"
    --sbindir="%{sbindir}"
    --sysconfdir="%{sysconfdir}"
    --datadir="%{datadir}"
    --includedir="%{includedir}"
    --libdir="%{libdir}"
    --libexecdir="%{libexecdir}"
    --localstatedir="%{localstatedir}"
    --sharedstatedir="%{sharedstatedir}"
    --mandir="%{mandir}"
    --infodir="%{infodir}"
    --localstatedir=/
    --host=%{triplet}
    --build=%{triplet}
    %{conf-extra}
    %{conf-local}

config:
  install-commands:
    (>):
    - |
      install -Dm 644 -t %{install-root}%{sysconfdir}/qemu/ scripts/qemu-guest-agent/fsfreeze-hook
      install -Dm 644 -t "%{install-root}%{indep-libdir}/systemd/system" qemu-guest-agent.service
      install -Dm 644 qemu-guest-agent.udev %{install-root}%{indep-libdir}/udev/rules.d/60-qemu-guest-agent.rules

public:
  bst:
    split-rules:
      qemu-guest-agent:
      - '%{bindir}/qemu-ga'
      - '%{sysconfdir}'
      - '%{sysconfdir}/qemu'
      - '%{sysconfdir}/qemu/fsfreeze-hook'
      - '%{indep-libdir}/systemd'
      - '%{indep-libdir}/systemd/**'
      - '%{indep-libdir}/udev'
      - '%{indep-libdir}/udev/**'
      - '%{debugdir}%{bindir}/qemu-ga.*'
