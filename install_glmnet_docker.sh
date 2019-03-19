#!/bin/bash
# Install Glmnet by downloading from
# http://web.stanford.edu/~hastie/glmnet_matlab/index.html
# and compiling for Octave
echo "Test install script"
sudo apt-get install wget
wget http://web.stanford.edu/~hastie/glmnet_matlab/glmnet_matlab.zip
unzip glmnet_matlab.zip
cd glmnet_matlab
ls
mkoctfile --mex glmnetMex.F GLMnet.f
cd ..
