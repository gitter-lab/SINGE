#!/bin/sh
# Run SINGE and tests inside the Docker image
# Move the binary and check the version
mv /download/SCINGE_Example .
md5sum SCINGE_Example

# Run SINGE on the example data and inspect the output
./run_SCINGE_Example.sh /usr/local/MATLAB/MATLAB_Runtime/v94
ls Output/ -l

# Confirm the contents of the conda environment
conda list

# Run the tests
tests/compare_example_output.sh
