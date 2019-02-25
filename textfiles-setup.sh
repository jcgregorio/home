#!/bin/bash
set -x

go get -u github.com/googlecloudplatform/gcsfuse
cp $GOPATH/bin/gcsfuse $HOME/bin/
sudo loginctl enable-linger $USER
mkdir -p ~/textfiles/
mkdir -p ~/.config/systemd/user/
cp textfiles.service ~/.config/systemd/user/
systemctl --user enable textfiles
