kind: manual
description: |
  Parallel implementation of GZip.

  This is used in eos-image-builder.

sources:
- kind: git_repo
  url: github:madler/pigz
  track: v*

  ref: v2.8-0-gfe4894f57739e3039a2ffc2a2a360d35e19bacbe
build-depends:
- freedesktop-sdk.bst:bootstrap-import.bst

config:
  build-commands:
  - make

  install-commands:
  - install -D -m 755 pigz --target-directory %{install-root}%{bindir}
  - install -D -m 755 pigz.1 --target-directory %{install-root}%{mandir}/man1

  - ln -s pigz %{install-root}%{bindir}/unpigz
  - ln -s pigz.1 %{install-root}%{mandir}/man1/unpigz.1
