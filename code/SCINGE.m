function [ranked_edges, gene_influence] = SCINGE(gene_list,Data,outdir,num_replicates,param_list)
% [ranked_edges, gene_influence] = SCINGE(gene_list,Data,outdir,num_replicates,param_list)
% Standalone SCINGE implementation. 
% Inputs:
% gene_list = N x 1 cell array with list of relevant genes in the data set
% Data = string representing the path of mat file containing the expression
% data corresponding to above gene_list in the form of cell array X.
% outdir = directory path to store individual GLG test results before Borda
% aggregation
% num_replicates = number of subsampled replicates (global SCINGE parameter)
% param_list = list of hyperparameter combinations for individual GLG tests
% Outputs:
% ranked_edges = ranked list of gene interactions with corresponding SCINGE scores
% gene_influence = ranked lists of regulators (genes) with corresponding SCINGE influence
SCINGE_version = '0.2.0';
display(SCINGE_version);
for rep = 1:num_replicates
    for ii = 1:length(param_list)
        GLG_Instance(Data,'--lambda',param_list{ii}.lambda,'--dT',param_list{ii}.dT,'--num_lags',param_list{ii}.num_lags,'--kernel_width',param_list{ii}.kernel_width,'--prob_zero_removal',param_list{ii}.prob_zero_removal,'--replicate',rep,'--ID',param_list{ii}.ID,'--outdir',outdir,'--family',param_list{ii}.family,'--prob_remove_samples',param_list{ii}.prob_remove_samples,'--date',param_list{ii}.date);
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
ranked_edgesw = ranked_edges;
ranked_edgesw.SCINGE_Score = floor(ranked_edgesw.SCINGE_Score*10^5)/10^5;
gene_influencew = gene_influence;
gene_influencew.influence = floor(gene_influencew.influence*10^5)/10^5;
writetable(ranked_edgesw,fullfile(outdir,'SCINGE_Ranked_Edge_List.txt'),'WriteVariableNames',true,'WriteRowNames',false,'Delimiter','\t');
writetable(gene_influencew,fullfile(outdir,'SCINGE_Gene_Influence.txt'),'WriteVariableNames',true,'WriteRowNames',false,'Delimiter','\t');
