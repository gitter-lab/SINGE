function [for_metrics] = iLasso_for_SINGE(m, outs, lambda,L,dDt,SIG,params)
% Learning temporal dependency among irregular time series using Lasso (or its variants)
% Only supports the Gaussian kernel
%
% INPUTS:
%       Series: an Nx1 cell array; one cell for each time series. Each cell
%               is a 2xT matrix. First row contains the values and the
%               second row contains SORTED time stamps. The first time
%               series is the target time series which is predicted.
%       lambda: The regularization parameter in Lasso
% OUTPUTS:
%       result: The NxL coefficient matrix.
%       AIC:    The AIC score
%       BIC:    The BIC score
%
% Dependency: This code requires the GLMnet package to perform Lasso.
% For details of the original iLasso algorithm please refer to:
% M. T. Bahadori and Yan Liu, "Granger Causality Analysis in Irregular Time Series", (SDM 2012)
%
% MIT License
% Copyright (c) 2014 USC-Melady
pa = params.pa;
BIC_bias = 0;
AIC_bias = 0;
% Parameters
L = L/dDt;     % Length of studied lag
L0 = L;
Dt = dDt;

LX = params.LX;
WX = params.WX;
numregs = length(pa);
% Define function for Gaussian kernel
gkern = @(x,y) gausskernel(x,y,SIG);
% Load expression matrix and pseudotime
ptime = m.ptime;
Xdrop = m.Xdrop;
% Check for branching process, if 1, load branches from the Temporary File
if params.branching==1
	branches = m.branches;
else
	branches = ones(size(ptime));
end

rind = (~Xdrop);

   % Precompute the full kernel matrix -- to be subsampled for each regulator
   if m.computeKp
       if ismember('fullKp',who(m))&&~isempty(m.fullKp)
           m.fullKp(1,:) = [];
       end
       Kp2.Kp = single(zeros(length(ptime)));
       refT = (ptime);
       for k = 1:L
           % Generate the full Kernel using sequence {ptime-(L-k-1)*dT} and
           % ptime for each value of 1<= k<=L
           Kp = (refT-(L)*Dt+(k-1)*Dt);
           Kp = bsxfun(gkern,Kp',refT);
           for b_ind = 1:min(size(branches))
               rind1 = rind*diag((branches(:,b_ind)>0)*1);
               Kp2.sumKp{b_ind} = single(Kp*rind1');
           end
           Kp2.Kp = single(Kp);
           % saving variables as single helps read them faster
           m.fullKp(1,k) = Kp2;
       end
       m.computeKp = 0;
       clear Kp Kp2;
   end
for b_ind = 1:min(size(branches))
    X = m.X;
    
    % For each branch, only retain the cells corresponding to that branch
    rind1 = rind*diag((branches(:,b_ind)>0)*1);
    
    % Target values and ptime indices relevant for the particular branch.
    tval = X(pa(1),rind1(pa(1),:)>0);
    ttime = ptime(rind1(pa(1),:)>0);
    
    B = sum(ttime<=(L*Dt));
    N1 = size(ttime, 2);
    % remind is the remaining data indices
    remind = find(rind1(pa(1),:)&ptime>L*Dt);
    % Build the matrix elements
    Am = (zeros(N1-B, numregs*L));
    X = X(pa,:).*rind1(pa,:);
    % Building the design matrix
    for k = 1:L
        Kp2 = m.fullKp(1,k);
        Kp2.Kp = double(Kp2.Kp);
        %Kp2.sumKp = Kp2.Kp*rind';
        Kp2.Kp = sparse(Kp2.Kp(remind,:));
        sumKp = double(Kp2.sumKp{b_ind}(remind,pa));
        Am(:, ([1:numregs]-1)*L+k) = (Kp2.Kp*X')./sumKp;
        clear Kp2;
    end
    bm = (tval(1,B+1:N1)');
    
    % Solving Lasso using a solver; here the 'GLMnet' package
    opt = glmnetSet;
    opt.lambda = lambda;
    opt.maxit = 10000;
    opt.thresh = 1e-7;
    opt.nlambda = length(lambda);
    opt.alpha = 1;
    [nObs,nVars] = size(Am);
    opt.penalty_factor = ones(nVars,1);
    j= 1;
    
    %   No sparsity constraint on autoregressive interactions for SINGE
    opt.penalty_factor(((j-1)*L+1):(j*L)) = 0;
    %Am = sparse(Am);
    fit = glmnet(Am, bm, params.family, opt);
    
    % workaround for mex memory leak issue
    clear mex;
    
    clear Am;
    w = fit.beta;
    
    % Reformatting the output
    count = 0; genes = []; areas = [];
    
    for_metrics.a0 = fit.a0;
    for_metrics.order = pa;
    for_metrics.params = params;
    p = params.p;
    for ii = 1:size(w,2)
        result = zeros(numregs, L);
        if isempty(w)
            result = zeros(numregs,1);
        else
            result =  sum(reshape(w(:,ii)',L,numregs)',2);
        end
        P = sparse(eye(LX));
        P = P(pa,:);
        result = P'*result;
        ALasso = spalloc(LX,LX,numregs);
        ALasso(:,p) = result(:,1);
        outs{(b_ind-1)*opt.nlambda + ii}.Adj_Matrix = outs{(b_ind-1)*opt.nlambda + ii}.Adj_Matrix + (ALasso);
        clear ALasso;
    end
end
end
function Kp = gausskernel(x,y,SIG)
Kp = exp(-((x-y).^2)/SIG);
end
