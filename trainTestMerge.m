% return merged networks, data, performance
function [mergeAllDataL,mergeNetworksforL,mergeAllPerformanceL,mergeAllDataN,mergeNetworksforN,mergeAllPerformanceN]=...
         trainTestMerge(allL,allN,allNodes,allNearPoints,hiddenLayerSize,trainFcn,amountPoints,threshold)
    %% train neural networks   
    [NetworksofL,nodesforL]=neuralNetworks(allL,allNodes,allNearPoints,hiddenLayerSize,...
        trainFcn,amountPoints,threshold);
    [NetworksofN,nodesforN]=neuralNetworks(allN,allNodes,allNearPoints,hiddenLayerSize,...
        trainFcn,amountPoints,threshold);
    %% test models
    [allDataL,allPerformanceL]=testing(NetworksofL,allL,allNearPoints,nodesforL);
    [allDataN,allPerformanceN]=testing(NetworksofN,allN,allNearPoints,nodesforN);
    %% merge models
    % for L curvature
    [mergeNetworksforL,mergeNodesforL]=mergeNetworks(allDataL,NetworksofL,nodesforL);
    [mergeAllDataL,mergeAllPerformanceL]=testing(mergeNetworksforL,allL,allNearPoints,mergeNodesforL);
    % for N curvature
    [mergeNetworksforN,mergeNodesforN]=mergeNetworks(allDataN,NetworksofN,nodesforN);
    [mergeAllDataN,mergeAllPerformanceN]=testing(mergeNetworksforN,allN,allNearPoints,mergeNodesforN);
    
end