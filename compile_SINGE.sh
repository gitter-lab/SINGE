#!/bin/bash
# Compile SCINGE_Example.m
# Run from the repository base directory
# Store the md5sum of the source MATLAB files and binary
# If a directory is provided as an argument, copy the binary and md5sum file there

# Compile SINGE creating the binary SCINGE_Example
mcc -N -m -R -singleCompThread -R -nodisplay -R -nojvm -a ./glmnet_matlab/ -a ./code/ SCINGE_Example.m

# Store the md5sums of all .m files tracked in the git repository and the binary
# See https://stackoverflow.com/questions/15606955/how-can-i-make-git-show-a-list-of-the-files-that-are-being-tracked/15606998
# and https://stackoverflow.com/questions/13335837/how-to-grep-for-a-file-extension
md5sum $(git ls-tree -r HEAD --name-only | grep '.*\.m$') SCINGE_Example > code.md5
cat code.md5

# Copy the binary and md5sum file
if [ $# -gt 0 ]; then
  basedir=$1

  # Use the md5sum of the binary as a subdirectory name
  # See array assignment from https://stackoverflow.com/questions/3679296/only-get-hash-value-using-md5sum-without-filename
  binary_md5=($(md5sum SCINGE_Example))
  outdir=$basedir/$binary_md5

  printf "Copying SCINGE_Example and code.md5 to %s\n" $outdir
  mkdir -p $outdir
  cp SCINGE_Example $outdir
  cp code.md5 $outdir
fi
