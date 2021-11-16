function params = parseParams(Data,varargin)
for ii = 1:length(varargin)
    temp = varargin{ii};
    if numel(temp)>2
        if temp(1)=='-'
            while temp(1)=='-'
                temp = temp(2:end);
            end
            temp(find(temp=='-')) = '_';
            varargin{ii} = temp;
        end
    end
end
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

% Remove filesep from string check list
strchecklist = setdiff(['[\/?*''."<>|]'],filesep);
expected_family = {'gaussian','poisson'};
% Changed the conditions to accommodate command line calls to GLG_Instance.
validScalar = @(x) (isnumeric(x) && isscalar(x) && (x >= 0))||(isnumeric(str2num(x)) && isscalar(str2num(x)) && (str2num(x) >= 0));
validPos = @(x) all(isnumeric(x) & (x >= 0))||all(isnumeric(str2num(x)) & (str2num(x) >= 0));
validFile = @(x) isfilecomp(x);
validString = @(x) ischar(x) && isempty(regexp(x,strchecklist,'once'));
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
parse(p,Data,varargin{:});
params = p.Results;
params.lambda = stringcheck(params.lambda);
params.dT = stringcheck(params.dT);
params.num_lags = stringcheck(params.num_lags);
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

% Create new file for each job ID to avoid collisions when storage is shared
% between parallel jobs (separated valid file and temp file creation for
% this purpose)
if (exist([Data '.mat'], 'file') == 2)
    load([Data '.mat']);
elseif (exist(Data, 'file') == 2)
    load(Data);
end
X = sparse(X);
% Changed the creation of TempMat to load and save Data file in v7.3 to
% avoid lower version mat files causing error.
if exist('branches','var')&&exist('regix','var')
    save(['TempMat' '_' num2str(params.ID) '.mat'],'X','ptime','branches','regix','-v7.3');
elseif exist('branches','var')
    save(['TempMat' '_' num2str(params.ID) '.mat'],'X','ptime','branches','-v7.3');
elseif exist('regix','var')
    save(['TempMat' '_' num2str(params.ID) '.mat'],'X','ptime','regix','-v7.3');
else
    save(['TempMat' '_' num2str(params.ID) '.mat'],'X','ptime','-v7.3');
end
end

function y = isfilecomp(x)
    if (exist([x '.mat'], 'file') == 2)
        y = 1;
    elseif (exist(x, 'file') == 2)
        y = 1;
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
