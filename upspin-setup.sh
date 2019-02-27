#!/bin/bash
set -x

sudo loginctl enable-linger $USER
mkdir -p ~/up/
mkdir -p ~/.config/systemd/user/
cp upspin.service ~/.config/systemd/user/
systemctl --user enable upspin
