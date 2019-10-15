#!/bin/bash
# Run SINGE on the example data calling the GLG and aggregate stages
# individually using the Docker image to run SINGE
set -o errexit

# Run SINGE on the example data using the bash script to run each stage
# separately and inspect the output
echo Testing SINGE with high-throughput calls to SINGE.sh
hyperparams=tests/example_hyperparameters.txt
lines=$(wc -l $hyperparams | awk '{ print $1 }')
echo lines: $lines
output=high_throughput_output
for ((line=0; line<=lines; line++)); do
  echo line: $line
  docker run -v $(pwd):/SINGE -w /SINGE --entrypoint "/bin/bash" agitter/singe:tmp -c \
    "./SINGE.sh /usr/local/MATLAB/MATLAB_Runtime/v94 GLG data1/X_SCODE_data.mat data1/tf.mat $output $hyperparams $line"
done

docker run -v $(pwd):/SINGE -w /SINGE --entrypoint "/bin/bash" agitter/singe:tmp -c \
  "./SINGE.sh /usr/local/MATLAB/MATLAB_Runtime/v94 aggregate data1/X_SCODE_data.mat data1/tf.mat $output"

ls $output -l

# Run the tests to compare the SINGE outputs from the standalone script
# run in the high-throughput setting
docker run -v $(pwd):/SINGE -w /SINGE --entrypoint "/bin/bash" agitter/singe:tmp -c \
  "source ~/.bashrc; conda activate singe-test; tests/compare_example_output.sh $output"
