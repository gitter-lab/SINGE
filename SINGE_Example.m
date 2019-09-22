%% Simple example that runs SINGE for with default hyperparameter settings
clear all;
close all;
clc;
if ~isdeployed
    addpath(genpath('.'));
end

%% Specify path to input data and path to output directory, gene list, and hyperparameter file
data = 'data1/X_SCODE_data.mat';
outdir = 'Output';
gene_list = 'data1/tf.mat';
hyperparameter_file = 'default_hyperparameters.txt';

%% Run SINGE
SINGE(data,gene_list,outdir,hyperparameter_file);
