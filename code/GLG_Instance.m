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
m = matfile('TempMat','Writable',true);
ptime = m.ptime;
m.computeKp = 1;
if ptime(end)~=100
    ptime = ptime/ptime(end)*100;
    m.ptime = ptime;
end
[LX,WX] = size(m,'X');
if ismember('regix',who(m))
    LR = length(m,'regix');
else
    LR = LX;
end
Adj_Matrix = sparse(zeros(LR,LX));
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
   m.X1 = dropZeroSamples(params.prob_zero_removal, m);
else
    m.X1 = false(size(m.X));
end
if params.replicate>0
   m.X1 = dropSamples(params.prob_remove_samples,m);
end


for irow = 1:1:LX
    [for_metric] = run_iLasso_row(m,outs,params,irow);
    %Adj_Matrix = Adj_Matrix + sparse(sum(ALasso,3));
    runtime = toc;
    progress = (irow)/LX*100;
    s = sprintf(['%2.5g %% Progress in %5.5g seconds'],progress,runtime);
    disp(s);
end

runtime = toc
% File saving moved to iLasso_for_SINGE using matfile feature
fprintf('Intermediate files saved.\n')
delete TempMat.mat
end