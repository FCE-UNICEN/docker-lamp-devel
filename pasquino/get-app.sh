#!/bin/bash
appDir=/var/www/app
appRemote=git@gitlab.com:asivas/asistencia-aladinuus.git
branch=ecuador/master

if [ "$(ls -A $appDir)" ]; then
	cd $appDir
	git pull
else
	mkdir -p $appDir
	cd $appDir
	git clone appRemote -b devel .
fi