#!/bin/sh
# Run SINGE and tests inside the Docker image
set -o errexit

# Move the binaries and check the versions of the source and binaries (md5sums)
mv /download/* .
# Append the binary md5sum to the md5sums of the tracked source code files
md5sum SINGE_Example SINGE_GLG_Test SINGE_Aggregate >> current_code.md5
cat current_code.md5
# An error similar to:
# 'code.md5 current_code.md5 differ: char 174, line 4'
# indicates the md5sums of the current source and binary files do not match
# the expected versions
cmp code.md5 current_code.md5

# Confirm the contents of the conda environment
conda list

# Run SINGE on the example data using the bash script and inspect the output
./standalone_SINGE.sh data1/X_SCODE_data.mat data1/tf.mat script_output tests/example_hyperparameters.txt /usr/local/MATLAB/MATLAB_Runtime/v94
ls script_output/ -l

# Run the tests to compare the SINGE outputs from the standalone script
tests/compare_example_output.sh script_output

# Run SINGE on the example data using the compiled SINGE_Example
./run_SCINGE_Example.sh /usr/local/MATLAB/MATLAB_Runtime/v94
ls Output/ -l

# Run the tests to compare the SINGE outputs from the compiled SINGE_Example
# The output directory is hard-coded to Output
tests/compare_example_output.sh Output
