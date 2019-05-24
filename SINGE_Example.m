%% Simple example that runs SCINGE for two replicates of two hyperparameter settings
clear all;
close all;
clc;
if ~isdeployed
    addpath(genpath('.'));
end

%% Import list of parameter combinations
fid = fopen('SINGE_params.cfg');
temp = fgetl(fid);
while any(temp~=-1)||isempty(temp)
    if ~isempty(temp)
        temp = strsplit(temp);
        pid = str2num(temp{1});
        pname = temp{2};
        pval = temp{3};
        if isnumeric(str2num(pval))&&~isempty(str2num(pval))
            pval = str2num(pval);
        else
            ind = find(pval=='''');
            pval(ind) = [];
        end
        param_list{pid}.(pname) = pval;
    end
temp = fgetl(fid);
end
%% Specify Path to Input data and path to Output folder, gene_list and number of subsampled replicates
fid = fopen('SINGE_IO.cfg');
temp = fgetl(fid);
while any(temp~=-1)||isempty(temp)
    if ~isempty(temp)
        temp = strsplit(temp);
        pname = temp{1};
        pval = temp{2};
        if isnumeric(str2num(pval))&&~isempty(str2num(pval))
            pval = str2num(pval);
        else
            ind = find(pval=='''');
            pval(ind) = [];
        end
        IO.(pname) = pval;
    end
temp = fgetl(fid);
end
%% Run SINGE
[ranked_edges, gene_influence] = SINGE(IO.gene_list,IO.Data,IO.outdir,IO.num_replicates,param_list);
