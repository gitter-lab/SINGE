function [ranked_edges, gene_influence] = SINGE(Data,gene_list,outdir,hyperparameter_file)
% Standalone SINGE implementation. 
% Inputs:
% Data = string representing the path of mat file containing the expression
% data corresponding to above gene_list in the form of cell array X.
% gene_list = file path of N x 1 cell array with list of relevant genes in the data set
% outdir = directory path to store individual GLG test results before Borda
% aggregation
% hyperparameter_file = file path to text file containing all
% hyperparameters
SINGE_version = '0.5.1';
display(SINGE_version);

fid = fopen(hyperparameter_file);
arg = fgetl(fid);

%% Run SINGE GLG Tests for each hyperparameter combination in the file
while arg~=-1
    args = strsplit(arg);
	SINGE_GLG_Test(Data,'--outdir',outdir,args{:})
    arg = fgetl(fid);
end

%% Aggregate GLG Test Results
[ranked_edges, gene_influence] = SINGE_Aggregate(Data,gene_list,outdir);

