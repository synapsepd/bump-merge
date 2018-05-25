#!/bin/bash

EXT=$1
URL=$2

rm -rf A
rm -rf B

git clone $URL "A"
git clone $URL "B"

cd ./A
mkdir -p ./subdir
echo "Modified by A $(date)" > test.$EXT
echo "Test2: Modified by A  $(date)" > ./subdir/test2.$EXT
echo "Native A $(date)" > ./subdir/testA.$EXT
git add .
git commit -m "Modified by A $(date)"
git push

cd ..

cd ./B
mkdir -p ./subdir
echo "Modified by B $(date)" > test.$EXT
echo "Test2: Modified by B $(date)" > ./subdir/test2.$EXT
echo "Native B $(date)" > ./subdir/testB.$EXT
git add .
git commit -m "Modified by B $(date)"
# echo "Local file not committed by B $(date)" > test.$EXT
git pull
