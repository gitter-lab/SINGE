%% Simple example that runs SINGE for two replicates of two hyperparameter settings
clear all;
close all;
clc;
if ~isdeployed
    addpath(genpath('.'));
end

%% Specify Path to Input data and path to Output folder, gene_list and hyperparameter file
Data = 'data1/X_SCODE_data.mat';
outdir = 'Output';
gene_list = 'data1/tf.mat';
hyperparameter_file = 'default_hyperparameters.txt';

%% Run SINGE
SINGE(Data,gene_list,outdir,hyperparameter_file);