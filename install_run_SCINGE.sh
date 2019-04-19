#!/bin/bash
# Install the compiled SCINGE_Example executable from a temporary location
curl -O https://www.biostat.wisc.edu/~gitter/tmp/86e65385d9e50e21be23bd8185e02e3b/SCINGE_Example
chmod u+x SCINGE_Example

# Run the MATLAB-generated wrapper script
./run_SCINGE_Example.sh /usr/local/MATLAB/MATLAB_Runtime/v94

