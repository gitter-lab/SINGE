function GLG_Instance(Data,varargin)
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
tic;
if isdeployed
    set(0,'DefaultFigureVisible','off');
end
resampling_method = {'holes';'burst'};
%outpath
load(params.Data);
X = normalizePseudotime(X);
filename = ['AdjMatrix_' params.Data];
filename = [filename '_ID_' num2str(params.ID)];
filename(filename=='.') = 'p';
filename(filename=='/') = '_';

randomizer = floor(params.DateNumber+params.lambda*1000+params.dT+params.p1+params.kernel_width*10+params.replicate)
%rng('default');
rand('seed',randomizer);
if params.prob_zero_removal~=0
    X = dropZeroSamples(params.prob_zero_removal, X);
end
if params.replicate>0
    X = dropSamples(params.prob_remove_samples,X);
end

Adj_Matrix = sparse(zeros(length(X)));

for irow = 1:1:length(X)
    [ALasso, for_metric] = run_iLasso_row(X,params,irow);
    Adj_Matrix = Adj_Matrix + sparse(sum(ALasso,3));
    runtime = toc;
    progress = (irow)/length(X)*100;
    s = sprintf(['%2.5g %% Progress in %5.5g seconds'],progress,runtime);
    disp(s);
end

runtime = toc
if params.replicate>0
    save(fullfile(params.outdir,[filename '_replicate_' num2str(params.replicate)]),'Adj_Matrix','varargin','params');
else
    save(fullfile(params.outdir,[filename]), 'Adj_Matrix','varargin','params');
end
fprintf('Intermediate file saved.\n')
if isdeployed
    quit;
end
end