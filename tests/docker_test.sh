#!/bin/sh
# Run SINGE and tests inside the Docker image
set -o errexit

# Move the binaries and check the versions of the source and binaries (md5sums)
mv /download/* .
# Append the binary md5sum to the md5sums of the tracked source code files
md5sum SINGE_GLG_Test >> current_code.md5
md5sum SINGE_Aggregate >> current_code.md5
cat current_code.md5
# An error similar to:
# 'code.md5 current_code.md5 differ: char 174, line 4'
# indicates the md5sums of the current source and binary files do not match
# the expected versions
cmp code.md5 current_code.md5

# Run SINGE on the example data and inspect the output
./standalone_SINGE.sh data1/X_SCODE_data.mat data1/tf.mat Output tests/example_hyperparameters.txt
ls Output/ -l

# Confirm the contents of the conda environment
conda list

# Run the tests to compare the SINGE outputs
tests/compare_example_output.sh
