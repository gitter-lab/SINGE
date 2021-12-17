# Version 0.5.1
Changes in version 0.5.1 include:
- Fix a bug that caused the regulator index to be ignored
- Generalize the test scripts
- Add a new regulator index test case

# Version 0.5.0
Changes in version 0.5.0 include:
- Add workflow for compiling, running, and testing macOS binaries 
- Add initial support for branching trajectories and example branching dataset
- Update usage guidelines for large datasets and branching trajectories
- Allow file separators in output directory
- Support v7 mat files as input
- Migrate continuous integration to GitHub Actions
- Document partial Windows support

Thank you [@ktakers](https://github.com/ktakers) for reporting the issues with the output directory and v7 mat file format.

# Version 0.4.1
Version 0.4.1 fixes a bug that occurred when multiple GLG tests were run in parallel with a shared file system.
The same temporary .mat file was overwritten by different GLG tests.
Now, each GLG test includes the ID hyperparameter in the temporary .mat filename.

Thank you [@PayamDiba](https://github.com/PayamDiba) for reporting this issue.

Version 0.4.1 also contains the first compiled SINGE binaries for macOS.

# Version 0.4.0
Changes in version 0.4.0 include:
- Support three modes of execution: MATLAB, compiled MATLAB executables with MATLAB runtime, or Docker
- The SINGE workflow has been split in GLG and Aggregate steps
- A wrapper script supports running the GLG and Aggregate steps individually or the entire workflow
- Increase robustness of hyperparameter parsing
- Add script to generate hyperparameter file
- Add usage guidelines
- Update Docker images are built on Travis CI
- Generalize Docker image to work outside the SINGE git repository
- Add default entrypoint to Docker image
- Test cases assert that the source code matches the compiled MATLAB executables
- All remaining instances of the old name SCINGE have been changed to SINGE
- Rename data1/tf.mat to data1/gene_list.mat and added data3 dataset

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
