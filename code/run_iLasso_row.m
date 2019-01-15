function [ALasso, metric] = run_iLasso_row(X,params,rownum)
dT=params.dT;
lambda=params.lambda;
p1=params.p1;
std_dev=params.kernel_width;
numrows = max(size(X,1),size(X,2));

if ~(iscell(X))
    xcellf = mat2cell(X,ones(size(X,1),1),length(X(1,:)));
    for i = 1:numrows
        xcellf{i} = [xcellf{i};1:length(xcellf{1})];
    end
    % Need to be done for all the samples at once!
    if params.resampling==1
        if isfield(params,'holes')
            holes = params.holes;
        else
            holes = 1;
        end
        indgen = randi(holes,[1,length(xcellf{1})]);
        ind1 = cumsum(indgen);
        ind = ind1(ind1<length(xcellf{1})+1);
    else
        if isfield(params,'burst')
            burst = params.burst;
        else
            burst = 10;
        end
        ind = 1:length(xcellf{1});
        ind = sort(randperm(length(xcellf{1}),floor(burst*length(xcellf{1})/7)*7));
    end
    for i = 1:numrows
        xcell{i} = xcellf{i}(:,ind);
    end
else
    xcell = X;
end
ALasso = zeros(numrows,numrows,floor(p1/dT));
starting = dT;

for p = rownum
    pa = [p setdiff([1:numrows],p)];
    [pi,indf] = sort(pa);
    I = eye(numrows);
    P = I(pa,:);
    [a, metric] = iLasso_for_SCINGE(xcell(pa), lambda,'Gaussian',p1,dT,std_dev,params);
    metric.order = pa;
    a = P'*a;
    a = fliplr(a);
    for j = 1:size(a,2)
        for i = 1:numrows
            ALasso(i,p,j) = a(i,j);
        end
    end
end