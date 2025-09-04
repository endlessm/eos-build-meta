kind: manual

sources:
- kind: git_repo
  url: github:howbea/overview-background.git
  track: main
  ref: c073d208aba56d1bbb387d67cd14a8bde2c87266

depends:
- gnome-build-meta.bst:core/gnome-shell.bst

config:
  build-commands:
  - gnome-extensions pack overviewbackground\@github.com.orbitcorrection
  install-commands:
  - gnome-extensions install --force overviewbackground\@github.com.orbitcorrection.shell-extension.zip
  - mkdir -p %{install-root}/usr/share/gnome-shell/extensions/overviewbackground@github.com.orbitcorrection/
  - |
    cp -Rf \
      ~/.local/share/gnome-shell/extensions/overviewbackground@github.com.orbitcorrection \
      %{install-root}/usr/share/gnome-shell/extensions/
  - |
    mkdir -p %{install-root}/usr/share/glib-2.0/schemas
    cp overviewbackground@github.com.orbitcorrection/schemas/org.gnome.shell.extensions.ob.gschema.xml \
      %{install-root}/usr/share/glib-2.0/schemas/
