git config --global merge.bump.name "Bump local copy to local_version folder, keep server copy"
git config --global merge.bump.driver "bump_merge.sh %%O %%A %%B"

git config --global merge.bump-lfs.name "Bump local copy to local_version folder, keep server copy (LFS)"
git config --global merge.bump-lfs.driver "bump_merge_lfs.sh %%O %%A %%B"
