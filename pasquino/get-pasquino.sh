#!/bin/bash
pQnDir=/var/pasquino
if [ -d "$pQnDir" ]; then
	cd $pQnDir
    git pull
else
	mkdir -p $pQnDir
	cd $pQnDir
	git clone https://github.com/asivas/pasquino.git -b 1.7.x .
	./install.sh -y
fi