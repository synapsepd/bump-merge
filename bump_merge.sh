#!/bin/bash
# I want to keep the server's version when there is a conflict
# %O (the first parameter) contains the ancestor version
# %A (the second parameter) contains my "our" version
# %B (the third parameter) contains the server's "their" version
# We want to put our version in a local directory and keep the server's version
echo "Merging using bump_merge.sh"
#ls -la
#FILES=`find -not \( -path '*/local_version/*' -prune \) -not \( -path ./.git -prune \) -a -type f -print`

# Get the name of the current branch
BRANCH=`git rev-parse --abbrev-ref HEAD`
#echo $BRANCH

# Get a list of the files in conflict
FILES=`git diff --name-only origin/$BRANCH`

# Find the local version of this particular file and move it to a local version folder
LOCALDIR=local_version
for f in $FILES
do
    if [ -f $f ]
    then
        NAME=$(basename $f)
        DIRNAME=$(dirname $f)
        #echo $NAME
        #echo $DIRNAME
        #echo $DIRNAME/$LOCALDIR
        if [ "$2" != "$NAME" ]
        then
            #echo "Processing $f:"
            if cmp --silent $2 $f 
            then
                #echo "files are identical"
                #stat $f
                echo "----------------------------------------------"
                echo "Saving $f to local_version"
                echo "----------------------------------------------"
                mkdir -p $DIRNAME/$LOCALDIR
                cp -f $2 $DIRNAME/$LOCALDIR/$NAME
            fi
        fi
    fi
done

# Use the incoming file in the working directory
cp -f $3 $2
exit 0