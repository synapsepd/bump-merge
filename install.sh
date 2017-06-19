#!/bin/bash

# Set the destination folder
DEST="/usr/local/bin"

# Create the destination folder if it does not exist 
mkdir -p $DEST

# Copy the bump mege script to the destination directory
cp -f "./bump_merge.sh" $DEST

# Add the merge driver to the Git config
git config --global merge.bump.name "Bump local copy to local_version folder, keep server copy"
git config --global merge.bump.driver "bump_merge.sh %O %A %B"
