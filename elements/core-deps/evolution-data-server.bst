kind: cmake

sources:
- kind: tar
  url: gnome_downloads:evolution-data-server/3.56/evolution-data-server-3.56.0.tar.xz
  ref: 7ae5482aa4ee2894467716c5be982500e1d511dddf4ab29b68fdb107d7f8a8ff
build-depends:
- sdk/vala.bst
- freedesktop-sdk.bst:components/gperf.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst

depends:
- core-deps/gnome-online-accounts.bst
- core-deps/libcanberra.bst
- core-deps/libgweather.bst
- core-deps/openldap.bst
- sdk/gcr.bst
- sdk/gtk.bst
- sdk/libsecret.bst
- sdk/libsoup.bst
- sdk/webkitgtk-6.0.bst
- freedesktop-sdk.bst:components/libical.bst
- freedesktop-sdk.bst:components/nspr.bst
- freedesktop-sdk.bst:components/nss.bst
- freedesktop-sdk.bst:bootstrap-import.bst

variables:
  cmake-local: >-
    -DLIB_INSTALL_DIR=%{libdir}
    -DSYSCONF_INSTALL_DIR=%{sysconfdir}
    -DENABLE_GTK=OFF
    -DENABLE_GTK4=ON
    -DENABLE_INTROSPECTION=ON
    -DENABLE_VALA_BINDINGS=ON
    -DENABLE_UOA=OFF
    -DENABLE_GOOGLE_AUTH=OFF
    -DWITH_GWEATHER4=ON
    -DWITH_LIBDB=OFF
    -DENABLE_GOOGLE=OFF
