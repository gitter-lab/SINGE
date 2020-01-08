# Single-cell Inference of Networks using Granger Ensembles (SINGE)

[![Build Status](https://travis-ci.com/gitter-lab/SINGE.svg?branch=master)](https://travis-ci.com/gitter-lab/SINGE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2549817.svg)](https://doi.org/10.5281/zenodo.2549817)

Gene regulatory network reconstruction from pseudotemporal single-cell gene expression data.
Standalone MATLAB implementation of the SINGE algorithm.
This code has been tested on MATLAB R2014b and R2018a on the Linux operating system.

The software was formerly called SCINGE and has been renamed **SINGE**.

## Citation

If you use the SINGE software please cite:

Atul Deshpande, Li-Fang Chu, Ron Stewart, Anthony Gitter.
[Network inference with Granger causality ensembles on single-cell transcriptomic data](https://doi.org/10.1101/534834).
*bioRxiv* 2019. doi:10.1101/534834

The [SINGE-supplemental](https://github.com/gitter-lab/SINGE-supplemental) repository contains additional scripts, analyses, and results related to this manuscript.

## Dependencies
The dependencies vary based on how SINGE is run.
Setup instructions for each mode are described below.

## Modes of execution
The full SINGE pipeline runs multiple Generalized Lasso Granger (GLG) tests to infer different directed networks for different hyperparameters and subsamples of the data.
These directed networks are then aggregated into a final predicted network.
For small or medium datasets and relatively few hyperparameter combinations, SINGE can be run in a "standalone" mode where all the GLG tests and the aggregation step are run serially.
However, for larger datasets or hyperparameter combinations, the GLG tests can be run in parallel on a single machine or multiple machines.
After all GLG tests terminate, the results can be aggregated separately.

The standalone and parallel modes are accessible in three ways: MATLAB, compiled MATLAB executables with a wrapper Bash script, or Docker.

### MATLAB environment
Running SINGE through MATALB requires the source code in this repository and the [glmnet_matlab package](http://web.stanford.edu/~hastie/glmnet_matlab/download.html) as a dependency.
Unzip `glmnet_matlab.zip` in either the root directory that contains `SINGE_Example.m` or the `code` subdirectory.
Then use `SINGE.m` to run SINGE in the standalone mode or `SINGE_GLG_Test.m` and `SINGE_Aggregate.m` to run each stage separately.
`SINGE.m` usage:
```
SINGE(Data,gene_list,outdir,hyperparameter_file)
```
#### Example
`SINGE_Example.m` demonstrates a simple example with the hyperparameters specified in `default_hyperparameters.txt`.
It runs SINGE on `data1/X_SCODE_data.mat` and writes the results to the `Output` directory.

### Compiled MATLAB code with R2018a runtime
Requires Bash and the MATLAB R2018a runtime library, which can be downloaded from https://www.mathworks.com/products/compiler/matlab-runtime.html
In addition, the compiled SINGE executables and the wrapper scripts `SINGE.sh`, `run_SINGE_GLG_Test.sh`, and `run_SINGE_Aggregate.sh` from this repository are required.
Starting with release 0.4.0, the compiled executables `SINGE_GLG_Test` and `SINGE_Aggregate` are available from the [GitHub releases page](https://github.com/gitter-lab/SINGE/releases).
The executables must be in the same directory as the wrapper scripts.
Bash wrapper script usage:
```
bash SINGE.sh runtime_dir mode Data gene_list outdir [hyperparameter_file] [hyperparameter_number]
```
- `hyperparameter_file` is required only for the standalone and GLG modes.
- `hyperparameter_number` is required only for GLG mode.
Use `bash SINGE.sh -h` to print the complete usage message.

#### Examples
##### Standalone mode (run GLG for all hyperparameters and aggregate the output)
```
bash SINGE.sh PATH_TO_RUNTIME standalone data1/X_SCODE_data.mat data1/tf.mat Output default_hyperparameters.txt
```
##### GLG mode (run GLG for the second hyperparameter in the hyperparameter file)
```
bash SINGE.sh PATH_TO_RUNTIME GLG data1/X_SCODE_data.mat data1/tf.mat Output default_hyperparameters.txt 2
```
##### Aggregate mode (run Aggregate mode separately)

```
bash SINGE.sh PATH_TO_RUNTIME Aggregate data1/X_SCODE_data.mat data1/tf.mat Output
```
Replace `PATH_TO_RUNTIME` with the path to the MATLAB R2018a runtime.

### Docker
Requires Docker.
The most straightforward way to run SINGE through Docker is with the `SINGE.sh` wrapper script.
The usage is the same as the examples above except the script name and MATLAB runtime path do not need to be specified.
Alternatively, arbitrary commands can be run inside Docker by overriding the default entry point.
We recommend specifying the version of the Docker image.

#### Examples
##### `SINGE.sh` wrapper script in standalone mode
```
docker run -v $(pwd):/SINGE -w /SINGE agitter/singe:0.4.0 standalone data1/X_SCODE_data.mat data1/tf.mat Output default_hyperparameters.txt
```

#### Arbitrary commands using Bash as the entry point
```
docker run -v $(pwd):/SINGE -w /SINGE --entrypoint "/bin/bash" agitter/singe:0.4.0 -c "source ~/.bashrc; conda activate singe-test; tests/compare_example_output.sh Output
```
This example is part of the SINGE test code, which only runs when called from the root of the SINGE git repository.

## Inputs
- *data* - Path to matfile with ordered single-cell expression data (`X`), pseudotime values (`ptime`), and optional indices of regulators (`regix`) (e.g., `data1/X_SCODE_data.mat`)
- *gene_list* - Path to file containing list of gene names corresponding to the rows in the expression data matrix `X` in Data (e.g., `data1/tf.mat`)
- *outdir* - Path to folder for storing results from individual GLG Tests
- *hyperparameter_file* - Path to file containing a list of GLG hyperparameter combinations for the hyperparameters described below

**Additional input for compiled MATLAB code with R2018a runtime**
- *runtime_dir* - Path to MATLAB R2018a runtime library

**GLG hyperparameters:**
- *--ID* - Identifier for GLG hyperparameter set
- *--lambda* - Sparsity parameter (lambda = 0 results in a non-sparse solution)
- *--dT* - Time resolution for GLG Test
- *--num-lags* - Number of lags for GLG Test
- *--kernel-width* - Gaussian kernel width for GLG Test
- *--replicate* - Replicate index
- *--family* - Distribution Family of the gene expression values (options = `gaussian`, `poisson`, default = `gaussian`)
- *--prob-zero-removal* - For Zero-handling Strategy (default = 0)
- *--prob-remove-samples* - Sample removal rate for obtaining subsampled replicates (default = 0.2)
- *--date* - Valid date in the `dd-mmm-yyyy` or `mm/dd/yyyy` format.

See `default_hyperparameters.txt` for an example hyperparameters file.
Users can generate their own hyperparameter file using the `bash` script [`scripts/generate_hyperparameters.sh`](scripts/generate_hyperparmeters.sh), which takes hyperparameter values from the files `scripts/lambda.txt`, `scripts/kernel.txt`, `scripts/time.txt`, `scripts/probzeroremoval.txt`, and `scripts/probremovesample.txt`.

See [`USAGE.md`](USAGE.md) for guidelines on setting hyperparameters and running SINGE on a new dataset.

## Outputs
- *SINGE_Ranked_Edge_List.txt* - File with list of ranked edges according to their SINGE scores
- *SINGE_Gene_Influence.txt* - File with list of genes ranked according to their SINGE influence.

## Note on reproducibility
The master branch of this repository may be unstable as new features are implemented.
Use a versioned [release](https://github.com/gitter-lab/SINGE/releases) for stable data analysis.

Because the subsampling and zero-removal stages involve pseudo-random sample removals, SINGE generates a random seed using input hyperparameters, including the *date* input.
The results can be reproduced by providing the same inputs and date from a previous experiment.

## Testing
The `tests` directory contains test scripts and reference output files to test SINGE.

## Compiling
The compiled version of SINGE is generated by compiling the MATLAB code in MATLAB R2018a on Linux:
```
mcc -N -m -R -singleCompThread -R -nodisplay -R -nojvm -a ./glmnet_matlab/ -a ./code/ SINGE_GLG_Test.m
mcc -N -m -R -singleCompThread -R -nodisplay -R -nojvm -a ./code/ SINGE_Aggregate.m
```

`compile_SINGE.sh` is used for testing to compile SINGE and confirm the source `.m` files match the versions used to create the binaries.

## Licenses
SINGE is available under the MIT License, Copyright © 2019 Atul Deshpande, Anthony Gitter.

The file `iLasso_for_SINGE.m` has been modified from [`iLasso.m`](https://github.com/USC-Melady/Granger-causality/blob/a6c76003f9534a99bb66163510d6d84a00189afa/iLasso.m).
The original third-party code is available under the [MIT License](https://github.com/USC-Melady/Granger-causality/blob/a6c76003f9534a99bb66163510d6d84a00189afa/LICENSE), Copyright © 2014 USC-Melady.

The compiled version of SINGE includes the [glmnet_matlab](http://web.stanford.edu/~hastie/glmnet_matlab/index.html) package, which is available under the GPL-2 license.
