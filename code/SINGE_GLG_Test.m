function SINGE_GLG_Test(Data,varargin)
% GLG_Instance(ordered_expr_data, family, lambda, dt, window_length, kernel_width, replicate, ,
% prob_zero_removal, date)
% Runs Generalized Lasso Granger for one hyperparameter set with optional
% subsampling and zero-handling.
%
tic
%%% InputParser
params = parseParams(Data,varargin{:})
mkdir(params.outdir)
%%% End InputParser
if isdeployed
    set(0,'DefaultFigureVisible','off');
end

% Use a temporary matfile to track intermediate state
% Create new file for each job ID to avoid bugs when storage is shared
% between parallel jobs
m = matfile(['TempMat' '_' num2str(params.ID)],'Writable',true);

if ismember('branches',who(m))
    params.branching = 1;
    branches = m.branches;
    n_branches = min(size(branches));
else 
    params.branching = 0;
    n_branches = 1;
end
ptime = m.ptime;
m.computeKp = 1;
if ptime(end)~=100
    ptime = ptime/ptime(end)*100;
    m.ptime = ptime;
end
[LX,WX] = size(m,'X');
params.LX = LX;
params.WX = WX;

% Even if an index of regulators is specified in the input file
% we create a square adjacency matrix
Adj_Matrix = sparse(zeros(LX));
% To improve efficiency, we perform GLG tests for all lambda values at once
% (uses glmnet's warm start functionality). The following lines create
% multiple filenames for storing each GLG output.

% SINGE v0.5.0 feature: If multiple branches exist in the dataset, as denoted 
% by the presence of the 'branches' variable in the Data file, then generate an 
% output matrix corresponding to each branch
n_lambda = length(params.lambda);
for jj = 1:n_branches
    for ii = 1:n_lambda
        kk = (jj-1)*n_lambda+ii;
        filename{kk} = ['AdjMatrix_' params.Data];
        if params.branching==1
            filename{kk} = [filename{kk} '_ID_' num2str(params.ID) 'p' num2str(jj) '_lambda_' num2str(params.lambda(ii)) '_replicate_' num2str(params.replicate)];
        else
            filename{kk} = [filename{kk} '_ID_' num2str(params.ID) '_lambda_' num2str(params.lambda(ii)) '_replicate_' num2str(params.replicate)];
        end
        filename{kk}(filename{kk}=='.') = 'p';
        filename{kk}(filename{kk}=='/') = '_';
        filename{kk} = fullfile(params.outdir,filename{kk});
        save(filename{kk},'Adj_Matrix','varargin','params','-v7.3');
        outs{kk} = matfile(filename{kk},'Writable',true);
    end
end
randomizer = floor(params.DateNumber+sum(params.lambda)*1000+params.dT+params.p1+params.kernel_width*10+params.replicate)
rand('seed',randomizer);
if params.prob_zero_removal~=0
   m.Xdrop = dropZeroSamples(params.prob_zero_removal, m);
else
   m.Xdrop = false(size(m.X));
end
if params.replicate>0
   m.Xdrop = dropSamples(params.prob_remove_samples,m);
end
if ismember('targetix',who(m))
    targetix = m.targetix;
    if iscolumn(targetix)
        targetix = targetix';
    elseif ~isrow(targetix)
            display('Error: Target indices must be a vector');
    end
    numtargets = length(targetix)
else
    targetix = 1:LX;
    numtargets = LX
end

lastprogress = 0;
for irow = targetix
   [for_metric] = run_iLasso_row(m,outs,params,irow);
   runtime = toc;
   progress = (irow)/LX*100;
   if (progress-lastprogress)>=10
        s = sprintf(['%2.5g %% Progress in %5.5g seconds'],progress,runtime);
        disp(s);
        lastprogress = progress;
   end
end
runtime = toc

% File saving moved to iLasso_for_SINGE using matfile feature
fprintf('Intermediate files saved.\n')
delete(['TempMat' '_' num2str(params.ID) '.mat']);
end
