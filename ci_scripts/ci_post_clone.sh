#!/bin/sh

# Disable SPM built tool validation - it seems like the enabled flag is stored in the .xcodeproj file
# see: https://forums.swift.org/t/telling-xcode-14-beta-4-to-trust-build-tool-plugins-programatically/59305/4
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

cd /Volumes/workspace/repository/
pwd
git fetch --unshallow
git fetch --tags
NEW_VERSION=$(git describe --abbrev=0 --tags --always)
echo "Setting marketing version to $NEW_VERSION"
sed  -i "" -e "s/\(MARKETING_VERSION = \)[^;]*/\1$NEW_VERSION/" /Volumes/workspace/repository/eduID.xcodeproj/project.pbxproj

