kind: manual
description: |
  Compatibility symlink for the `update-ca-certificates` program.

  Freedesktop SDK includes the Red Hat CA certificates package which is
  updated via `update-ca-trust`.

  EOS6 included the Debian CA certificates package which is updated via
  `update-ca-certificates`.

  The eos-safe-defaults program and maybe other things assume they can run
  `update-ca-certificates`, we add a compatibility symlink so this keeps
  working.

build-depends:
  - freedesktop-sdk.bst:public-stacks/buildsystem-make.bst

config:
  install-commands:
    - |
      mkdir -p %{install-root}/usr/bin/
      ln -sf /usr/bin/update-ca-trust %{install-root}/usr/bin/update-ca-certificates
