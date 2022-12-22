#!/bin/sh
cd /Volumes/workspace/repository/
pwd
git fetch --tags
NEW_VERSION=$(git describe --abbrev=0)
echo "Setting marketing version to $NEW_VERSION"
sed -ie "s/\(MARKETING_VERSION = \)[^;]*/\1$NEW_VERSION/" /Volumes/workspace/repository/eduID.xcodeproj/project.pbxproj

