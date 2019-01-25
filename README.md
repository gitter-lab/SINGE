# Single-Cell Inference of Networks using Granger Ensembles (SCINGE)
Gene regulatory network reconstruction from pseudotemporal single-cell gene expression data.
Standalone MATLAB implementation of the SCINGE algorithm.
This code has been tested on MATLAB R2014b and R2018a on Linux operating systems.

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
- *param.date* - Valid date in the 'dd-mmm-yyyy' or 'mm/dd/yyyy' format. 

## Outputs
- *ranked_edges* - Edge lists ranked according to their SCINGE scores
- *influential_genes* - Genes ranked according to their SCINGE influence.

## Note on Reproducibility of Results
Because the subsampling and zero-removal stages involve pseudo-random sample removals, we generate a random seed using input hyperparameters, including the *date* input.
The results can be reproduced by providing the same inputs and date from a previous experiment.

## Example
`SCINGE_Example.m` demonstrates a simple example with two hyperparameter sets and two replicates.
It runs SCINGE on `data1/X_SCODE_data` and writes the results to the `Output` directory.

## Licenses
SCINGE is available under the MIT License, Copyright © 2019 Atul Deshpande, Anthony Gitter.

The file `iLasso_for_SCINGE.m` has been modified from [`iLasso.m`](https://github.com/USC-Melady/Granger-causality/blob/a6c76003f9534a99bb66163510d6d84a00189afa/iLasso.m).
The original third-party code is available under the [MIT License](https://github.com/USC-Melady/Granger-causality/blob/a6c76003f9534a99bb66163510d6d84a00189afa/LICENSE), Copyright © 2014 USC-Melady.
