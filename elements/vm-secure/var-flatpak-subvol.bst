kind: manual

depends:
- filename: freedesktop-sdk.bst:components/systemd.bst

config:
  install-commands:
  - |
    mkdir -p "%{install-root}%{indep-libdir}/systemd/system/"
    install -m 644 -t "%{install-root}%{indep-libdir}/systemd/system/" var-lib-flatpak.mount

    mkdir -p "%{install-root}%{indep-libdir}/tmpfiles.d/"
    install -m 644 -t "%{install-root}%{indep-libdir}/tmpfiles.d/" flatpak-subvolume.conf

sources:
- kind: local
  path: files/var-flatpak-subvol/var-lib-flatpak.mount
- kind: local
  path: files/var-flatpak-subvol/flatpak-subvolume.conf

