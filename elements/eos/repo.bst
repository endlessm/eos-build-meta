# Adapted from the Freedesktop SDK element `vm/minimal-ostree/repo.bst`
# from Freedesktop SDK 24.08.22.

kind: script
description: |
  Prepare the filesystem tree and convert it to OSTree commit.

  The output artifact contains a `ostree/repo` directory which is an OSTree
  repo in `archive` format with a single commit and a single branch.

build-depends:
- freedesktop-sdk.bst:components/ostree.bst
- freedesktop-sdk.bst:vm/deploy-tools.bst
- freedesktop-sdk.bst:vm/prepare-image.bst
- eos/initial-scripts.bst
- filename: eos/filesystem.bst
  config:
    location: '/sysroot'

variables:
  uuidnamespace: 731a6fa6-5071-4d7b-8e0d-b81a66a590bc
  ostree-branch: "eos-buildstream"

environment:
  OSTREE_REPO: "%{install-root}/ostree/repo"

config:

  commands:
  - mkdir -p /tmp
  - mkdir -p /efi

  # Prepare the filesystem tree, which includes:
  #
  #   * Running the scripts in `/etc/fdsdk/initial_scripts` (see the
  #     initial-scripts.bst element)
  #   * Setting up files in `/etc`
  #   * Runing `systemd-firstboot` and `systemctl preset-all` against the tree
  #   * Creating initial `/etc/fstab` with the root and boot partitions
  - |
    prepare-image.sh \
       --sysroot /sysroot \
       --seed "%{uuidnamespace}" \
       --rootsource /dev/gpt-auto-root \
       --efisource LABEL=EFI \
       --efipath /boot

  - mkdir -p "${OSTREE_REPO}"
  - ostree init --repo="${OSTREE_REPO}" --mode=archive
  - mv /sysroot/etc /sysroot/usr/etc
  - ostree commit --branch=%{ostree-branch} /sysroot
