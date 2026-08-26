kind: manual
description: |
  Configuration for systemd-oomd service.

  We disable systemd-oomd in Endless OS 7, as it was not enabled in EOS6 either.

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-make.bst

config:
  install-commands:
  - |
    install -Dm 644 \
        -t "%{install-root}%{indep-libdir}/systemd/system-preset" \
        oomd.preset

sources:
- kind: local
  path: files/systemd-oomd
