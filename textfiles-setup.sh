#!/bin/bash
set -x

sudo loginctl enable-linger $USER
mkdir -p ~/textfiles/
mkdir -p ~/.config/systemd/user/
cp textfiles.service ~/.config/systemd/user/
systemctl --user enable textfiles

