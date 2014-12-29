#!/bin/sh

PWD=$(cd "$(dirname "$0")"; pwd)
VERSION=`cat manifest.json | jq .version | tr -d [\"]`

APP=app-ssh-reverse


tar -cvzf ../$APP.$VERSION.tar.gz . --exclude '.git' --exclude "publish.sh" --exclude "*.mpk"

mv -f ../$APP.$VERSION.tar.gz $APP.$VERSION.mpk
