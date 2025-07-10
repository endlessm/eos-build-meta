# Endless OS Build Metadata

The content of this repository is a [BuildStream](https://www.buildstream.build/)
project.

## Updating the refs

To update the refs you can use Toolbox along with the script in `utils/update-refs.py` and
git push options to create a merge request.
```
$ toolbox create -i registry.gitlab.com/freedesktop-sdk/infrastructure/freedesktop-sdk-docker-images/bst2
$ toolbox run -c bst2 ./utils/update-refs.py --new-branch
$ git push -o merge_request.create -o merge_request.assign="marge-bot" -o merge_request.remove_source_branch -f origin -u HEAD
```

## Build outputs

Some of the possible build outputs are documented below.

### Endless OS

To build the GNOME OS "secure boot" image locally:

1. Generate keys:
```
$ make -C files/boot-keys clean
$ make -C files/boot-keys
```

2. Build the disk image (first command) or the ISO installer (second command):
```
$ bst build gnome-build-meta.bst:gnomeos/image.bst
$ bst build gnome-build-meta.bst:iso/image.bst
```

3. Checkout the image or installer:
```
$ bst artifact checkout gnome-build-meta.bst:gnomeos/image.bst --directory ./disk
$ bst artifact checkout gnome-build-meta.bst:iso/image.bst --directory ./iso
```

### OCI Images

OCI images are built and pushed to the container registry through the CI job
'deploy-oci'. Currently there are three images 'platform', 'sdk' and 'core':

1. platform - the same `/usr` tree as the `org.gnome.Platform` flatpak runtime

2. sdk - the same as the `org.gnome.Sdk` flatpak runtime and `toolbox` compatible

3. core - core devel OS tree including the dependencies to build all (most)
   of the 'core' elements in 'core.bst', but without the cli tools and
   utilities (podman, toolbox, bst, etc)

These images can be found in the container registry [quay.io](https://quay.io/repository/gnome_infrastructure/gnome-build-meta?tab=tags&tag=latest).

While they are "toolbox compatible", there isn't any update mechanism in them,
so you should be aware that the containers created locally for development will
become stale and you will need to remove and recreate them with an up to date
image often. Their main usecase is for gitlab-ci which always pulls the latest
image.
