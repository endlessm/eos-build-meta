kind: script

build-depends:
- freedesktop-sdk.bst:components/jq.bst
- freedesktop-sdk.bst:vm/prepare-image.bst
- gnomeos/make-layer.bst
- gnomeos/initial-scripts.bst
- gnomeos/initial-scripts-devel.bst
- filename: gnomeos/filesystem.bst
  config:
    location: '/sysroot'
- filename: gnomeos/filesystem-devel.bst
  config:
    location: '/sysroot-devel'

variables:
  sysroot-seed: df2427db-01ec-4c99-96b1-be3edb3cd9f6
  repart-seed: 53752261-a988-42fb-a585-b35ae0ab2af4

config:
  commands:
  - |
    prepare-image.sh \
       --sysroot /sysroot \
       --initscripts /etc/fdsdk/initial_scripts \
       --seed "%{sysroot-seed}" \
       --rootsource /dev/gpt-auto-root \
       --rootfstype btrfs \
       --rootfsopts relatime \
       --noboot >/dev/null

  - |
    mkdir -p /sysroot/usr/share/factory
    mv -T /sysroot/etc /sysroot/usr/share/factory/etc

  - |
    prepare-image.sh \
       --sysroot /sysroot-devel \
       --initscripts /etc/fdsdk/initial_scripts-devel \
       --seed "%{sysroot-seed}" \
       --rootsource /dev/gpt-auto-root \
       --rootfstype btrfs \
       --rootfsopts relatime \
       --noboot >'%{install-root}/vars.txt'

  - |
    mkdir -p /sysroot-devel/usr/share/factory
    mv -T /sysroot-devel/etc /sysroot-devel/usr/share/factory/etc

  - |
    cat >/sysroot-devel/usr/lib/tmpfiles.d/extra-etc-devel.conf<<EOF
    f /etc/bash_completion.d/perf
    C /etc/containers
    f /etc/gitconfig
    f /etc/gprofng.rc
    C /etc/iproute2
    C /etc/libvirt
    f /etc/logrotate.d/libvirtd
    f /etc/logrotate.d/libvirtd.libxl
    f /etc/logrotate.d/libvirtd.lxc
    f /etc/logrotate.d/libvirtd.qemu
    C /etc/sasl2
    f /etc/slsh.rc
    EOF

  - |
    mkdir -p /sysroot-devel/usr/lib/extension-release.d
    case "%{branch}" in
      master)
        version_id=Nightly
        ;;
      *)
        version_id="%{branch}"
        ;;
    esac
    cat <<EOF >/sysroot-devel/usr/lib/extension-release.d/extension-release.devel_%{image-version}
    ID=org.gnome.os
    VERSION_ID=${version_id}
    SYSEXT_LEVEL=%{image-version}
    EOF

  - |
    mkdir -p /tmp/output
    make-layer /sysroot/usr /sysroot-devel/usr /tmp/output/usr

  - |
    mkdir -p /tmp/output/etc
    cp -T /sysroot-devel/usr/lib/os-release /tmp/output/etc/os-release

  - mkdir -p definitions
  - |
    cat <<EOF >definitions/10-devel.conf
    [Partition]
    Type=root
    Label=gnomeos_usr_dev_%A
    CopyFiles=/usr
    Minimize=best
    Format=squashfs
    SplitName=usr
    EOF

  - |
    mkdir -p /var/tmp

  - |
    SYSTEMD_LOG_LEVEL=debug \
      systemd-repart \
        --definitions=definitions \
        --empty=create \
        --size=auto \
        --dry-run=no \
        --discard=no \
        --offline=true \
        --no-pager \
        --split=true \
        --seed %{repart-seed} \
        --root=/tmp/output \
        devel.raw \
        --json=pretty \
        >repart.json

  - |
    install -Dm644 -t '%{install-root}' "devel.usr.raw"
