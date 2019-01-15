addpath(genpath('.'));
param_list{1}.lambda = 0.01;
param_list{1}.dT = 10;
param_list{1}.num_lags = 5;
param_list{1}.kernel_width = 2;
param_list{1}.prob_zero_removal = 0.1;
param_list{1}.family = 'gaussian';
param_list{1}.ID = 541;

param_list{2}.lambda = 0.01;
param_list{2}.dT = 5;
param_list{2}.num_lags = 9;
param_list{2}.kernel_width = 4;
param_list{2}.prob_zero_removal = 0;
param_list{2}.family = 'gaussian';
param_list{2}.ID = 542;

Data = 'data1/X_SCODE_data';
outdir = 'Output';
num_replicates = 2;
load('data1/tf.mat');
gene_list = tf;

ranked_edges = SCINGE(Data,outdir,num_replicates,gene_list,param_list);