#!/bin/bash
# Run SINGE in standalone mode using the Docker image
set -o errexit

# Run SINGE on the example data and inspect the output
echo Testing SINGE standalone mode in Dockerized SINGE.sh
hyperparams=tests/example_hyperparameters.txt
output=standalone_output

docker run -v $(pwd):/SINGE -w /SINGE agitter/singe:tmp \
  standalone data1/X_SCODE_data.mat data1/gene_list.mat $output $hyperparams

ls $output -l

# Run the tests to evaluate the SINGE outputs from the standalone script
docker run -v $(pwd):/SINGE -w /SINGE --entrypoint "/bin/bash" agitter/singe:tmp -c \
  "source ~/.bashrc; conda activate singe-test; tests/compare_example_output.sh $output tests/reference/latest"
