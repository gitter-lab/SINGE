%% Simple example that runs SINGE for two replicates of two hyperparameter settings
%% Derived from SINGE_Example.m
clear all;
close all;
clc;
if ~isdeployed
    addpath(genpath('.'));
end

%% Specify path to input data and path to output directory, gene list, and hyperparameter file
data = '../data1/X_SCODE_data.mat';
outdir = '../compiled_output';
gene_list = '../data1/tf.mat';
hyperparameter_file = 'example_hyperparameters.txt';

%% Run SINGE
SINGE(data,gene_list,outdir,hyperparameter_file);