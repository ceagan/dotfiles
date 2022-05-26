#!/bin/bash
#
# Installs/updates latest ekctl from github.
#

set -e

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C "${HOME}/.local/bin"
