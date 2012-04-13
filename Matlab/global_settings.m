%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Global setup file   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
clc; 

global THESIS_PATH; 
global OUTPUT_PATH; 

% set this path to local thesis directory
THESIS_PATH = 'D:\Work\School\Thesis\';
% set this path to local output directory within the thesis directory
OUTPUT_PATH = [THESIS_PATH 'Output\']; 

addpath(genpath(THESIS_PATH)); 

cd(THESIS_PATH); 