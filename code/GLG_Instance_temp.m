function GLG_Instance(Data,varargin)
% GLG_Instance(ordered_expr_data, family, lambda, dt, window_length, kernel_width, replicate, ,
% prob_zero_removal, date)
% Runs Generalized Lasso Granger for one hyperparameter set with optional
% subsampling and zero-handling.
%
tic
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
def_date = date;
%
for ii = 1:length(varargin)
    if ischar(varargin{ii})&&~isempty(str2num(varargin{ii}))&&isempty(regexp(varargin{ii},'[\/-]','once'))
        varargin{ii} = str2num(varargin{ii});
    end
end
expected_family = {'gaussian','poisson'};
validScalar = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
validFile = @(x) isfilecomp(x);
validString = @(x) ischar(x) && isempty(regexp(x,'[\/?*''."<>|]','once'));
validInteger = @(x) (x - floor(x)==0) && (x >= 0);
validLags = @(x) (x - floor(x)==0) && (p.Results.dT*x)<100;
validProb = @(x) isnumeric(x) && isscalar(x) && (x >= 0) &&(x<1);
validDate = @(x) any(ismember({datestr(datenum(x) ,['mm/dd/yyyy']) datestr(datenum(x))},x));
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
addParameter(p,'date',def_date,validDate);
parse(p,Data,varargin{:});
params = p.Results;
params.p1 = p.Results.dT*p.Results.num_lags;
params.DateNumber = datenum(params.date);
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

function y = isfilecomp(x)
if verLessThan('matlab','9.3')
    if (exist([x '.mat'], 'file') == 2)||(exist(x, 'file') == 2)
        y = 1;
    else
        y = 0;
    end
else
    if (isfile([x '.mat'])||isfile(x))
        y = 1;
    else
        y = 0;
    end
end
end