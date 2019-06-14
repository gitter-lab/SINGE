function [XR] = dropSamples(varargin)
probRemove = varargin{1};
infile = varargin{2};
% Import X from matfile
X = infile.X;
% Get size of X;
[LX,WX ] = size(infile,'X');
if ismember('X1',who(infile))
    % Make sure to remove samples *after* removing zeros (optionally)
    % Get matrix of logical values corresponding to already removed
    % samples.
    XR = infile.X1;
    for i = 1:LX
        ind = find(~XR(i,:));
        ind = ind(rand(1,length(ind))<probRemove);
        XR(i,ind) = true; 
    end
    %XR = (rand(WX,LX)<probRemove)'|infile.X1; 
else
    XR = (rand(WX,LX)<probZero)'; 
end
