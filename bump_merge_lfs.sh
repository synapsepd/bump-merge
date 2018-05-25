#!/bin/bash
# I want to keep the server's version when there is a conflict
# %O (the first parameter) contains the ancestor version (LFS hash file)
# %A (the second parameter) contains my "our" version (LFS hash file)
# %B (the third parameter) contains the server's "their" version (LFS hash file)
# We want to put our version in a local directory and keep the server's version
echo "Merging using bump_merge_lfs.sh"
#ls -la
#FILES=`find -not \( -path '*/local_version/*' -prune \) -not \( -path ./.git -prune \) -a -type f -print`

#echo "Ours"
SHA2=$(sed '2q;d' $2)
SHA2=$(echo $SHA2| cut -d':' -f 2)
#echo $SHA2

#echo "Theirs"
SHA3=$(sed '2q;d' $3)
SHA3=$(echo $SHA3| cut -d':' -f 2)
#echo $SHA3


# Get the name of the current branch
BRANCH=`git rev-parse --abbrev-ref HEAD`
#echo "BRANCH = $BRANCH"

# Get a list of the files in conflict
FILES=`git diff --name-only origin/$BRANCH`
#echo "FILES = $FILES"

# Find the local version of this particular file and move it to a local version folder
LOCALDIR=local_version
for f in $FILES
do
    if [ -f $f ]
    then
        NAME=$(basename $f)
        DIRNAME=$(dirname $f)
        #echo "NAME = $NAME"
		SHA_LOCAL=$(sha256sum $f)
		SHA_LOCAL=$(echo $SHA_LOCAL| cut -d' ' -f 1)
		#echo $SHA_LOCAL
        #echo "DIRNAME = $DIRNAME"
        #echo "PATH = $DIRNAME/$LOCALDIR"
        if [ "$SHA_LOCAL" == "$SHA2" ]
		then
			#echo "files are identical"
			#stat $f
			echo "----------------------------------------------"
			echo "Saving $f to local_version"
			echo "----------------------------------------------"
			mkdir -p $DIRNAME/$LOCALDIR
			cp -f $DIRNAME/$NAME $DIRNAME/$LOCALDIR/$NAME
		fi
    fi
done

# Use the incoming file in the working directory
cp -f $3 $2
exit 0