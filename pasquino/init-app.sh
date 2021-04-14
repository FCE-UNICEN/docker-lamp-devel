#!/bin/bash
appDir=/var/www/app
appRemote=git@gitlab.com:aladinus/aladinus_ecuador.git
branch=main

if [ -d "${appDir}/.git" ]; then
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
	git checkout -b $branch origin/$branch
	#git clone $appRemote -b $branch .
fi

cd $appDir
chmod a+w tmp/
composer update