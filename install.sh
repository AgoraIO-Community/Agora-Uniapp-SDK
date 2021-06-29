zipName="AgoraRtcSDK"
temp="/var/tmp"
libs="ios/libs"

mkdir -p $temp

version=$(grep "version" package.json | grep -o '\d.\d.\d' | sed 's/\./_/g')
echo $zipName "$version"

if [ ! -f $temp/$zipName"$version".zip ]; then
  echo "the zip file not exists, start downloading..."
  curl -o $temp/$zipName"$version".zip "https://download.agora.io/sdk/release/Agora_Native_SDK_for_iOS_v${version}_FULL.zip"
fi

echo "start unzip SDK..."
unzip -o -q $temp/$zipName"$version".zip "**/*_Dynamic.zip" -d $temp/$zipName"$version"
if [ $? -ne 0 ]; then
  echo "unzip SDK failed, retry..."
  unzip -o -q $temp/$zipName"$version".zip "**/libs/*" -d $temp/$zipName"$version"
else
  echo "unzip SDK success, start unzip dynamic framework..."
  for zip in $(find $temp/$zipName"$version" -maxdepth 5 -iname '*_Dynamic.zip'); do
    unzip -o -q "$zip" "**/libs/*" -d $temp/$zipName"$version"
  done
fi

echo "start transfer dynamic framework to $libs..."
rm -rf $libs
mkdir -p $libs

for framework in $(find $temp/$zipName"$version" -maxdepth 3 -iname '*.xcframework'); do
  mv -f "$framework" $libs
done

echo "install finished"
