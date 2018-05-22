#!/bin/bash
PROJECT_NAME=DownloadCleaner
PROJECT_DIR=$(pwd)/$PROJECT_NAME
INFOPLIST_FILE="Info.plist"

CFBundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")

rm -rf Archive/*
rm -rf Product/*

xcodebuild clean -workspace $PROJECT_NAME.xcworkspace -configuration Release -scheme $PROJECT_NAME

xcodebuild archive -workspace $PROJECT_NAME.xcworkspace -scheme $PROJECT_NAME -archivePath Archive/$PROJECT_NAME.xcarchive

ditto -c -k --sequesterRsrc --keepParent Archive/$PROJECT_NAME.xcarchive/Products/Applications/$PROJECT_NAME.app "Product/$PROJECT_NAME.v${CFBundleVersion}.zip"
