#!/bin/bash

# Get Script Location
SCRIPT_HOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Install a dotfile by ensuring that the installed version includes the
# version in this repository by the specifed method.
#
# @param file to install
# @param install location
# @param include pattern
function install_by_include {
    echo -n "Installing ${1##*\/}... "
    if [[ -e "$2" ]]; then
        grep -q "$3 $1" $2
        if [[ $? -ne 0 ]]; then
            echo "$3 $1" >> $2
            echo "done."
        else
            echo "already installed."
        fi
    else
        echo "$3 $1" > $2
        echo "done."
    fi
}

# Install a dotfile by creating a link to the git repository. Replace existing
# symlinks with a new link, and backup existing dotfiles if they exist.
#
# @param file to install
# @param install location
function install_by_linking {
    echo -n "Installing ${1##*\/}... "
    if [[ -e "$2" ]]; then
        if [[ -h "$2" ]]; then
            echo -n "replacing existing symlink... "
            rm -rf "$2"
            echo "done."
            ln -s $1 $2
        else
            echo "backing up exsting dotfile and replacing with a symlink... "
            mv -f "$2" "$2.bak"
            echo "done."
            ln -s $1 $2
        fi
    else
        ln -s $1 $2
        echo "done."
    fi
}

install_by_include $SCRIPT_HOME/shell/profile $HOME/.profile source
install_by_linking $SCRIPT_HOME/vim/vimrc $HOME/.vimrc

