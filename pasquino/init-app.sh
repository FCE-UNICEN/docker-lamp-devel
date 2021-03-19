#!/bin/bash
appDir=/var/www/app
appRemote=git@gitlab.com:asivas/asistencia-aladinuus.git
branch=ecuador/master

if [ -d "{$appDir}/.git" ]; then
	cd $appDir
	git pull
else
	mkdir -p $appDir
	cd $appDir
	#non emtpy dir pseudo clone
	git init
	git remote add origin $appRemote
	git fetch
	git reset $branch
	git checkout -t $branch
	#git clone $appRemote -b $branch .
fi

cd $appDir
composer update