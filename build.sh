#!/bin/bash

if [ -d include/config ]; then
    echo "Find config,will remove it"
    rm -rf include/config
else
    echo "No Config,good."
fi

DIR=$(pwd)
OUT_DIR=$DIR/out

if [ ! -d $DIR/prebuilts/proton-clang ]; then
    echo 'clone Clang Prebuilt'
    git clone https://github.com/kdrag0n/proton-clang.git $DIR/prebuilts/proton-clang
fi

if [ ! -d $DIR/prebuilts/gcc ]; then
    echo 'clone prebuilt gcc arm'
    git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9.git $DIR/prebuilts/gcc
fi

if [ ! -d $DIR/prebuilts/gcc64 ]; then
 echo 'clone prebuilt gcc aarch64'
    git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git $DIR/prebuilts/gcc64
fi

export PATH=$DIR/prebuilts/proton-clang/bin:$PATH
export PATH=$DIR/prebuilts/gcc/bin:$PATH
export PATH=$DIR/prebuilts/gcc64/bin:$PATH

CLANG="$DIR/prebuilts/proton-clang/bin"
GCC="$DIR/prebuilts/gcc/bin"
GCC64="$DIR/prebuilts/gcc64/bin"

PATH="$CLANG:$GCC64:$GCC:$PATH" make O=out ARCH=arm64 a71_defconfig
PATH="$CLANG:$GCC64:$GCC:$PATH" make -j4 O=$OUT_DIR LTO=full ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androidebi-
