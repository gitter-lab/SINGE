%% Simple example that runs SCINGE for two replicates of two hyperparameter settings
clear all;
close all;
clc;
addpath(genpath('.'));

%% Generate list of parameter combinations
param_list{1}.ID = 541;
param_list{1}.lambda = 0.01;
param_list{1}.dT = 10;
param_list{1}.num_lags = 5;
param_list{1}.kernel_width = 2;
param_list{1}.prob_zero_removal = 0;
param_list{1}.prob_remove_samples = 0.2;
param_list{1}.family = 'gaussian';
param_list{1}.date = '31-Jan-2019';

param_list{2}.ID = 542;
param_list{2}.lambda = 0.01;
param_list{2}.dT = 5;
param_list{2}.num_lags = 9;
param_list{2}.kernel_width = 4;
param_list{2}.prob_zero_removal = 0.2;
param_list{2}.prob_remove_samples = 0.1;
param_list{2}.family = 'gaussian';
param_list{2}.date = '24-Jan-2019';

%% Specify Path to Input data and path to Output folder, gene_list and number of subsampled replicates
Data = 'data1/X_SCODE_data.mat';
outdir = 'Output';
num_replicates = 2;
load('data1/tf.mat');
gene_list = tf;

%% Run SCINGE
[ranked_edges, gene_influence] = SCINGE(gene_list,Data,outdir,num_replicates,param_list);