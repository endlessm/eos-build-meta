# This is derived from gnome-build-meta 48.2, ensure to update it when rebasing.

kind: import

sources:
- kind: local
  path: files/boot-keys/import-pubring.gpg

runtime-depends:
- gnome-build-meta.bst:freedesktop-sdk.bst:components/systemd.bst

config:
  target: /usr/lib/systemd

public:
  bst:
    overlap-whitelist:
    - /usr/lib/systemd/import-pubring.gpg
