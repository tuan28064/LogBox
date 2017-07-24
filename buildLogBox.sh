#!/bin/sh
#默认ARCH=Release
PROJECT_ROOT=$(dirname $0)
XBUILD="/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild"
PROJECT="$PROJECT_ROOT/LogBox.xcodeproj"
TARGET="LogBox"
PRODUCT="$PROJECT_ROOT/product"
ARCH="Release"

#libi386.a:
$XBUILD -project $PROJECT -target $TARGET -sdk iphonesimulator -configuration $ARCH clean build
if [[ $? -ne 0 ]]; then
    exit -1
fi

cp $PROJECT_ROOT/build/$ARCH-iphonesimulator/lib$TARGET.a "./lib_i386.a"

#libArmv7.a:
$XBUILD -project $PROJECT -target $TARGET -sdk iphoneos -arch armv7 -configuration $ARCH clean build
if [[ $? -ne 0 ]]; then
    exit -1
fi

cp $PROJECT_ROOT/build/$ARCH-iphoneos/lib$TARGET.a "./lib_armv7.a"

#libArm64.a:
$XBUILD -project $PROJECT -target $TARGET -sdk iphoneos -arch arm64 -configuration $ARCH clean build
if [[ $? -ne 0 ]]; then
    exit -1
fi

cp $PROJECT_ROOT/build/$ARCH-iphoneos/lib$TARGET.a "./lib_arm64.a"

#cp .a
rm -rf $PRODUCT
mkdir $PRODUCT

#libUniversal.a: libi386.a libArmv7.a libArm64.a
lipo -create "./lib_i386.a"  "./lib_armv7.a" "./lib_arm64.a" -output "${PRODUCT}/lib${TARGET}.a"
if [[ $? -ne 0 ]]; then
    exit -1
fi

#cp headers
mkdir $PRODUCT/include
find "./LogBox/" -iname "*.h" -exec cp {} "$PRODUCT/include" \;

#clean:
rm -f "./lib_i386.a"  "./lib_armv7.a"  "./lib_arm64.a"
rm -rf build

echo "Build done"
