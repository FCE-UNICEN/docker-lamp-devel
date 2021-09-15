#!/bin/bash
[ -f ".env" ] && source .env

# if appDir was set on .env change dir to appDir otherwise
# we should be on $workdir set on Dockerfile
if [ -z "${appDir}" ]; then
	mkdir -p $appDir
	cd $appDir
fi

if [ -d ".git" ]; then
	git pull
else
  if [ -n "$appRemote" ]; then
    #non emtpy dir pseudo clone
    git init
    git remote add origin $appRemote
    git fetch
    git reset $branch
    git checkout -b $branch origin/$branch
	  #git clone $appRemote -b $branch .
	else
	    echo "No se encontró repositorio git definido"
	fi
fi

chmod a+w tmp/
composer update