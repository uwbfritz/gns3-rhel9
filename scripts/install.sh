#!/usr/bin/env bash

INSTALL_DIR="$HOME/install"

mkdir -p "$INSTALL_DIR"

curl -L https://github.com/uwbfritz/gns3-rhel9/archive/master.tar.gz | tar xz -C "$INSTALL_DIR" --strip-components=1

cd "$INSTALL_DIR" || exit 1

chmod +x -- *.sh

./rhel9-gns3-install.sh
