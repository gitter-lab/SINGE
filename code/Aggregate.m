function Aggregate(genefile,Data,outdir)
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
ranked_edgesw.SCINGE_Score = floor(ranked_edgesw.SCINGE_Score*10^5)/10^5;
gene_influencew = gene_influence;
gene_influencew.influence = floor(gene_influencew.influence*10^5)/10^5;
writetable(ranked_edgesw,fullfile(outdir,'SCINGE_Ranked_Edge_List.txt'),'WriteVariableNames',true,'WriteRowNames',false,'Delimiter','\t');
writetable(gene_influencew,fullfile(outdir,'SCINGE_Gene_Influence.txt'),'WriteVariableNames',true,'WriteRowNames',false,'Delimiter','\t');