#!/bin/bash
set -e
. setdevkitpath.sh
export FREETYPE_DIR=`pwd`/freetype-2.6.2/build_android-${TARGET_SHORT}
export CUPS_DIR=`pwd`/cups-2.2.4

# simplest to force headless:)
export CPPFLAGS+="-I$FREETYPE_DIR -I$CUPS_DIR -DHEADLESS"

cp -R /usr/include/X11 $ANDROID_INCLUDE/
# It isn't good, but need make it build anyways
cp -R $CUPS_DIR/* $ANDROID_INCLUDE/

sudo apt -y install gcc-multilib g++-multilib libxtst-dev libasound2-dev libelf-dev libx11-dev

cd openjdk
rm -rf build
bash ./configure \
	--with-extra-cflags="$CPPFLAGS" \
	--enable-headless-only \
	--enable-option-checking=fatal \
	--openjdk-target=$TARGET \
	--disable-warnings-as-errors \
	--with-jdk-variant=normal \
	--with-cups-include=$CUPS_DIR \
	--with-devkit=$ANDROID_DEVKIT \
	--with-debug-level=release \
	--with-freetype-lib=$FREETYPE_DIR/lib \
	--with-freetype-include=$FREETYPE_DIR/include/freetype2 \
    --x-includes=/usr/include \
    --x-libraries=/usr/lib \
   || error_code=$?
if [ "$error_code" -ne 0 ]; then
  echo "\n\nCONFIGURE ERROR $error_code , config.log:"
  cat config.log
  exit $error_code
fi

mkdir -p build/android-${TARGET_JDK}-normal-server-release
cd build/android-${TARGET_JDK}-normal-server-release
make JOBS=4 images
