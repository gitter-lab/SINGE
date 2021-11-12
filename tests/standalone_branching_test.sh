#!/bin/bash
# Run SINGE on a branching dataset in standalone mode using the Docker image
set -o errexit

# Only one one set of hyperparamters because SINGE has to run three times
# (once per branch) for each hyperparameter combination
# Keep the thrid line of the hyperparameters file
hyperparams=tests/example_hyperparameters.txt
reducedhyperparams=tests/reduced_hyperparameters.txt
cat $hyperparams | sed -n '3p' > $reducedhyperparams

# Run SINGE on the example data and inspect the output
echo Testing SINGE standalone mode in Dockerized SINGE.sh with a branching dataset
output=branching_output

docker run -v $(pwd):/SINGE -w /SINGE agitter/singe:tmp \
  standalone data1/X_BranchTest.mat data1/gene_list.mat $output $reducedhyperparams

ls $output -l
rm $reducedhyperparams

# Run the tests to evaluate the SINGE outputs from the standalone script
docker run -v $(pwd):/SINGE -w /SINGE --entrypoint "/bin/bash" agitter/singe:tmp -c \
  "source ~/.bashrc; conda activate singe-test; tests/compare_branching_output.sh $output"
