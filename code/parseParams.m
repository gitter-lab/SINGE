function params = parseParams(Data,varargin)
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
def_target1 = 1;
def_targetincr = 1;
%
expected_family = {'gaussian','poisson'};
% Changed the conditions to accommodate command line calls to GLG_Instance.
validScalar = @(x) (isnumeric(x) && isscalar(x) && (x >= 0))||(isnumeric(str2num(x)) && isscalar(str2num(x)) && (str2num(x) >= 0));
validPos = @(x) all(isnumeric(x) & (x >= 0))||all(isnumeric(str2num(x)) & (str2num(x) >= 0));
validFile = @(x) isfilecomp(x);
validString = @(x) ischar(x) && isempty(regexp(x,'[\/?*''."<>|]','once'));
validInteger = @(x) (~ischar(x)&&((x - floor(x)==0) && (x >= 0)))||((str2num(x) - floor(str2num(x))==0) && (str2num(x) >= 0));
validLags = @(x) (~ischar(x)&&((x - floor(x)==0) && (p.Results.dT*x)<100))||((str2num(x) - floor(str2num(x))==0) && (str2num(p.Results.dT)*str2num(x))<100);
validProb = @(x) (~ischar(x)&&(isnumeric(x) && isscalar(x) && (x >= 0) &&(x<1)))||((isnumeric(str2num(x)) && isscalar(str2num(x)) && (str2num(x) >= 0) &&(str2num(x)<1)));
validDate = @(x) any(ismember({datestr(datenum(x) ,['mm/dd/yyyy']) datestr(datenum(x))},x));
addRequired(p,'Data',validFile);
addParameter(p,'family',def_family,@(x) any(validatestring(x,expected_family)));
addParameter(p,'outdir',def_outdir,validString);
addParameter(p,'lambda',def_lambda,validPos);
addParameter(p,'dT',def_dT,validScalar);
addParameter(p,'num_lags',def_L,validLags);
addParameter(p,'kernel_width',def_width,validScalar);
addParameter(p,'prob_zero_removal',def_probzero,validProb);
addParameter(p,'prob_remove_samples',def_prob_remove_samples,validProb);
addParameter(p,'replicate',def_rep,validInteger);
addParameter(p,'ID',def_ID,validInteger);
addParameter(p,'date',def_date,validDate);
addParameter(p,'firsttarget',def_target1,validInteger);
addParameter(p,'targetincr',def_targetincr,validInteger);
parse(p,Data,varargin{:});
params = p.Results;
params.lambda = stringcheck(params.lambda);
params.dT = stringcheck(params.dT);
params.num_lags = stringcheck(params.num_lags);
params.firsttarget = stringcheck(params.firsttarget);
params.targetincr = stringcheck(params.targetincr);
params.replicate = stringcheck(params.replicate);
params.prob_zero_removal = stringcheck(params.prob_zero_removal);
params.prob_remove_samples = stringcheck(params.prob_remove_samples);
params.kernel_width = stringcheck(params.kernel_width);
params.ID = stringcheck(params.ID);

% Sort lambdas in descending order to optimize glmnet's progression through
% the lambdas using warm starts 
params.lambda = sort(params.lambda,'descend');
params.p1 = params.dT*params.num_lags;
params.DateNumber = datenum(params.date);
end

function y = isfilecomp(x)
    if (exist([x '.mat'], 'file') == 2)
        y = 1;
        copyfile([x '.mat'],'TempMat.mat');
    elseif (exist(x, 'file') == 2)
        y = 1;
        copyfile(x,'TempMat.mat');
    else
        y = 0;
    end
end

function y = stringcheck(x)
if isstr(x)
    y = str2num(x);
else
    y = x;
end
end