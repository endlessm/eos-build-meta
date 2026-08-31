# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 components/cups-daemon-only.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: filter
description: |
  Overridden to exclude the cups-license split domain, which is already
  provided by cups.bst (a runtime-dependency of this element). Both
  elements filter the underlying cups-base.bst build, which is itself
  overridden locally to live in the endlessos project; its
  overlap-whitelist no longer matches the actual license path, so
  keeping the domain in both elements causes a non-whitelisted overlap
  for any element depending on both cups.bst and cups-daemon-only.bst.

build-depends:
- freedesktop-sdk.bst:components/_private/cups-base.bst

runtime-depends:
- freedesktop-sdk.bst:components/cups.bst

config:
  exclude:
  - cups-libs
  - cups-license
  include-orphans: True

public:
  bst:
    overlap-whitelist:
    - "%{project_licensedir}/cups"
    - "%{project_licensedir}/cups/**"
