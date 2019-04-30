# SCINGE tests

This directory contains scripts and reference files used to test SCINGE.
It uses Python to compare the output files SCINGE generates to reference files that represent the expected output.

- `reference`: A directory containing the expected outputs from `SCINGE_Example.m`
- `environment.yml`: A conda environment with the Python packages required for the test scripts
- `compare_example_output.sh`: A script to compare the generated and reference output files
- `compare_adj_matrices.py`: A Python script to compare the sparse adjacency matrices in two `.mat` files

## `compare_adj_matrices.py` usage

```
usage: compare_adj_matrices.py [-h] mat_file mat_file

Compare the Adj_Matrix sparse matrices in two .mat files. Return with exit
code 1 if they are not equal.

positional arguments:
  mat_file    The .mat files to compare. Exactly two required.

optional arguments:
  -h, --help  show this help message and exit
```
