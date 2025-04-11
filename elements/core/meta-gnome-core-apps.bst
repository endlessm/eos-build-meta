# The core set is not expected to change as frequently as core-deps.
# Adding or removing elements from here should be approved by
# release team. Review the technical conditions to enter GNOME core:
# https://gitlab.gnome.org/GNOME/gnome-build-meta/-/wikis/home#technical-conditions-to-enter-gnome-core
#
# Additional design team approval is required before adding or removing
# desktop applications from core. Current contact: Allan Day.
kind: stack
depends:
- core/baobab.bst
- core/evince.bst
- core/gnome-clocks.bst
- core/gnome-console.bst
- core/gnome-disk-utility.bst
- core/gnome-software.bst
- core/gnome-system-monitor.bst
- core/nautilus.bst
- core/simple-scan.bst
- sdk/yelp.bst
