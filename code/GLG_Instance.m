function GLG_Instance(Data,varargin)
% GLG_Instance(ordered_expr_data, family, lambda, dt, window_length, kernel_width, replicate, ,
% prob_zero_removal, date)
% Runs Generalized Lasso Granger for one hyperparameter set with optional
% subsampling and zero-handling.
% 
tic
fprintf('Number of arguments: %d\n',nargin)
celldisp(varargin)
%%% InputParser
p = inputParser;
def_lambda = 0.01;
def_dT = 1;
def_rep = 0;
def_width = 2;
def_probzero = 0;
def_family = 'gaussian';
def_L = 15;
def_ID = 0;
def_outdir = 'Output';
def_prob_remove_samples = 0.2;
% 
expected_family = {'gaussian','poisson'};
validScalar = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
validFile = @(x) isfile([x '.mat']);
validString = @(x) ischar(x) && isempty(regexp(x,'[\/?*''."<>|]','once'));
validInteger = @(x) (x - floor(x)==0) && (x >= 0);
validLags = @(x) (x - floor(x)==0) && (p.Results.dT*x)<100;
validProb = @(x) isnumeric(x) && isscalar(x) && (x >= 0) &&(x<1);
addRequired(p,'Data',validFile);
addParameter(p,'family',def_family,@(x) any(validatestring(x,expected_family)));
addParameter(p,'outdir',def_outdir,validString);
addParameter(p,'lambda',def_lambda,validScalar);
addParameter(p,'dT',def_dT,validScalar);
addParameter(p,'num_lags',def_L,validLags);
addParameter(p,'kernel_width',def_width,validScalar);
addParameter(p,'prob_zero_removal',def_probzero,validProb);
addParameter(p,'prob_remove_samples',def_prob_remove_samples,validProb);
addParameter(p,'replicate',def_rep,validInteger);
addParameter(p,'ID',def_ID,validInteger);
parse(p,Data,varargin{:});
params = p.Results;
params.p1 = p.Results.dT*p.Results.num_lags;
params.DateNumber = datenum(date);
mkdir(params.outdir)
%%% End InputParser
if 0
if nargin==0
    params.lambda = 0.01;
    params.dT = 1;
    params.p1 = 21;
    params.resampling = 1;
    a = datestr(date,23);
    a(find(a=='/'))=[];
    outpath = ['results/' a];
    data_file = 'X_Monocle.mat';
    params.penalty = 1;
else
%    mode = str2num(varargin{6});
    data_file = varargin{1}
    if nargin>1
        params.family = (varargin{2});
    else
        params.family = 'gaussian';
    end
    params.lambda = str2num(varargin{2});
    params.dT = str2num(varargin{3});
    params.p1 = str2num(varargin{4});
    params.kernel_width = str2num(varargin{5});
   
    if nargin>5
        params.bootstrap = str2num(varargin{6});
    else
        params.bootstrap = 0;
    end
    
   
    
    if nargin>7
        params.dropZeros = str2num(varargin{8});
    else
        params.dropZeros = 0;
    end
    
    if nargin>8
        params.date = str2num(varargin{9});
    else
        params.date = 0;
    end
end
end
% a = datestr(date,23);
%    a(find(a=='/'))=[];
%    outpath = ['results/' a];
tic;
%print_version
set(0,'DefaultFigureVisible','off');
resampling_method = {'holes';'burst'};
%outpath
load(params.Data);
X = normalizePseudotime(X);
filename = ['AdjMatrix_' params.Data];
filename = [filename '_ID_' num2str(params.ID)];
filename(filename=='.') = 'p';
filename(filename=='/') = '_';
%filename = [outpath '/testALasso_' num2str(mode) '.mat']
%addpath(genpath('mvgc_v1.0'));
%addpath(genpath('glmnet_matlab'));
%mvgc_demo;
%X = X(1:400);
%mkdir('.',filename);
Xpath = ['xdata' ];
if ~exist(Xpath)
    save(Xpath,'X', 'params');
end
randomizer = floor(params.DateNumber+params.lambda*1000+params.dT+params.p1+params.kernel_width*10+params.replicate)
%rng('default');
rand('seed',randomizer);
if params.prob_zero_removal~=0
    X = dropZeroSamples(params.prob_zero_removal, X);
end
if params.replicate>0
    X = dropSamples(params.prob_remove_samples,X);
end

ALTboot = sparse(zeros(length(X)));    

for irow = 1:1:length(X)
    [ALasso,bic, for_metric] = run_iLasso_row(X,params,irow);
    ALTboot = ALTboot + sparse(sum(ALasso,3));
    runtime = toc;
    progress = (irow)/length(X)*100;
    s = sprintf(['%2.5g %% Progress in %5.5g seconds'],progress,runtime);
    disp(s);
end

runtime = toc
Adj_Matrix = ALTboot;
%save([filename '_row_' num2str(rownum)],'ALTboot', 'ALTneutral','ALTdown','ALasso','varargin','Smoothed','genes','rownum','metrics','bic','for_metric');
if params.replicate>0
    save(fullfile(params.outdir,[filename '_replicate_' num2str(params.replicate)]),'Adj_Matrix','varargin','params');
else
    save(fullfile(params.outdir,[filename '_replicate_' num2str(params.replicate)]), 'Adj_Matrix','varargin','params');
end
%save ALassotest ALasso;
%Atemp = ALasso(:,:);
fprintf('file saved')
if isdeployed
    quit;
end
