kind: meson
sources:
- kind: tar
  url: gnome_downloads:localsearch/3.9/localsearch-3.9.0.tar.xz
  ref: d42f408dc3fb28fe54f5a9abbf5f1decf5818db9c2e9ec51c09464bdfd0c14b9
build-depends:
- freedesktop-sdk.bst:components/asciidoc.bst
- freedesktop-sdk.bst:components/docbook-xsl.bst
- freedesktop-sdk.bst:components/libxslt.bst
- freedesktop-sdk.bst:components/systemd.bst
- freedesktop-sdk.bst:components/ffmpeg.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
depends:
- core-deps/NetworkManager.bst
- core-deps/dconf.bst
- core-deps/exempi.bst
- core-deps/gexiv2.bst
- core-deps/libcue.bst
- core-deps/libgsf.bst
- core-deps/libgxps.bst
- core-deps/libosinfo.bst
- core-deps/totem-pl-parser.bst
- core-deps/upower.bst
- sdk/gdk-pixbuf.bst
- sdk/glib.bst
- sdk/libsecret.bst
- sdk/tinysparql.bst
- freedesktop-sdk.bst:components/gstreamer.bst
- freedesktop-sdk.bst:components/libexif.bst
- freedesktop-sdk.bst:components/libflac.bst
- freedesktop-sdk.bst:components/libseccomp.bst
- freedesktop-sdk.bst:components/openjpeg.bst
- freedesktop-sdk.bst:components/poppler.bst
- freedesktop-sdk.bst:bootstrap-import.bst
variables:
  meson-local: >-
    -Diptc=disabled
