# Single-Cell Inference of Networks using Granger Ensembles (SCINGE)
Gene regulatory network reconstruction from pseudotemporal single-cell gene expression data.
Standalone MATLAB implementation of the SCINGE algorithm.

## Dependency
This code requires the glmnet_matlab package (http://web.stanford.edu/~hastie/glmnet_matlab/download.html).

## Inputs
- *Data* - Path to ordered single-cell expression data (e.g., `data1/X_SCODE_data`)
- *Outdir* - Path to folder for storing results from individual GLG Tests
- *num_replicates* - number of subsampled replicates obtained for each GLG Test
- *gene_list* - path to list of gene names corresponding to the expression data in Data (e.g., `data1/tf`).

**GLG Hyperparameters:**
- param.ID - Identifier for GLG hyperparameter set
- param.lambda - Sparsity parameter (lambda = 0 results in non-sparse solution)
- param.dT - Time resolution for GLG Test
- param.num_lags - Number of lags for GLG Test
- param.kernel_width - Gaussian kernel width for GLG Test
- param.family - Distribution Family of the gene expression values (options = `gaussian`, `poisson`, default = `gaussian`)
- param.prob_zero_removal - For Zero-Handling Strategy (default = 0)

## Outputs
- *ranked_edges* - Edge lists ranked according to their SCINGE scores
influential_genes - Genes ranked according to their SCINGE influence.

## Example script
`SCINGE_Example.m` demonstrates a simple example with two hyperparameter sets and two replicates.
