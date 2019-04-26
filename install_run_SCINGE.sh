#!/bin/bash
# Install the compiled SCINGE_Example executable from a temporary location
wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/369b3eb57db4fb1fce29c5ae28db3ee7/SCINGE_Example
chmod u+x SCINGE_Example

apt-get update
apt-get -y install libxt6 python3-pip

python3 --version
pip install csvdiff

# Run the MATLAB-generated wrapper script
./run_SCINGE_Example.sh /usr/local/MATLAB/MATLAB_Runtime/v94

