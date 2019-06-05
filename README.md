# Single-cell Inference of Networks using Granger Ensembles (SINGE)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2549817.svg)](https://doi.org/10.5281/zenodo.2549817)

Gene regulatory network reconstruction from pseudotemporal single-cell gene expression data.
Standalone MATLAB implementation of the SINGE algorithm.
This code has been tested on MATLAB R2018a on the Linux operating system.

The software was formerly called SCINGE and has been renamed as **SINGE**.

## Citation

If you use the SINGE software please cite:

Atul Deshpande, Li-Fang Chu, Ron Stewart, Anthony Gitter.
[Network inference with Granger causality ensembles on single-cell transcriptomic data](https://doi.org/10.1101/534834).
*bioRxiv* 2019. doi:10.1101/534834

## Dependency
This code requires the glmnet_matlab package (http://web.stanford.edu/~hastie/glmnet_matlab/download.html).
Unzip `glmnet_matlab.zip` in either the root directory (that contains `SCINGE_Example.m`) or the `code` subdirectory.

## Inputs
- *Data* - Path to ordered single-cell expression data (e.g., `data1/X_SCODE_data`)
- *outdir* - Path to folder for storing results from individual GLG Tests
- *num_replicates* - Number of subsampled replicates obtained for each GLG Test
- *gene_list* - Path to list of gene names corresponding to the expression data in Data (e.g., `data1/tf`).
- *param_list* - A list of GLG hyperparameter combinations for the hyperparameters described below

**GLG Hyperparameters:**
- *param.ID* - Identifier for GLG hyperparameter set
- *param.lambda* - Sparsity parameter (lambda = 0 results in a non-sparse solution)
- *param.dT* - Time resolution for GLG Test
- *param.num_lags* - Number of lags for GLG Test
- *param.kernel_width* - Gaussian kernel width for GLG Test
- *param.family* - Distribution Family of the gene expression values (options = `gaussian`, `poisson`, default = `gaussian`)
- *param.prob_zero_removal* - For Zero-Handling Strategy (default = 0)
- *param.prob_remove_samples* - Sample removal rate for obtaining subsampled replicates (default = 0.2)
- *param.date* - Valid date in the `dd-mmm-yyyy` or `mm/dd/yyyy` format. 

## Outputs
- *ranked_edges* - Edge lists ranked according to their SINGE scores
- *influential_genes* - Genes ranked according to their SINGE influence.

## Note on reproducibility
The master branch of this repository may be unstable as new features are implemented.
Use a versioned [release](https://github.com/gitter-lab/SINGE/releases) for stable data analysis.

Because the subsampling and zero-removal stages involve pseudo-random sample removals, SINGE generates a random seed using input hyperparameters, including the *date* input.
The results can be reproduced by providing the same inputs and date from a previous experiment.

## Example
`SCINGE_Example.m` demonstrates a simple example with two hyperparameter sets and two replicates.
It runs SINGE on `data1/X_SCODE_data` and writes the results to the `Output` directory.

## Testing
The `tests` directory contains test scripts and reference output files to test SINGE.

## Licenses
SINGE is available under the MIT License, Copyright © 2019 Atul Deshpande, Anthony Gitter.

The file `iLasso_for_SCINGE.m` has been modified from [`iLasso.m`](https://github.com/USC-Melady/Granger-causality/blob/a6c76003f9534a99bb66163510d6d84a00189afa/iLasso.m).
The original third-party code is available under the [MIT License](https://github.com/USC-Melady/Granger-causality/blob/a6c76003f9534a99bb66163510d6d84a00189afa/LICENSE), Copyright © 2014 USC-Melady.

The compiled version of SINGE includes the [glmnet_matlab](http://web.stanford.edu/~hastie/glmnet_matlab/index.html) package, which is available under the GPL-2 license.
