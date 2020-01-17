function [ranked_edges,gene_influence] = SINGE_Aggregate(Data,genefile,outdir)
% [ranked_edges,gene_influence] = SINGE_Aggregate(genefile,Data,outdir)
% Function to aggregate individual results 
% Inputs:
% Data = string representing the path of mat file containing the expression
% data corresponding to above gene_list in the form of cell array X.
% genefile = file path of N x 1 cell array with list of relevant genes in the data set
% outdir = directory path with individual GLG test results for Borda
% aggregation
% Outputs:
% ranked_edges = ranked list of gene interactions with corresponding SINGE scores
% gene_influence = ranked lists of regulators (genes) with corresponding SINGE influence
load(genefile);

Str = Data;
Str(Str=='.') = 'p';

lind = max(max(strfind(Str,filesep)),0);
if isempty(lind)
    lind = 0;
end
mind = length(Str);

Str = Str(lind+1:mind);
Agg = Modified_Borda_Aggregation(Str,outdir);

ranked_edges = adjmatrix2edgelist(Agg,gene_list);
[influence,ind] = sort(sum(Agg,2),'descend');
gene_influence = [cell2table(gene_list(ind)) array2table(influence)];
gene_influence.Properties.VariableNames{1} = 'Gene_Name';
ranked_edgesw = ranked_edges;
ranked_edgesw.SINGE_Score = floor(ranked_edgesw.SINGE_Score*10^5)/10^5;
gene_influencew = gene_influence;
gene_influencew.influence = floor(gene_influencew.influence*10^5)/10^5;
writetable(ranked_edgesw,fullfile(outdir,'SINGE_Ranked_Edge_List.txt'),'WriteVariableNames',true,'WriteRowNames',false,'Delimiter','\t');
writetable(gene_influencew,fullfile(outdir,'SINGE_Gene_Influence.txt'),'WriteVariableNames',true,'WriteRowNames',false,'Delimiter','\t');
