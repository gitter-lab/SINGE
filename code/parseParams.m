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
%
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
end

function y = isfilecomp(x)
    if (exist([x '.mat'], 'file') == 2)||(exist(x, 'file') == 2)
        y = 1;
    else
        y = 0;
    end
end