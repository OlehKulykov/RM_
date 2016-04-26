#!/bin/bash

rm -rf docs
mkdir docs
echo -e "*** Generating docs ***\n"
jazzy -g https://github.com/OlehKulykov/RM_ -m 'ReusableModules'

DESTINATION_NAME=("iPhone 5" "iPhone 6" "iPhone 6 Plus " "iPad 2" "iPad Retina" "iPad Air" "iPad Air 2" "iPad Pro")
DESTINATION_OS=("8.4" "9.0" "9.3")
TESTS_COUNT=$(( ${#DESTINATION_NAME[@]} * ${#DESTINATION_OS[@]} ))
TEST_NUMBER=1

for name in "${DESTINATION_NAME[@]}"
do

	for os in "${DESTINATION_OS[@]}"
	do
		echo START TEST $TEST_NUMBER/$TESTS_COUNT: $name, $os
		COMMAND="xcodebuild test -project RM_.xcodeproj -scheme RM_ -destination \"platform=iOS Simulator,name=$name,OS=$os\""
		echo $COMMAND
		eval $COMMAND
		TEST_NUMBER=$(( $TEST_NUMBER + 1 ))
	done


done
