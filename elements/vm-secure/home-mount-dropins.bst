kind: import

sources:
- kind: local
  path: files/home-mount-dropins/90-compress-zstd.conf

config:
    target: /usr/lib/systemd/system/home.mount.d
