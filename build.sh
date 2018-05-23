#!/bin/bash
PROJECT_NAME=DownloadCleaner
PROJECT_DIR=$(pwd)/$PROJECT_NAME
INFOPLIST_FILE="Info.plist"

CFBundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")

rm -rf build/*

xcodebuild clean -workspace $PROJECT_NAME.xcworkspace -configuration Release -scheme $PROJECT_NAME

xcodebuild archive -workspace $PROJECT_NAME.xcworkspace -scheme $PROJECT_NAME -archivePath build/$PROJECT_NAME.xcarchive

mkdir -p build/App
mv build/$PROJECT_NAME.xcarchive/Products/Applications/$PROJECT_NAME.app build/App/

echo "Runing pkgbuild. Note you must be connected to Internet for this to work as it"
echo "has to contact a time server in order to generate a trusted timestamp. See"
echo "man pkgbuild for more info under SIGNED PACKAGES."
pkgbuild --identifier "info.marcroberts.DownloadCleaner" \
    --component "build/App/$PROJECT_NAME.app" \
    --install-location /Applications \
    --version $CFBundleVersion \
    "build/$PROJECT_NAME.pkg"

ditto -c -k --sequesterRsrc --keepParent build/App/$PROJECT_NAME.app "build/$PROJECT_NAME.v${CFBundleVersion}.zip"
