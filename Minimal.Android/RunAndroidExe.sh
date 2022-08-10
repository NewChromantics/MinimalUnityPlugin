#!/bin/sh

# abort on any command error
set -e

TARGET_NAME=Minimal

if [ "$TARGET_NAME" == "" ]; then
	echo "RunAndroidExe.sh: No TARGET_NAME specified"
	exit 1;
fi

function InstallAndRunTestExecutable()
{
	ABI=$1
	EXE=CRStreamerTestApp
	
	echo "Displaying exe dependencies"
	objdump -p ./$TARGET_NAME.Android/libs/$ABI/$EXE|grep NEEDED

	echo "Displaying crstreamer dependencies"
	objdump -p ./$TARGET_NAME.Android/libs/$ABI/CRStreamer.so|grep NEEDED

	echo "Push files to device..."
	adb push ./$TARGET_NAME.Android/libs/$ABI/* /data/local/tmp
	echo "Run exe..."
	adb shell "cd /data/local/tmp && chmod +x ./$EXE && ./$EXE --capturestderr=false"
	
	RESULT=$?
	if [[ $RESULT -ne 0 ]]; then
		exit $RESULT
	fi
}

# auto detect ABI
if [ $# -eq 0 ]; then
	echo "Detecting abi..."
	abi=$(adb shell getprop ro.product.cpu.abi)
	echo "Detected ABI = $abi"
	InstallAndRunTestExecutable $abi
else
	InstallAndRunTestExecutable $1
fi

