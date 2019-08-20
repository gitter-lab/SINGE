#!/bin/sh
# Run SINGE and tests inside the Docker image
set -o errexit

# Move the binary and check the source and binary versions (md5sums)
mv /download/SCINGE_Example .
mv /download/code.md5 .
# Append the binary md5sum to the md5sums of the tracked source code files
md5sum SCINGE_Example >> current_code.md5
cat current_code.md5
# An error similar to:
# 'code.md5 current_code.md5 differ: char 174, line 4'
# indicates the md5sums of the current source and binary files do not match
# the expected versions
cmp code.md5 current_code.md5

# Run SINGE on the example data and inspect the output
./run_SCINGE_Example.sh /usr/local/MATLAB/MATLAB_Runtime/v94
ls Output/ -l

# Confirm the contents of the conda environment
conda list

# Run the tests to compare the SINGE outputs
tests/compare_example_output.sh
