#!/bin/bash

set -eu

args=()

while [ $# -gt 0 ]; do
    case "$1" in
        --same-version)
            same_version=1
            ;;
        --devel)
            devel=1
            ;;
        *)
            args+=("$1")
            ;;
    esac
    shift
done

if [ "${#args[@]}" -gt 0 ]; then
    echo "Parameter unexpected" 1>&2
    exit 1
fi

: ${BST:=bst}
: ${ARCH:="x86_64"}
: ${REPO_STATE:="${PWD}/secure-vm-repo"}
: ${PORT:=8080}

BST_OPTIONS=()

case "${ARCH}" in
    *)
        BST_OPTIONS+=(-o arch ${ARCH})
    ;;
esac

[ -d "${REPO_STATE}" ] || mkdir -p "${REPO_STATE}"

if [ "${same_version+set}" != set ]; then
    if [ -f "${REPO_STATE}/next_version" ]; then
        version="$(cat "${REPO_STATE}/next_version")"
    else
        version=1
    fi

    next_version="$((${version}+1))"

    sed -i "s/image-version: .*/image-version: 'l.${version}'/" include/image-version.yml
fi

cleanup_dirs=()
cleanup() {
    if [ "${#cleanup_dirs[@]}" -gt 0 ]; then
        rm -rf "${cleanup_dirs[@]}"
    fi
}
trap cleanup EXIT

checkout="$(mktemp -d --tmpdir="${REPO_STATE}" checkout.XXXXXXXXXX)"
cleanup_dirs+=("${checkout}")

if [ "${devel+set}" = set ]; then
    image=(gnomeos/update-images.bst)
else
    image=(gnomeos/update-images-user-only.bst)
fi

"${BST}" "${BST_OPTIONS[@]}" build "${image}"

"${BST}" "${BST_OPTIONS[@]}" artifact checkout "${image}" --directory "${checkout}"
gpg --homedir=files/boot-keys/private-key --output  "${checkout}/SHA256SUMS.gpg" --detach-sig "${checkout}/SHA256SUMS"

if [ "${next_version+set}" = set ]; then
    echo "${next_version}" >"${REPO_STATE}/next_version"
fi

if type -p caddy > /dev/null; then
    if caddy -version > /dev/null; then
        echo "Found caddy v1"
        caddy -port "${PORT}" -root "${checkout}"
    else
        echo "Found caddy v2"
        caddy file-server --listen ":${PORT}" --root "${checkout}"
    fi
elif type -p webfsd > /dev/null; then
    echo "Found webfsd"
    webfsd -F -l - -p "${PORT}" -r "${checkout}"
else
    echo "Running using python web server, please install caddy or webfs instead."
    python3 -m http.server "${PORT}" --directory "${checkout}"
fi
