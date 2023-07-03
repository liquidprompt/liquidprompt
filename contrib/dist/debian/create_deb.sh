#!/bin/sh

echo "Creating Debian's package..."
nano ./liquidprompt/DEBIAN/control

echo "Generating default config file"
cd ../../..
./tools/config-from-doc.sh > liquidpromptrc-dist
cd contrib/dist/debian/

echo "Copying files..."
mkdir -p ./liquidprompt/usr/bin/
cp ../../../liquidprompt ./liquidprompt/usr/bin/liquidprompt
mkdir -p ./liquidprompt/etc/
cp ../../../liquidpromptrc-dist ./liquidprompt/etc/liquidpromptrc
chmod a+x ./liquidprompt/usr/bin/liquidprompt

echo "Building liquidprompt.deb..."
dpkg-deb -b liquidprompt

echo "Deleting files..."
rm -f ./liquidprompt/etc/*
rm -f ./liquidprompt/usr/bin/*

echo "Done !"
