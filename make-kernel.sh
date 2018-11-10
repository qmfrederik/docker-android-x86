#!/bin/sh

mkdir android-x86
cd android-x86

repo init -q -u git://git.osdn.net/gitroot/android-x86/manifest -b nougat-x86 --depth=1

repo sync --no-tags --no-clone-bundle kernel
repo sync --no-tags --no-clone-bundle device/generic/common device/generic/firmware device/generic/x86 device/generic/x86_64
repo sync --no-tags --no-clone-bundle frameworks/native
repo sync --no-tags --no-clone-bundle build build/kati
repo sync --no-tags --no-clone-bundle prebuilts/clang/host/linux-x86 prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.15-4.8 prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.11-4.6 prebuilts/sdk prebuilts/ninja/linux-x86 prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9
repo sync --no-tags --no-clone-bundle external/bison external/libcxx external/compiler-rt external/libcxxabi

cd kernel
git apply ../../patches/kernel.patch
cd ..

echo Now run 'make kernel TARGET_PRODUCT=android_x86_64'
