function [metric] = run_iLasso_row(m,outs,params,rownum)
dT=params.dT;
lambda=params.lambda;
p1=params.p1;
std_dev=params.kernel_width;
[LX,WX] = size(m,'X');
numrows = LX;
if ismember('regix',who(m))
    numregs = length(m,'regix');
else
    numregs = LX;
end

ALasso = zeros(numregs,numrows,floor(p1/dT));
starting = dT;

for p = rownum
    params.p = rownum;
    pa = [p setdiff([1:numrows],p)];
    m.pa = pa;
    [pi,indf] = sort(pa);
    I = eye(numrows);
    P = I(pa,:);
    [metric] = iLasso_for_SCINGE(m, outs, lambda,'Gaussian',p1,dT,std_dev,params);
end
%Moved this code to iLasso_for_SINGE to enable saving multiple outputs
%fromg glmnet