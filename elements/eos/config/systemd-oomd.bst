kind: manual
description: |
  Configuration for systemd-oomd service.

  We disable systemd-oomd in Endless OS 7, as it was not enabled in EOS6 either.

depends:
- freedesktop-sdk.bst:bootstrap-import.bst

config:
  install-commands:
  - |
    install -Dm 644 \
        -t "%{install-root}%{indep-libdir}/systemd/system-preset" \
        oomd.preset

sources:
- kind: local
  path: files/systemd-oomd
