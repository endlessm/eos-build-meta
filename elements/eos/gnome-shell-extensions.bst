kind: manual

depends:
- eos/gnome-shell-ext-auto-activities.bst
- eos/gnome-shell-ext-dash-to-dock.bst
- eos/gnome-shell-ext-just-perfection.bst
- eos/gnome-shell-ext-overlay-application-view.bst
- eos/gnome-shell-ext-overview-background.bst

config:
  install-commands:
    - mkdir -p %{install-root}/usr/share/gnome-shell/modes
    - |
      cat <<EOF > %{install-root}/usr/share/gnome-shell/modes/endless.json
      {
          "parentMode": "user",
          "enabledExtensions": [
            "auto-activities@CleoMenezesJr.github.io",
            "dash-to-dock@micxgx.gmail.com",
            "just-perfection-desktop@just-perfection",
            "start-overlay-in-application-view@Hex_cz",
            "overviewbackground@github.com.orbitcorrection"
          ]
      }
      EOF
