function tftable = adjmatrix2edgelist(metric,tf)
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
tftable = cell(length(smets),3);
ind = [];
for ii = 1:length(smets)
    tftable(ii,:) = {tf(rrows(sind(ii))),tf(rcols(sind(ii))),metric(sind(ii))};
    if tftable{ii,3}>0
        ind = [ind ii];
    end
end
tftable = cell2table(tftable(ind,:));
tftable.Properties.VariableNames = {'Regulator', 'Target', 'SINGE_Score'};