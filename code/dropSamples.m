function [XR] = dropSamples(varargin)
% Output XR is a logical mask of samples to be dropped to create a
% subsampled replicate.
% inputs: 1) probability of dropping samples
% 2) pointer to mat-file TempMat.mat
% 
probRemove = varargin{1};
infile = varargin{2};
% Import X from matfile
X = infile.X;
% Get size of X;
[LX,WX ] = size(infile,'X');
if ismember('Xdrop',who(infile))
    % Make sure to remove samples *after* removing zeros (optionally)
    % Get matrix of logical values corresponding to already removed
    % samples.
    XR = infile.Xdrop;
    for i = 1:LX
        ind = find(~XR(i,:));
        ind = ind(rand(1,length(ind))<probRemove);
        XR(i,ind) = true; 
    end
    %XR = (rand(WX,LX)<probRemove)'|infile.X1; 
else
    XR = (rand(WX,LX)<probZero)'; 
end
