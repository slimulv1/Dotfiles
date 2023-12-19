#!/bin/bash
cd ~/Downloads   # Let's not trash your home folder
git clone --recursive https://github.com/Aylur/ags.git
cd ags
npm install
meson setup build
meson install -C build   # When asked to use sudo, make sure you say yes
cd ~/Downloads
rm -rf ags/


