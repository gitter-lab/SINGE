#!/bin/bash
# Install Glmnet by downloading from
# http://web.stanford.edu/~hastie/glmnet_matlab/index.html
# and compiling for Octave
apt-get update
apt-get -y install wget
wget http://web.stanford.edu/~hastie/glmnet_matlab/glmnet_matlab.zip
unzip glmnet_matlab.zip

cd glmnet_matlab
wget https://raw.githubusercontent.com/SheffieldML/GPmat/master/kern/mex/fintrf.h
mkoctfile --verbose --mex glmnetMex.F GLMnet.f

cd ..

# To help debugging
gfortran --version
