#!/bin/bash

# Set the destination folder
DEST="/usr/local/bin"

# Create the destination folder if it does not exist 
mkdir -p $DEST

# Copy the bump merge scripts to the destination directory
cp -f "./bump_merge.sh" $DEST
cp -f "./bump_merge_lfs.sh" $DEST

# Add the merge drivers to the Git config
git config --global merge.bump.name "Bump local copy to local_version folder, keep server copy"
git config --global merge.bump.driver "bump_merge.sh %O %A %B"

git config --global merge.bump-lfs.name "Bump local copy to local_version folder, keep server copy (LFS)"
git config --global merge.bump-lfs.driver "bump_merge_lfs.sh %O %A %B"
