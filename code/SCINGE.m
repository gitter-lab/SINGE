function [ranked_edges, gene_influence] = SCINGE(Data,outdir,num_replicates,gene_list,param_list)

for rep = 1:num_replicates
    for ii = 1:length(param_list)
        GLG_Instance(Data,'lambda',param_list{ii}.lambda,'dT',param_list{ii}.dT,'num_lags',param_list{ii}.num_lags,'kernel_width',param_list{ii}.kernel_width,'prob_zero_removal',param_list{ii}.prob_zero_removal,'replicate',rep,'ID',param_list{ii}.ID,'outdir',outdir);
    end
end
lind = max(strfind(Data,filesep));
mind = min(max(strfind(Data,'.')),length(Data));
if isempty(mind)||(mind<lind)
    mind = length(Data);
end
Str = Data(lind+1:mind);
Agg = Modified_Borda_Aggregation(Str,outdir);

ranked_edges = adjmatrix2edgelist(Agg,gene_list);
[influence,ind] = sort(sum(Agg,2),'descend');
gene_influence = [cell2table(gene_list(ind)) array2table(influence)];
gene_influence.Properties.VariableNames{1} = 'Gene_Name';