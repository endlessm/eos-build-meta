kind: make

sources:
- kind: git_repo
  url: github:CleoMenezesJr/auto-activities.git
  track: main
  ref: 6fc9381841cac0edbef5b7f6192a765c9426e7aa

depends:
- gnome-build-meta.bst:core/gnome-shell.bst

config:
  install-commands:
    - |
      DESTDIR=%{install-root} %{make-install}
    - |
      mkdir -p %{install-root}/usr/share/glib-2.0/schemas
      cp schemas/org.gnome.shell.extensions.auto-activities.gschema.xml \
        %{install-root}/usr/share/glib-2.0/schemas/
