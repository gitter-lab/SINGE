# SINGE tests

This directory contains scripts and reference files used to test SINGE.
It uses Python to compare the output files SINGE generates to reference files that represent the expected output.
Multiple versions of the reference outputs are provided in order to track how the SINGE behavior has changed as new software versions are released.

- `reference/original`: A directory containing the expected outputs from v0.1.0 of `SCINGE_Example.m` after updating them to MAT file format v7.3
- `reference/latest`: A directory containing the expected outputs from the latest version of `SCINGE_Example.m`
- `environment.yml`: A conda environment with the Python packages required for the test scripts
- `compare_example_output.sh`: A script to compare the generated and reference output files
- `compare_adj_matrices.py`: A Python script to compare the sparse adjacency matrices in two `.mat` files

#### `compare_adj_matrices.py` usage

```
usage: compare_adj_matrices.py [-h] mat_file mat_file

Compare the Adj_Matrix sparse matrices in two .mat files. Return with exit
code 1 if they are not equal.

positional arguments:
  mat_file    The .mat files to compare. Exactly two required.

optional arguments:
  -h, --help  show this help message and exit
```
