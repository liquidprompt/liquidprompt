#!/bin/sh

echo "Creating Debian's package..."
nano ./liquidprompt/DEBIAN/control

echo "Copying files..."
cp ../../liquidprompt ./liquidprompt/usr/bin/liquidprompt
cp ../../liquidpromptrc-dist ./liquidprompt/etc/liquidpromptrc
chmod a+x ./liquidprompt/usr/bin/liquidprompt

echo "Building liquidprompt.deb..."
dpkg-deb -b liquidprompt

echo "Deleting files..."
rm -f ./liquidprompt/etc/*
rm -f ./liquidprompt/usr/bin/*

echo "Done !"
