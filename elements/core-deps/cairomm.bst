kind: meson

sources:
# We need to use git_repo rather than a tarball because cairographics.org is unreliable.
# https://gitlab.freedesktop.org/freedesktop/freedesktop/-/issues/1184
- kind: tar
  url: cairo:releases/cairomm-1.18.0.tar.xz
  ref: b81255394e3ea8e8aa887276d22afa8985fc8daef60692eb2407d23049f03cfb
build-depends:
- core-deps/graphviz.bst
- core-deps/mm-common.bst
- freedesktop-sdk.bst:components/doxygen.bst
- freedesktop-sdk.bst:components/libxslt.bst
- freedesktop-sdk.bst:components/perl.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- core-deps/libsigcplusplus.bst
- freedesktop-sdk.bst:components/cairo.bst
- freedesktop-sdk.bst:bootstrap-import.bst

variables:
  meson-local: >-
    -Dmaintainer-mode=true
    -Dbuild-documentation=true
    -Dwarnings=min
