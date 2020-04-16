#!/bin/bash

set -e

hdiutil attach /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport/12.1\ \(16B5059d\)/DeveloperDiskImage.dmg

cp /Volumes/DeveloperDiskImage/usr/bin/debugserver ./

lipo -thin arm64 debugserver  -output debugserver_arm64

if [[ -x "/usr/bin/debugserver" ]]; then
  set +e
  /usr/bin/debugserver > /dev/null 2>&1
  if [[ $? -ne 1 ]]; then
    rm -f /usr/bin/debugserver
  fi
  set -e
fi


if [[ ! -x "/usr/bin/debugserver" && -x "/Developer/usr/bin/debugserver" ]]; then
    cp /Developer/usr/bin/debugserver /private/var/tmp/debugserver
    ldid -S/usr/share/entitlements/debugserver.xml /private/var/tmp/debugserver
    mv /private/var/tmp/debugserver /usr/bin
fi
if [[ -x "/usr/bin/debugserver" ]]; then
    exec /usr/bin/debugserver "$@"
else
    echo "Please mount developer disk image"
fi