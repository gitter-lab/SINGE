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
tic;
if isdeployed
    set(0,'DefaultFigureVisible','off');
end
resampling_method = {'holes';'burst'};
%outpath
m = matfile('TempMat','Writable',true);
ptime = m.ptime;
m.computeKp = 1;
if ptime(end)~=100
    ptime = ptime/ptime(end)*100;
    m.ptime = ptime;
end
[LX,WX] = size(m,'X');
% Check if an index of regulators is specified in the input file. If yes,
% then the Adj_Matrix is of dimensions LR x LX.
if ismember('regix',who(m))
    LR = length(m,'regix');
else
    LR = LX;
end
Adj_Matrix = sparse(zeros(LR,LX));
% To improve efficiency, we perform GLG tests for all lambda values at once
% (uses glmnet's warm start functionality). The following lines create
% multiple filenames for storing each GLG output.
for ii = 1:length(params.lambda)
    filename{ii} = ['AdjMatrix_' params.Data];
    filename{ii} = [filename{ii} '_ID_' num2str(params.ID) '_lambda_' num2str(params.lambda(ii)) '_replicate_' num2str(params.replicate)];
    filename{ii}(filename{ii}=='.') = 'p';
    filename{ii}(filename{ii}=='/') = '_';
    filename{ii} = fullfile(params.outdir,filename{ii});
    save(filename{ii},'Adj_Matrix','varargin','params','-v7.3');
    outs{ii} = matfile(filename{ii},'Writable',true);
end
randomizer = floor(params.DateNumber+sum(params.lambda)*1000+params.dT+params.p1+params.kernel_width*10+params.replicate)
%rng('default');
rand('seed',randomizer);
if params.prob_zero_removal~=0
   m.Xdrop = dropZeroSamples(params.prob_zero_removal, m);
else
    m.Xdrop = false(size(m.X));
end
if params.replicate>0
   m.Xdrop = dropSamples(params.prob_remove_samples,m);
end

lastprogress = 0;
for irow = 1:1:LX
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
delete TempMat.mat
end