kind: import

sources:
- kind: local
  path: files/root-mount-dropins/90-compress-zstd.conf

config:
    target: /usr/lib/systemd/system/-.mount.d
