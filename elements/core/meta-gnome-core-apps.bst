# This is derived from gnome-build-meta 48.3, ensure to update it when rebasing.

# The core set is not expected to change as frequently as core-deps.
# Adding or removing elements from here should be approved by
# release team. Review the technical conditions to enter GNOME core:
# https://gitlab.gnome.org/GNOME/gnome-build-meta/-/wikis/home#technical-conditions-to-enter-gnome-core
#
# Additional design team approval is required before adding or removing
# desktop applications from core. Current contact: Allan Day.
kind: stack
depends:
- gnome-build-meta.bst:core/baobab.bst
- gnome-build-meta.bst:core/decibels.bst
- gnome-build-meta.bst:core/epiphany.bst
- gnome-build-meta.bst:core/evince.bst
- gnome-build-meta.bst:core/gnome-calculator.bst
- gnome-build-meta.bst:core/gnome-calendar.bst
- gnome-build-meta.bst:core/gnome-characters.bst
- gnome-build-meta.bst:core/gnome-clocks.bst
- gnome-build-meta.bst:core/gnome-connections.bst
- gnome-build-meta.bst:core/gnome-console.bst
- gnome-build-meta.bst:core/gnome-contacts.bst
- gnome-build-meta.bst:core/gnome-disk-utility.bst
- gnome-build-meta.bst:core/gnome-font-viewer.bst
- gnome-build-meta.bst:core/gnome-logs.bst
- gnome-build-meta.bst:core/gnome-maps.bst
- gnome-build-meta.bst:core/gnome-music.bst
- gnome-build-meta.bst:core/gnome-software.bst
- gnome-build-meta.bst:core/gnome-system-monitor.bst
- gnome-build-meta.bst:core/gnome-text-editor.bst
- gnome-build-meta.bst:core/gnome-weather.bst
- gnome-build-meta.bst:core/loupe.bst
- gnome-build-meta.bst:core/nautilus.bst
- gnome-build-meta.bst:core/simple-scan.bst
- gnome-build-meta.bst:core/snapshot.bst
- gnome-build-meta.bst:core/totem.bst
- gnome-build-meta.bst:sdk/yelp.bst
