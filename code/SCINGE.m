function [ranked_edges, gene_influence] = SCINGE(gene_list,Data,outdir,num_replicates,param_list)
% [ranked_edges, gene_influence] = SCINGE(gene_list,Data,outdir,num_replicates,param_list)
% Standalone SCINGE implementation. 
% Inputs:
% gene_list = N x 1 cell array with list of relevant genes in the data set
% Data = string representing the path of mat file containing the expression
% data in the form of cell array X.
% corresponding to above gene_list
% outdir = directory path to store individual GLG test results before Borda
% aggregation
% num_replicates = number of subsampled replicates (global SCINGE parameter)
% param_list = list of hyperparameter combinations for individual GLG tests
for rep = 1:num_replicates
    for ii = 1:length(param_list)
        GLG_Instance(Data,'lambda',param_list{ii}.lambda,'dT',param_list{ii}.dT,'num_lags',param_list{ii}.num_lags,'kernel_width',param_list{ii}.kernel_width,'prob_zero_removal',param_list{ii}.prob_zero_removal,'replicate',rep,'ID',param_list{ii}.ID,'outdir',outdir);
    end
end
Str = Data;
Str(Str=='.') = 'p';

lind = max(max(strfind(Str,filesep)),0);
mind = length(Str);
if isempty(mind)||(mind<lind)
    mind = length(Str);
end
Str = Str(lind+1:mind);
Agg = Modified_Borda_Aggregation(Str,outdir);

ranked_edges = adjmatrix2edgelist(Agg,gene_list);
[influence,ind] = sort(sum(Agg,2),'descend');
gene_influence = [cell2table(gene_list(ind)) array2table(influence)];
gene_influence.Properties.VariableNames{1} = 'Gene_Name';