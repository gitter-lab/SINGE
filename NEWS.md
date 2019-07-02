# Version 0.3.0
Version 0.3.0 contains optimizations that greatly increase SINGE's speed but can change its output:
- Switch to single precision for the kernel matrix
- Set an upper bound of 10000 on the glmnet solver's iterations
- Set a threshold of 1e-7 on the glmnet solver's convergence

The Travis CI test cases now run 7.5 to 10 times faster on the example data.
The reference files used to test SINGE have been updated to match the new behavior.
Only one edge score changed for the SINGE output on the example data.

Additional changes in version 0.3.0 include:
- Extensive optimizations to replace loops with vectorized calculations
- Precompute the full kernel matrix to eliminate redundant calculations
- Add support for the `regix` regulator index column in the input data that enables only a subset of genes to be treated as regulators
- Switch to MAT file format v7.3 and update the test code and reference files accordingly
- Use the warm start feature of glmnet to initialize the solver when running with multiple lambda sparsity hyperparameters
- Change the file naming conventions for the intermediate adjacency matrices
- Change how the seed is calculated from the input hyperparameters to accommodate multiple lambda values
- Use an intermediate MAT file to store temporary state on disk
- Add support for hyperparameters provided as strings

# Version 0.2.0
Changes in version 0.2.0 include:
- Fix a bug in random sample removal that only dropped zero-valued samples
- Rename software to SINGE (not all files have been updated yet)
- Add test cases and Travis CI testing of a static compiled version of SINGE 
- Modularize parameter parsing
- Code optimizations when preparing data for glmnet
- Initial steps toward a SINGE Docker image

# Version 0.1.0
Initial release
