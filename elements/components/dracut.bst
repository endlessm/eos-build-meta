# Taken from Freedesktop SDK 25.08. Remove this when
# we update the freedesktop-sdk and GNOME OS base versions

kind: autotools

build-depends:
- freedesktop-sdk.bst:components/pkg-config.bst
- freedesktop-sdk.bst:components/asciidoctor.bst
- freedesktop-sdk.bst:components/libxslt.bst
- freedesktop-sdk.bst:components/docbook-xsl.bst
- freedesktop-sdk.bst:components/systemd.bst

depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/kmod.bst
- freedesktop-sdk.bst:components/e2fsprogs.bst

runtime-depends:
- freedesktop-sdk.bst:components/cpio.bst

variables:
  # This project documents it doesn't support build-dir
  build-dir: ''
  lib: 'lib'

sources:
- kind: git_repo
  url: github:dracut-ng/dracut-ng.git
  track: '[0-9]*'
  ref: 108-0-g97c5568ec42abd5e6035f0cfa9d319ae6ae4e50a
