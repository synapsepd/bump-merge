# Installation
1. Copy `bump_merge.sh` to a folder in the system path
2. Run `merge_config.bat`to set the merge drivers in global `.gitconfig` file
3. Add `local_version/` to the `.gitignore` file of your repository
4. Add `* binary merge=bump` to the `.gitattributes` file in your repository

Remember, if you updated your path, you will need to restart the command prompt window

# How does it work?
Let's say you forgot to pull from GitLab before starting to edit local files. OK, you would never do that. Let's say some nefarious person decided to edit and commit a new version of a file that you are currently working on. In your innocence, you add your changes, commit them, and attempt to push them to the server. To your chagrin, you are presented with an error that says conflicts exist and you must pull before you can push! What did that person do?!?! What will happen to your files when you pull?!?! Will they be automatically merged? Will Git ask you to resolve the conflicts? Will your local copy be deleted and replaced with the server's copy? Sweat beads on your brow and you start making backups of all you files... but wait! Bump merge can help you!

If you have installed bump merge as described above, your files are always safe. You should not need to know any magical Git commands, make backups before doing anything, or worry about Git ending up in a conflicted state. When you confidently perform a Git pull, the following happens:
1. Git looks in the `.gitattributes` file to see if the file in conflict matches any of the patterns.
2. Git sees that the conflicting file matches the pattern, because `*` matches everything.
3. The entry in `.gitattributes` tells Git that this is a binary file, which is important so Git doesn't start changing line endings and other stuff that a conventional merge would want to do.
4. The entry also says to use the `bump` merge driver, but where is that?
5. The `.gitconfig` file has an entry that was created when you ran `merge_confg.bat` that tells Git to run `bump_merge.sh`.
6. Git finds `bump_merge.sh` because it is in your system path.
7. `bump_merge` is a bash script, but Git runs it with Git Bash on Windows.
8. When `bump_merge.sh` runs, it is passed temporary filenames that refer to the original (.merge_aXXXXX), local (.merge_bXXXXX), and incomming (.merge_cXXXXX) versions of the file to be merged.
9. One important piece of information that's missing is the actual name of the file! But we can figure that out.
10. `bump_merge.sh` calls `git diff` to get the names of all the files in conflict, and iterates over that list comparing them to the local version (.merge_bXXXXX). That is why it is important for all files using this driver to be marked as binary. If Git is allowed to change their line endings, the local file and local temporary file will not match when compared. No problem though, this driver is all about binary files that we don't want to try to merge by hand.
11. When the local version of the file is found, it is copied into a subdirectory called `local_version`.
12. Finally, the copy from the server is placed in your working directory.
13. All you need to do is open both files and decide which parts of which files you want to keep.
14. Add, commit, and push your changes as usual.
15. Adding `local_version/` to the `.gitignore` file in your repository keeps you from checking in your local copies.




