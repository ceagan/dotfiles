#!/bin/bash
#
# Installs/updates latest Golang from source code.
#

set -e

RELGOPATH=.local/src/go
export GOPATH=${HOME}/${RELGOPATH}
if [[ -d "${GOPATH}/src" ]]; then
    cd "${GOPATH}/src"
    CURRENT_VERSION=$(git describe --tags)
    git checkout master
    git pull
else
    git clone https://go.googlesource.com/go "${GOPATH}"
    cd "${GOPATH}/src"
fi

# trunk-ignore(shellcheck/SC2312)
LATEST_VERSION=$(git tag --list --sort=-version:refname | grep -e '^go[0-9\.]*$' | head -n 1)

if [[ ${CURRENT_VERSION} != "${LATEST_VERSION}" ]]; then
    echo "Checking out and building release ${LATEST_VERSION}..."
    git checkout "${LATEST_VERSION}"

    ./all.bash
else
    echo "You are already on the lastest release."
    git checkout "${CURRENT_VERSION}"
fi

# trunk-ignore(shellcheck/SC2016)
grep -qxF 'export PATH="${HOME}/'"${RELGOPATH}"'/bin:$PATH"' ~/.profile || echo 'export PATH="${HOME}/'"${RELGOPATH}"'/bin:$PATH"' >>~/.profile
