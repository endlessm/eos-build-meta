# utils/update-elements.sh: Derived from freedesktop-sdk.bst freedesktop-sdk-26.08beta.3 vm/minimal-ostree/repo.bst
# SPDX-FileCopyrightText: Freedesktop-SDK Developers
# SPDX-License-Identifier: MIT

kind: script
description: |
  Prepare the filesystem trees and convert them to OSTree commits.

  The output artifact contains a `ostree/repo` directory which is an OSTree
  repo in `archive` format, with commits for each published tree.

  The element diverged significantly from the one we derived it from, so it may
  not make sense to include further changes from the source element, include
  them at your discretion.

build-depends:
- freedesktop-sdk.bst:components/fakecap.bst
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:vm/deploy-tools.bst
- freedesktop-sdk.bst:vm/prepare-image.bst
- components/linux.bst
- eos/initial-scripts.bst
- eos/systemd-sysusers-override.bst
- filename: eos/filesystem.bst
  config:
    location: '/sysroot-eos'
- filename: eosdev/filesystem.bst
  config:
    location: '/sysroot-eosdev'

environment:
  OSTREE_REPO: "%{install-root}/ostree/repo"
  LD_PRELOAD: /usr/libexec/fakecap/fakecap.so
  FAKECAP_DB: /fakecap
  (?):
    - enable_eosdev == true:
        ENABLE_EOSDEV: "true"
    - enable_eosdev == false:
        ENABLE_EOSDEV: "false"

variables:
  uuidnamespace: 731a6fa6-5071-4d7b-8e0d-b81a66a590bc
  eos-branch: "os/eos/amd64/master"
  eosdev-branch: "os/eosdev/amd64/master"

config:
  commands:
  - mkdir -p /tmp
  - mkdir -p /efi
  - mkdir -p /fakecap

  # Prepare the filesystem tree, which includes:
  #
  #   * Running the scripts in `/etc/fdsdk/initial_scripts` (see the
  #     initial-scripts.bst element)
  #   * Setting up files in `/etc`
  #   * Running `systemd-firstboot` and `systemctl preset-all` against the tree
  #   * Creating initial `/etc/fstab` with the root and boot partitions
  #
  #
  # The `--noboot` option means: "Don't auto-mount the ESP via /etc/fstab".
  #
  # Initial scripts include:
  #
  #   * Setting special permissions like setuid where needed
  #   * Installing kernel (from 'signed-kernel-*' element)
  #   * System users overrides (from 'systemd-sysusers-override.bst' element)
  #   * Creating an empty /etc/machine-id (from 'etc-machine-id.bst' element)

  - |
    prepare-image.sh \
       --sysroot /sysroot-eos \
       --seed "%{uuidnamespace}" \
       --rootsource /dev/gpt-auto-root \
       --noboot
    mv /sysroot-eos/etc /sysroot-eos/usr/etc
  - |
    prepare-image.sh \
       --sysroot /sysroot-eosdev \
       --seed "%{uuidnamespace}" \
       --rootsource /dev/gpt-auto-root \
       --noboot
    mv /sysroot-eosdev/etc /sysroot-eosdev/usr/etc

  - mkdir -p "${OSTREE_REPO}"
  - ostree init --repo="${OSTREE_REPO}" --mode=archive

  - ostree commit --branch=%{eos-branch} /sysroot-eos

  - |
    if [ "${ENABLE_EOSDEV}" == "true" ]; then
      ostree commit --branch=%{eosdev-branch} /sysroot-eosdev
    fi
