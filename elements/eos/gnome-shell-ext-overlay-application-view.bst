kind: manual

sources:
- kind: git_repo
  url: github:Hexcz/Start-Overlay-in-Application-View-for-Gnome-40-.git
  track: main
  ref: 544e1630556ab29f537c05bff765909b31f4b2eb

depends:
- gnome-build-meta.bst:core/gnome-shell.bst

config:
  build-commands:
  - gnome-extensions pack start-overlay-in-application-view\@Hex_cz
  install-commands:
  - gnome-extensions install --force start-overlay-in-application-view\@Hex_cz.shell-extension.zip
  - mkdir -p %{install-root}/usr/share/gnome-shell/extensions/start-overlay-in-application-view@Hex_cz/
  - |
    cp -Rf \
      ~/.local/share/gnome-shell/extensions/start-overlay-in-application-view@Hex_cz \
      %{install-root}/usr/share/gnome-shell/extensions/
