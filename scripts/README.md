## Generating your own hyperparameter.txt file using different values of individual parameters
Here, we provide the script `generate_hyperparameters.sh`, along with input text files describing the range of values for each individual parameter (e.g., lambda.txt, kernel.txt, time.txt, probremovesample.txt, and probzeroremoval.txt). 
Each input file lists one value (or pair of values for time.txt) per line and must end with a newline.
The datestamp is generated and added automatically.

Script usage:
`bash generate_hyperparameters.sh <family> <numreplicates>`

The command line parameters are:
- `<family>` - Distribution family of the gene expression values (options = gaussian, poisson, default = gaussian)
- `<numreplicates>` - Number of subsampled replicates to be generated for each hyperparameter combination (default = 10)
