#!/bin/bash

set -e

RELPODMANPATH=.local/src/podman
export PODMANPATH=${HOME}/${RELPODMANPATH}
if [[ -d ${PODMANPATH} ]]; then
    cd "${PODMANPATH}"
    CURRENT_VERSION=$(git describe --tags)
    git checkout main
    git pull
else
    git clone https://github.com/containers/podman "${PODMANPATH}"
    cd "${PODMANPATH}"
fi

# trunk-ignore(shellcheck/SC2312)
LATEST_VERSION=$(git tag --list --sort=-version:refname | grep -e '^v[0-9\.]*$' | head -n 1)

if [[ ${CURRENT_VERSION} != "${LATEST_VERSION}" ]]; then
    if [[ -n ${CURRENT_VERSION} ]]; then
        echo "Uninstalling the current podman installation..."
        git checkout "${CURRENT_VERSION}"
        make uninstall PREFIX="${HOME}/.local"
    fi

    echo "Checking out and building release ${LATEST_VERSION}..."
    git checkout "${LATEST_VERSION}"

    make BUILDTAGS="selinux seccomp"
    make install PREFIX="${HOME}/.local"
else
    echo "You are already on the lastest release."
    git checkout "${CURRENT_VERSION}"
fi
