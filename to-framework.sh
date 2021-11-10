#!/bin/bash
echo "Start building framework..."

function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

AgoraIosFrameworkDir=$1
cd $AgoraIosFrameworkDir

if [ ! -d "libs" ]; then
    echo "SDK path error, please check!"
    exit 1
fi

cd libs/
iphoneOsArch="armv7_arm64"
sdk_ver=$(plutil -extract CFBundleShortVersionString xml1 -o - ./AgoraRtcKit.xcframework/ios-armv7_arm64/AgoraRtcKit.framework/Info.plist | sed -n "s/.*<string>\(.*\)<\/string>.*/\1/p")
echo "sdkver: $sdk_ver"
if [ "x$sdk_ver" = "x" ]; then
    sdk_ver=$(plutil -extract CFBundleShortVersionString xml1 -o - ./AgoraRtcKit.xcframework/ios-arm64_armv7/AgoraRtcKit.framework/Info.plist | sed -n "s/.*<string>\(.*\)<\/string>.*/\1/p")
    iphoneOsArch="arm64_armv7"
    echo "sdkver: $sdk_ver"
fi
min_support_ver=3.4.5
support_m1_sim=n
if version_ge $sdk_ver $min_support_ver; then
    support_m1_sim=y
    echo "SDK supports M1 simulator"
fi
cur_path=`pwd`
framework_suffix=".xcframework"
frameworks=""
for file in `ls $cur_path`; do
    echo $file
    if [[ $file == *$framework_suffix* ]]; then
        frameworks="$frameworks $file"
    fi
done

echo "Frameworks found:$frameworks"
mkdir ALL_ARCHITECTURE
for framework in $frameworks; do
    binary_name=${framework%.*}
    echo "framework_name is $binary_name"
    echo "iphoneOsArch: $iphoneOsArch"
    cp -rf $binary_name.xcframework/ios-$iphoneOsArch/$binary_name.framework ./
    cp -rf $binary_name.xcframework/ios-$iphoneOsArch/$binary_name.framework ALL_ARCHITECTURE/

    if [ "x$support_m1_sim" = "xy" ]; then
        if [ -d "$binary_name.xcframework/ios-arm64_x86_64-simulator" ];then
            lipo -remove arm64 $binary_name.xcframework/ios-arm64_x86_64-simulator/$binary_name.framework/$binary_name -output $binary_name.xcframework/ios-arm64_x86_64-simulator/$binary_name.framework/$binary_name
            lipo -create $binary_name.xcframework/ios-arm64_x86_64-simulator/$binary_name.framework/$binary_name ALL_ARCHITECTURE/$binary_name.framework/$binary_name -o ALL_ARCHITECTURE/$binary_name.framework/$binary_name
        else
            lipo -remove arm64 $binary_name.xcframework/ios-x86_64_arm64-simulator/$binary_name.framework/$binary_name -output $binary_name.xcframework/ios-x86_64_arm64-simulator/$binary_name.framework/$binary_name
            lipo -create $binary_name.xcframework/ios-x86_64_arm64-simulator/$binary_name.framework/$binary_name ALL_ARCHITECTURE/$binary_name.framework/$binary_name -o ALL_ARCHITECTURE/$binary_name.framework/$binary_name
        fi
    else
        lipo -create $binary_name.xcframework/ios-x86_64-simulator/$binary_name.framework/$binary_name ALL_ARCHITECTURE/$binary_name.framework/$binary_name -o ALL_ARCHITECTURE/$binary_name.framework/$binary_name
    fi

    rm -rf $binary_name.xcframework
done


echo "Build framework successfully."
