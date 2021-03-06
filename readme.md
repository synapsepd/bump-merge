# What is bump-merge?
Bump-merge is a custom merge driver for Git to simplify workflows that deal with binary files. When you can't diff a file and choose between the different text options from each, you may be faced with choosing one file or the other. However, it is usually not that easy. Maybe two people made edits to a file on different branches or different machines and resolving the conflict requires opening both files and copying changes from one into the other. These could be schematic capture files, PCB layouts, text-based config files of an unknown format, images, etc. Stashing files doesn't help; because, when you pop the stash, it still requires a merge. You can't save only the server version, nor can you save only the local version. So, you may start copying files out of your local directory and cleaning up the working copy to access both versions of the file on your local machine.

Bump-merge solves that problem for you. When you pull from a remote, and there are file conflicts in your local repository, bump-merge copies your local copy to a subdirectory called `local_version` and places the remote version in your working directory. Git is happy that the merge succeeded, and you have access to both files to resolve the conflict in the appropriate editor. Just open both versions, copy changes from the local version into the working copy and `add`, `commit`, and `push`.

# How do I install it?
## Windows
1. Clone or download the repository
2. Right click `install.bat` and select `Run as administrator`
3. Add `local_version/` to the `.gitignore` file of your repository
4. For binary files: Add `*.bin binary merge=bump` to the `.gitattributes` file in your repository  
    (Replace .bin with your binary extension)
5. For LFS files: Add `*.bin filter=lfs diff=lfs merge=bump-lfs -text` to the `.gitattributes` file in your repository  
    (Replace .bin with your binary extension)
6. Restart any command windows to enable the new PATH environment variable

## Linux/Mac
1. Clone or download the repository
2. Change to the installation directory
3. Run `$ sudo ./install.sh`
4. Add `local_version/` to the `.gitignore` file of your repository
5. For binary files: Add `*.bin binary merge=bump` to the `.gitattributes` file in your repository  
    (Replace .bin with your binary extension)
6. For LFS files: Add `*.bin filter=lfs diff=lfs merge=bump-lfs -text` to the `.gitattributes` file in your repository  
    (Replace .bin with your binary extension)

# How does it work?
Let's say you forgot to pull from GitLab before starting to edit local files. OK, you would never do that. Let's say some nefarious person decided to edit and commit a new version of a file that you are currently working on. In your innocence, you add your changes, commit them, and attempt to push them to the server. To your chagrin, you are presented with an error that says conflicts exist and you must pull before you can push! What did that person do?!?! What will happen to your files when you pull?!?! Will they be automatically merged? Will Git ask you to resolve the conflicts? Will your local copy be deleted and replaced with the server's copy? Sweat beads on your brow and you start making backups of all you files... but wait! Bump merge can help you!

If you have installed bump merge as described above, your files are always safe. You should not need to know any magical Git commands, make backups before doing anything, or worry about Git ending up in a conflicted state. When you confidently perform a Git pull, the following happens:
1. Git looks in the `.gitattributes` file to see if the file in conflict matches any of the patterns.
2. Git sees that the conflicting file matches the pattern, because `*` matches everything.
3. The entry in `.gitattributes` tells Git that this is a binary file, which is important so Git doesn't start changing line endings and other stuff that a conventional merge would want to do.
4. The entry also says to use the `bump` merge driver, but where is that?
5. The `.gitconfig` file has an entry that was created when you ran the installation script that tells Git to run `bump_merge.sh`.
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

# Try it before you buy it!
After installing bump-merge you can test it out on a test repository using the `create_conflict.sh` script.
1. Create a remote repository
2. Add the following to the repository's `.gitattributes` file
~~~~
*.bin binary merge=bump
*.lfs filter=lfs diff=lfs merge=bump-lfs -text
~~~~
3. Add the following to the repository's `.gitignore` file
~~~~
local_version/
~~~~
4. Open a bash shell (Git Bash on Windows)
5. Copy `create_conflict.sh` to the location you want to perform the test
6. Copy the repository's URL
7. Test the `bump` driver using the command
~~~~
./create_conflict.sh bin <repo URL>
~~~~
8. Test the `bump-lfs` driver using the command
~~~~
./create_conflict.sh lfs <repo URL>
~~~~

## How create_conflicts.sh works
1. Makes two clones of the remote repository you specified called (A and B).
2. Moves into A and creates several files with the extension you specified
3. Adds, commits, and pushes the changes to A
4. Moves into B and creates conflicting files with the extension you specified
5. Adds and commits the conflicting files
6. Pulls from the remote, which causes Git to use the specified merge driver
7. The merge should succeed and you should find that the conflicting versions created in `B` have been moved into the `local_version` subdirectories within the repository 
