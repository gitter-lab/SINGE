#!/bin/bash
# Install the compiled SCINGE_Example executable from a temporary location
wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/f5789af0692f274ae622e4fb7be1b4e8/SCINGE_Example
chmod u+x SCINGE_Example

apt-get update
apt-get -y install libxt6

# Run the MATLAB-generated wrapper script
./run_SCINGE_Example.sh /usr/local/MATLAB/MATLAB_Runtime/v94

