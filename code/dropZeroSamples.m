function [XR] = dropZeroSamples(varargin)
probRemove = varargin{1};
infile = varargin{2};
% Import X from matfile
X = infile.X;
% get size of X
[LX,WX] = size(X);
% drop zeros with probability probRemove
XR = (rand(WX,LX)<probRemove)'&(X==0);