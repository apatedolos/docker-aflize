#!/bin/bash

mkdir ~/src ~/go
cd ~/src
export CW_EXPLOITABLE=~/src/exploitable
git init
git remote add origin https://github.com/jfoote/exploitable.git
git fetch --depth=1 origin
git checkout -b master --track origin/master
cd ~/go
export GOPATH=~/go
go get -u github.com/bnagy/crashwalk/cmd/...
