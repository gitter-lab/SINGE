#!/bin/bash
# Run SINGE on a dataset with regulator indices specified in standalone mode using the Docker image
# The regix list is [41, 42] which corresponds to genes SIX1 and RARG
# Only those two genes should have outgoing edges and non-zero influence scores.
set -o errexit

# Run SINGE on the example data and inspect the output
echo Testing SINGE standalone mode in Dockerized SINGE.sh with regulator indices
hyperparams=tests/example_hyperparameters.txt
output=regix_output

docker run -v $(pwd):/SINGE -w /SINGE agitter/singe:tmp \
  standalone data1/X_regix_test.mat data1/gene_list.mat $output $hyperparams

ls $output -l

# Run the tests to evaluate the SINGE outputs from the standalone script
docker run -v $(pwd):/SINGE -w /SINGE --entrypoint "/bin/bash" agitter/singe:tmp -c \
  "source ~/.bashrc; conda activate singe-test; tests/compare_example_output.sh $output tests/reference/regix 1e-05 1e-08 X_regix_test"
