#!/bin/bash
set -ex

zipName="AgoraRtcSDK"
temp="/var/tmp"
libs="ios/libs"

mkdir -p $temp

version=$(grep \"version\" package.json | grep -Eo '\d+.\d+.\d+(-rc.\d+)?' | sed 's/-rc//g')
url="$1"
echo $zipName "$version"

if [ ! -f $temp/$zipName"$version".zip ]; then
  echo "the zip file not exists, start downloading..."
  curl -o $temp/$zipName"$version".zip "${url:=https://download.agora.io/sdk/release/AgoraRtcEngine_iOS-${version}.zip}"
fi

echo "start unzip SDK..."
unzip -o -q $temp/$zipName"$version".zip -d $temp/$zipName"$version"
sh to-framework.sh $temp/$zipName"$version"/

echo "start transfer dynamic framework to $libs..."
rm -rf $libs
mkdir -p $libs

cp -rp $temp/$zipName"$version"/ALL_ARCHITECTURE/ $libs/

echo "install finished"
