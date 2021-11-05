#!/bin/sh
# Run SINGE and tests inside the Docker image
set -o errexit

# Check the versions of the source and binaries (md5sums)
# Append the binary md5sum to the md5sums of the tracked source code files
md5sum $SINGE_ROOT/tests/SINGE_Test $SINGE_ROOT/SINGE_GLG_Test $SINGE_ROOT/SINGE_Aggregate >> current_code.md5
# Account for the different file paths in the md5sum file
sed -i "s+$SINGE_ROOT/++g" current_code.md5
cat current_code.md5
# An error similar to:
# 'code.md5 current_code.md5 differ: char 174, line 4'
# indicates the md5sums of the current source and binary files do not match
# the expected versions
cmp $SINGE_ROOT/code.md5 current_code.md5

# Confirm the contents of the conda environment
conda list

# Run SINGE on the example data using the bash script and inspect the output
echo Testing SINGE with standalone SINGE.sh
$SINGE_ROOT/SINGE.sh /usr/local/MATLAB/MATLAB_Runtime/v94 standalone data1/X_SCODE_data.mat data1/gene_list.mat script_output tests/example_hyperparameters.txt
ls script_output/ -l

# Run the tests to compare the SINGE outputs from the standalone script
tests/compare_example_output.sh script_output tests/reference/latest

# Run SINGE on the example data using the compiled SINGE_Test
echo Testing SINGE with compiled SINGE_Test
$SINGE_ROOT/tests/run_SINGE_Test.sh /usr/local/MATLAB/MATLAB_Runtime/v94
ls compiled_output/ -l

# Run the tests to compare the SINGE outputs from the compiled SINGE_Test
# The output directory is hard-coded to compiled_output
tests/compare_example_output.sh compiled_output tests/reference/latest
