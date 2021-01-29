function params = text2SingeInput(varargin)
%parse input to remove hyphens
for ii = 1:length(varargin)
    temp = cell2mat(varargin{ii});
    if numel(temp)>2
        if temp(1)=='-'
            while temp(1)=='-'
                temp = temp(2:end);
            end
            temp(find(temp=='-')) = '_';
        end
    end
    varargin{ii} = temp;
end
%parse input for expected file names.
p = inputParser;
def_dir = '.';
def_exprs = 'exprs.txt';
def_ptime = 'pseudotime.txt';
def_branches = 'NA';
def_out = 'X_Singe.mat';

validFile = @(x) isfilecomp(x);
validString = @(x) ischar(x) && isempty(regexp(x,'[?*''."<>|]','once'));


addParameter(p,'dir',def_dir,validString);
addParameter(p,'exprs',def_exprs);
addParameter(p,'ptime',def_ptime);
addParameter(p,'branches',def_branches);
addParameter(p,'outfile',def_out);

parse(p,varargin{:});
pr = p.Results;
testFiles = checkFilesExist(pr);
if testFiles.code>0
    if (testFiles.code==2) && (pr.branches=="NA")
        warning("No file provided with branching info. Assuming linear trajectory.")
    else
        error(testFiles);
    end
end

X = importdata(fullfile(pr.dir,pr.exprs));
gene_list = X.textdata(2:end);
X = sparse(X.data);
ptime = importdata(fullfile(pr.dir,pr.ptime));
ptime = ptime.data;

if (pr.branches~="NA")
    branches = importdata(fullfile(pr.dir,pr.branches));
    branches = branches.data;
    checkDataCompatibility(X,ptime,branches);
    save(fullfile(pr.dir,pr.outfile), 'X', 'ptime', 'branches', 'gene_list', '-v7.3');
else
    save(fullfile(pr.dir,pr.outfile), 'X', 'ptime', 'gene_list', '-v7.3');
end

%sanity checks and data modification
if ~isrow(ptime); ptime = ptime'; end
if any(size(X)~=length(ptime)) 
    if (size(X,1)==length(ptime))
        X = X';
    end
else
	error("The size of the expression matrix and pseudotime vector do not match.");
end
if any(size(X)~=length(ptime)) 
    if (size(X,1)==length(ptime))
        X = X';
    end
else
	error("The size of the expression matrix and pseudotime vector do not match.");
end

if any(isinf(ptime)|isnan(ptime)) 
	warning("Warning: Removing Inf and NaN values of pseudotime");
    ind = find(~isinf(ptime)&~isnan(ptime));
    ptime = ptime(ind);
    X = X(:,ind);
end
[ptime,od] = sort(ptime);
X = X(:,od);
function y = isfilecomp(x)
if (exist(x, 'file') == 2)
    y = 1;
elseif (exist([x '.txt'], 'file') == 2)
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
function errStruct = checkFilesExist(pr)
errStruct.code = 0;
checkFilesExist = zeros(1,4);
checkFilesExist(1) = exist(pr.dir,'dir');
if checkFilesExist(1)==0
    errStruct.code = 1;
    errStruct.identifier = "SINGE:textSingeInput:E1";
    errStruct.message = ['Directory ' pr.dir{:} ' does not exist. Please check your inputs.'];
    return;
end
checkFilesExist(2) = isfilecomp(fullfile(pr.dir,pr.exprs));
if checkFilesExist(2)==0
    errStruct.code = 2;
    errStruct.identifier = "SINGE:textSingeInput:E2";
    errStruct.message = ['File ' pr.exprs ' does not exist in directory' pr.dir ': Please check your inputs.'];
    return;
end
checkFilesExist(3) = isfilecomp(fullfile(pr.dir,pr.ptime));
if checkFilesExist(3)==0
    errStruct.code = 1;
    errStruct.identifier = "SINGE:textSingeInput:E3";
    errStruct.message = ['File ' pr.ptime ' does not exist in directory' pr.dir ': Please check your inputs.'];
    return;
end
checkFilesExist(4) = isfilecomp(fullfile(pr.dir,pr.branches));
if checkFilesExist(4)==0
    errStruct.code = 2;
    errStruct.identifier = "SINGE:textSingeInput:W4";
    errStruct.state = 'on';
    errStruct.message = ['File ' pr.branches ' does not exist in directory' pr.dir ': Assuming linear trajectory.'];
end
end
function errs = checDataCompatibility(varargin)
    X = varargin{1};
    ptime = varargin{2};
    if varargin>2
        branches = varargin{3};
    end
end