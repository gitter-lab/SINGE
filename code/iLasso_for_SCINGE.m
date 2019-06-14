function [for_metrics] = iLasso_for_SCINGE(m, outs, lambda, krnl,L,dDt,SIG,params)
% Learning temporal dependency among irregular time series using Lasso (or its variants)
%
% INPUTS:
%       Series: an Nx1 cell array; one cell for each time series. Each cell
%               is a 2xT matrix. First row contains the values and the
%               second row contains SORTED time stamps. The first time
%               series is the target time series which is predicted.
%       lambda: The regularization parameter in Lasso
%       krnl:   Selects the kernel. Default is Gaussian. Available options
%               are Sinc (krnl = Sinc) and Inverse distance (krnl = Dist).
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
pa = m.pa;
BIC_bias = 0;
AIC_bias = 0;
% Parameters
L = L/dDt;     % Length of studied lag
L0 = L;
Dt = dDt;
% \Delta t
[LX,WX] = size(m,'X');
if ismember('regix',who(m))
    numregs = length(m,'regix');
else
    numregs = LX;
end
% Define funtion for Gaussian kernel
gkern = @(x,y) gausskernel(x,y,SIG);
% Load expression matrix and pseudotime
X = m.X;
ptime = m.ptime;

% Precompute the full kernel matrix -- to be subsampled for each regulator
if m.computeKp
    if ismember('fullKp',who(m))&&~isempty(m.fullKp)
        m.fullKp(1,:) = [];
    end
    Kp2.Kp = (zeros(length(ptime)));
    refT = (ptime);
    for k = 1:L
        Kp = (refT-(L)*Dt+(k-1)*Dt);
        Kp = bsxfun(gkern,Kp',refT);
        Kp2(k).Kp = (Kp);
        m.fullKp(1,k) = Kp2(k);
    end
    m.computeKp = 0;
    clear Kp Kp2;
end

X1 = m.X1;
tind = find(X1(pa(1),:));
tval = X(pa(1),:);
%target{1}(:,tind) = [];
ttime = ptime;
ttime(tind) = [];
tval(tind) = [];
B = sum(ttime<=(L*Dt));
N1 = size(ttime, 2);

% Build the matrix elements
Am = (zeros(N1-B, numregs*L));
% Building the design matrix
for k = 1:L
    Kp2 = m.fullKp(1,k);
    for j = 1:numregs
        %tSelect = repmat(Series{j}(2, :)',1,L0);
        rind = find(X1(pa(j),:));
        ySelect = (full(X(pa(j),:)'));
        refL = length(ySelect);
        tSelect = ptime;
        ySelect(rind) = [];
        tSelect(rind) = [];
        refind = 1:refL;
        remind = refind(~(ismember(refind,tind))); % setdiff(refind,tind);
        remind = union(1:remind(B+1)-1,tind);
        rind = refind(~(ismember(refind,rind)));
        remind = refind(~(ismember(refind,remind)));
        %Kp = Kp2(1).Kp;
        %    for i = (B+1):N1
        %bm(i-B) = Series{1}(1, i);
        % ti = ones(length(Series{j}(2, :)), 1)*((Series{1}(2, i) - (L)*Dt):Dt:(Series{1}(2, i)-Dt+Dt*params.AllowZeroLag));
        %ti = repmat((Series{1}(2, i) - (L)*Dt):Dt:(Series{1}(2, i)-Dt+Dt*params.AllowZeroLag),length(tSelect),1);
        %     Kp = (ttime(1, B+1:end)' - (L)*Dt)+(k-1)*Dt;
        switch krnl
            case 'Sinc'     % The sinc Kernel
                Kp = sinc((ti-tSelect)/SIG);
            case 'Dist'     % The Dist Kernel
                Kp = SIG./((ti-tSelect).^2);
            otherwise
                % tic;
                % Kp1 = bsxfun(gkern,Kp,tSelect);        % The Gaussian Kernel
                % toc
                %               Kp(:,rind) = [];
                %              Kp(remind,:) = [];
        end
        %    Am(:, ((j-1)*L+k)) = (Kp2(k).Kp(keepind,rind1)*ySelect)./sum(Kp2(k).Kp(keepind,rind1),2);
        Am(:, ((j-1)*L+k)) = (Kp2.Kp(remind,rind)*ySelect)./sum(Kp2.Kp(remind,rind),2);
        %            temp = (Kp*ySelect)./sum(Kp,2);
    end
    clear Kp2;
end
bm = (tval(1,B+1:N1)');

% Solving Lasso using a solver; here the 'GLMnet' package
opt = glmnetSet;
opt.lambda = lambda;
opt.nlambda = length(lambda);
opt.alpha = 1;
[nObs,nVars] = size(Am);
opt.penalty_factor = ones(nVars,1);
j= 1;

%   No sparsity constraint on autoregressive interactions for SCINGE
opt.penalty_factor(((j-1)*L+1):(j*L)) = 0;

fit = glmnet(Am, bm, params.family, opt);
w = fit.beta;

% Reformatting the output
count = 0; genes = []; areas = [];

%for_metrics.Am = Am;
%for_metrics.bm = bm;
%for_metrics.w = w;
for_metrics.a0 = fit.a0;
for_metrics.order = pa;
for_metrics.params = params;
p = params.p;
for ii = 1:size(w,2)
    result = zeros(numregs, L);
    if isempty(w)
        result = zeros(P);
    else
        for i = 1:numregs
            result(i, :) = w((i-1)*L0+1:i*L0,ii);
        end
    end
    P = eye(numregs);
    P = P(pa,:);
    result = P'*result;
    result = sum(result,2);
    ALasso = zeros(numregs,LX);
    for i = 1:numregs
        ALasso(i,p,j) = result(i,j);
    end
    outs{ii}.Adj_Matrix = outs{ii}.Adj_Matrix + sparse(ALasso);
    clear ALasso;
end
end
function Kp = gausskernel(x,y,SIG)
Kp = exp(-((x-y).^2)/SIG);
end