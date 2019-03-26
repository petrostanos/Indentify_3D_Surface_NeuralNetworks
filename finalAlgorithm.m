%% choose local directory to run algorithm
% cd '...';
%% clear all data
clear;
close all;
clc;
%% load data
% load('...')
% data=...; % choose point cloud
%% initialize parameters of algorithm
iterations=1; % choose segmentation - clusters of point cloud
amountPoints=200; % amount of divided data for training neural net
trainFcn = 'trainlm'; % Levenberg-Marquardt backpropagation.
hiddenLayerSize = 10; % number of hidden neurons
threshold=1e-04; % threshold of error perfomance of neural network
training=1; % is 1 when point Cloud is for training or 0 for checking
%% initialize parameters of node creation
% calculate the difference of values of x 
for j=1:size(data,1)-1
    st(j)=abs(data(j,1)-data(j+1,1));
end
step=mean(st)/2; % moving step in axes x 
dslim=0.005; % choose distance limit for next node
%% Create grid of nodes of point cloud which are indepedent from coordination system
% allNodes contains nodes of grid 
% allL is row data of first principal curvature
% allN is row data of second principal curvature
% allNearPoints is matrix with 9 neighbourhood nodes
% allDir is matrix with curvature directions
[allNodes,allL,allN,allNearPoints,allDir]=extractLN(data,iterations,step,dslim);
%% train neural network
if training==1
    trainingPoints=1:1:size(allL{1},1); % select each row of data
    inputL=allL{1}(:,1:8)'; % select 8 inputs of neural networks
    outputL=allL{1}(:,9)'; % select output of neural networs
    % creation neural network of first principal curvature
    netL=createNeuralNet(inputL,outputL,trainingPoints,hiddenLayerSize,trainFcn);
    inputN=allN{1}(:,1:8)'; % select 8 inputs of neural networks
    outputN=allN{1}(:,9)'; % select output of neural networs
    % creation neural network of second principal curvature
    netN=createNeuralNet(inputN,outputN,trainingPoints,hiddenLayerSize,trainFcn);
end
%% train and merge neural networks
% store models for principal curvatures
if training==1
    [mergeAllDataL,mergeNetworksforL,mergeAllPerformanceL,mergeAllDataN,mergeNetworksforN,mergeAllPerformanceN]=...
         trainTestMerge(allL,allN,allNodes,allNearPoints,hiddenLayerSize,trainFcn,amountPoints,threshold);
end
%% check surfaces with neural network models
if training==0
    for surfaces=1:size(networks,1) % for all networks
       % for first principal curvature
       inputL=allL{1}(:,1:8)'; outputL=allL{1}(:,9)'; % prepare data
       netL=networks{surfaces,1}; % choose network
       estimateL = netL(inputL); % take estimations
       % store difference of real and estimation value
       performance(surfaces,1) = perform(netL,estimateL,outputL);
       % for second principal curvature
       inputN=allN{1}(:,1:8)'; outputN=allN{1}(:,9)'; % prepare data
       netN=networks{surfaces,2}; % choose network
       estimateN = netN(inputN); % take estimations
       % store difference of real and estimation value
       performance(surfaces,2) = perform(netN,estimateN,outputN);
   end
end