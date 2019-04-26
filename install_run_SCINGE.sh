#!/bin/bash
# Install the compiled SCINGE_Example executable from a temporary location
wget --quiet https://www.biostat.wisc.edu/~gitter/tmp/369b3eb57db4fb1fce29c5ae28db3ee7/SCINGE_Example
chmod u+x SCINGE_Example

apt-get update
apt-get -y install libxt6 bzip2

# Install Miniconda3 following https://hub.docker.com/r/continuumio/miniconda3/dockerfile
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh
/bin/bash ~/miniconda.sh -b -p /opt/conda
rm ~/miniconda.sh
/opt/conda/bin/conda clean -tipsy
ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate base" >> ~/.bashrc

# Install csvdiff
python --version
pip install csvdiff

# Run the MATLAB-generated wrapper script
./run_SCINGE_Example.sh /usr/local/MATLAB/MATLAB_Runtime/v94
