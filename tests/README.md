# SINGE tests

This directory contains scripts and reference files used to test SINGE.
It uses Python to compare the output files SINGE generates to reference files that represent the expected output.
Multiple versions of the reference outputs are provided in order to track how the SINGE behavior has changed as new software versions are released.

- `reference/original`: A directory containing the expected outputs from v0.1.0 of SINGE run on the example data after updating them to MAT file format v7.3
- `reference/latest`: A directory containing the expected outputs from the latest version of SINGE
- `reference/branching`: A directory containing the expected outputs from the latest version of SINGE for testing branch indices
- `reference/regulator`: A directory containing the expected outputs from the latest version of SINGE for testing regulator indices
- `environment.yml`: A conda environment with the Python packages required for the test scripts
- `example_hyperparameters.txt`: The hyperparameter combinations used to test SINGE
- `docker_test.sh`: A script that confirms the downloaded compiled code matches the source code, runs SINGE on example data, and compares the output with the reference files inside the Docker container
- `SINGE_Test.m`: A MATLAB script derived from `SINGE_Example.m` that tests running SINGE through `SINGE.m` instead of the standalone script
- `high_throughput_test.sh`: A script that simulates running SINGE in a high-throughput computing environment, using Docker to make separate calls to `SINGE.sh` for each GLG run and the aggregation step
- `standalone_test.sh`: A script uses Docker to run `SINGE.sh` in standalone mode
- `standalone_branching_test.sh`: A script uses Docker to run `SINGE.sh` in standalone mode when branch indices are provided
- `standalone_regulator_test.sh`: A script uses Docker to run `SINGE.sh` in standalone mode when regulator indices are provided
- `compare_example_output.sh`: A script to compare the generated and reference output files
- `compare_branching_output.sh`: A script to compare the generated and reference output files when branch indices are provided
- `compare_adj_matrices.py`: A Python script to compare the sparse adjacency matrices in two `.mat` files

#### `compare_adj_matrices.py` usage

```
usage: compare_adj_matrices.py [-h] [--rtol RTOL] [--atol ATOL]
                               mat_file mat_file

Compare the Adj_Matrix sparse matrices in two .mat files. Return with exit
code 1 if they are not equal.

positional arguments:
  mat_file     The .mat files to compare. Exactly two required.

optional arguments:
  -h, --help   show this help message and exit
  --rtol RTOL  The relative tolerance parameter for numpy.allclose (default: 1.00e-05)
  --atol ATOL  The absolute tolerance parameter for numpy.allclose (default: 1.00e-08)
```
