kind: filter

build-depends:
- core-deps/qemu-base.bst

runtime-depends:
- freedesktop-sdk.bst:components/glib.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:bootstrap-import.bst

config:
  include:
  - qemu-guest-agent
  include-orphans: False
