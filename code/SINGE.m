function [ranked_edges, gene_influence] = SINGE(Data,gene_list,outdir,hyperparameter_file)
% [ranked_edges, gene_influence] = SINGE(gene_list,Data,outdir,num_replicates,param_list)
% Standalone SINGE implementation. 
% Inputs:
% gene_list = file path of N x 1 cell array with list of relevant genes in the data set
% Data = string representing the path of mat file containing the expression
% data corresponding to above gene_list in the form of cell array X.
% outdir = directory path to store individual GLG test results before Borda
% aggregation
% hyperparameter_file = file path to text file containing all
% hyperparameters
SINGE_version = '0.3.0';
display(SINGE_version);
fid = fopen(hyperparameter_file);
arg = fgetl(fid);
%% Run SINGE GLG Tests
while arg~=-1
    args = strsplit(arg);
	SINGE_GLG_Test(Data,args{:})
    arg = fgetl(fid);
end
%% Aggregate GLG Test Results

[ranked_edges, gene_influence] = SINGE_Aggregate(gene_list,Data,outdir);

