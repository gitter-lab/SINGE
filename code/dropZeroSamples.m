function [XR] = dropZeroSamples(varargin)
% Output XR is a logical mask of samples to be dropped to create a
% subsampled replicate.
% inputs: 1) probability of dropping samples
% 2) pointer to mat-file TempMat.mat

probRemove = varargin{1};
infile = varargin{2};
% Import X from matfile
X = infile.X;
% get size of X
[LX,WX] = size(X);
% drop zeros with probability probRemove
XR = (rand(WX,LX)<probRemove)'&(X==0);