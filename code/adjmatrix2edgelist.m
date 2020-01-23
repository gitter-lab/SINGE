function gene_table = adjmatrix2edgelist(metric,gene_list)
absmetric = abs(metric);
L = length(metric);
rowind = repmat([1:L]',1,L);
rrows = reshape(rowind,L*L,1);
rowind = repmat([1:L]',1,L);
colind = rowind';
rrows = reshape(rowind,L*L,1);
rcols = reshape(colind,L*L,1);

rmet = reshape(absmetric,L*L,1);
[smets,sind] = sort(rmet,'descend');
gene_table = cell(length(smets),3);
ind = [];
for ii = 1:length(smets)
    gene_table(ii,:) = {gene_list(rrows(sind(ii))),gene_list(rcols(sind(ii))),metric(sind(ii))};
    if gene_table{ii,3}>0
        ind = [ind ii];
    end
end
gene_table = cell2table(gene_table(ind,:));
gene_table.Properties.VariableNames = {'Regulator', 'Target', 'SINGE_Score'};