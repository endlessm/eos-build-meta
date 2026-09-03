# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.beta sdk/webkitgtk-6.0.bst

kind: cmake
description: |
  Overridden for building locally to avoid OOM issue when build.

  WebKit JavaScriptCore "unified source bundle" — WebKit's CMake build merges up
  to 8 source files per translation unit by default to speed up builds. b3 is
  JSC's B3 JIT backend, whose individual files are already heavy (deep template
  metaprogramming); bundling 8 of them into one clang++ -O2 -g invocation makes
  that one compile spike memory very briefly — fast enough that my polling never
  caught the spike, but big enough that something (very likely buildbox/recc's
  local resource guard rather than the kernel) kills it before it finishes.
  https://github.com/endlessm/eos-build-meta/issues/239

(@):
  - elements/components/webkitgtk.inc

depends:
  (>):
  - gnome-build-meta.bst:sdk/gtk.bst
  - gnome-build-meta.bst:sdk/libsoup.bst

variables:
  cmake-local: >-
    -DPORT=GTK
    -DENABLE_SPEECH_SYNTHESIS=OFF
    -DUSE_GTK4=ON
    -DUSE_LIBBACKTRACE=OFF
    -DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON
    -DWEBKIT_MAX_BUNDLE_SIZE=4

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libjavascriptcoregtk-6.0.so'
        - '%{libdir}/libwebkitgtk-6.0.so'
      webkit-debug:
      - '%{debugdir}'
      - '%{debugdir}/**'
