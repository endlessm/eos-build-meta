kind: autotools
description: |
  Endless OS Shell Content installation package.

  Contains the content for the app store, Image attributions & list of
  Kickstarter backers and Endless OS shell icon grid defaults.

sources:
- kind: git_repo
  url: github:endlessm/eos-shell-content.git
  ref: 9f4ab214b28814ce02db968732f880d632f4b7b4

build-depends:
- freedesktop-sdk.bst:components/perl.bst
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst
- gnome-build-meta.bst:sdk/glib.bst
- gnome-build-meta.bst:sdk/gtk.bst
- gnome-build-meta.bst:sdk/json-glib.bst

runtime-depends:
- gnome-build-meta.bst:core-deps/zenity.bst

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{bindir}/eos-content-merge'
        - '%{libdir}/python*/*-packages/eosshellcontent.py'
        - '%{datadir}/cdbs'
        - '%{datadir}/eos-shell-content/bundle'
        - '%{datadir}/eos-shell-content/content.json'
        - '%{datadir}/man'
        - '%{datadir}/perl5'
