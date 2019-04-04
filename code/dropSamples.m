function [XR] = dropSamples(varargin)
probRemove = (varargin{1});
if ~iscell(varargin{2})
infile = varargin{2};
if nargin>2
    outfileR = varargin{3};
end
if nargin>3
    outfileR = varargin{4};
end
load(infile);
else
    X = varargin{2};
end
XR = X;
for i = 1:length(X)
    ind = find((rand(size(X{i}(1,:)))<probRemove)&(X{i}(1,:)==0));
   % XZ{i}(1,ind) = 0*X{i}(1,ind);
    XR{i}(:,ind) = [];
end
