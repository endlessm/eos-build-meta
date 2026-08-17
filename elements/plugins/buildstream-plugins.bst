# utils/update-elements.sh: Derived from gnome-build-meta.bst 51.beta plugins/buildstream-plugins.bst

kind: junction
description: |
  Borrowed so we can access it in project.conf, overridden for consistency.

sources:
- kind: tar
  url: pypi:a9/93/339aec1602d559d922f3dbdceb745562a33f6abb9a3037881ddabe905418/buildstream_plugins-2.7.0.tar.gz
  ref: 489e7915f93d3e6b233463552b6b33e47919a7e1be2afdf9efebece7d336c201
