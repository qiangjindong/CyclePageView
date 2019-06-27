#!/bin/bash

VersionString=`grep -E 's.version.*=' CyclePageView.podspec`
temp=${VersionString#*=}
version=`tr -cd 0-9\. <<< "$temp"`
#VersionNumber=`tr -cd 0-9 <<<"$VersionString"`

#NewVersionNumber=$(($VersionNumber + 1))
#LineNumber=`grep -nE 's.version.*=' CMCtop_Category.podspec | cut -d : -f1`
#sed -i "" "${LineNumber}s/${VersionNumber}/${NewVersionNumber}/g" CMCtop_Category.podspec

echo "current version is ${version}, new version is ${version}"

git add .
git commit -m ${version}
git tag ${version}
git push origin master --tags
pod repo push CTSpec CyclePageView.podspec --verbose --allow-warnings --use-libraries --use-modular-headers --sources='http://172.19.3.125/changTuiOS/CTSpec.git,https://github.com/CocoaPods/Specs.git'

