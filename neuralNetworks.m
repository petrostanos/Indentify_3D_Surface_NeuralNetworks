% create modular neural networks for surface
function [Networks,allNodes]=...
    neuralNetworks(all,allNodes,allNearPoints,hiddenLayerSize,trainFcn,step,threshold)
    % input and output data
    input=all{1}(:,1:8)';
    output=all{1}(:,9)';
    % find nearest training points
    trainingPoints=knnsearch(allNodes{1},allNodes{1}(1,:),'K',step,'Distance','seuclidean');
    % create neural network
    net=createNeuralNet(input,output,trainingPoints,hiddenLayerSize,trainFcn);
    % store points and neural network
    numberNetworks=1;
    Networks{numberNetworks}=net;
    allNodes{1}(trainingPoints,6)=numberNetworks; 
    allNodes{1}(trainingPoints,7)=1;
    testNetwork=numberNetworks;
    clear trainingPoints;
    % check points of samples separetely
    for i=1:size(allNodes,2)
        input=all{i}(:,1:8)'; output=all{i}(:,9)';
        for k=1:size(input,2)
            % check if a certain point is used for training neural networks
            if ~allNodes{i}(k,7)==1
                % test each points area of 9 points if is not in training data set
                points=allNearPoints{i}(k,:);
                estimate = net(input(:,points)); % take estimation
                performance = perform(net,estimate,output(:,points)); % measure perfomance
                % check if performance is under the threshold
                if performance>threshold
                    % check if other network can describe this point
                    for h=1:numberNetworks
                        testNet=Networks{h};
                        estimateTest = testNet(input(:,points));
                        performTest(h)= perform(testNet,estimateTest,output(:,points));
                    end
                    % perform new network
                    if min(performTest)>threshold
                        % find nearest training points
                        trainingPoints=knnsearch(allNodes{i},allNodes{i}(k,:),'K',step,'Distance','seuclidean');
                        % choose points
                        indexTrain=find(allNodes{i}(trainingPoints,7)~=1);
                        % create neural network
                        net=createNeuralNet(input,output,trainingPoints(indexTrain),hiddenLayerSize,trainFcn);
                        % store networks
                        numberNetworks=numberNetworks+1;
                        testNetwork=numberNetworks;
                        Networks{numberNetworks}=net;
                        % store training points
                        allNodes{i}(trainingPoints(indexTrain),6)=numberNetworks;
                        allNodes{i}(trainingPoints(indexTrain),7)=1;
                        clear trainingPoints indexTrain;
                    else
                        % continue to check with last good model
                        [~,idx]=min(performTest);
                        net=Networks{idx};
                        testNetwork=idx;
                    end
                else
                    % if performance is good, store certain point
                    allNodes{i}(k,6)=testNetwork;
                    allNodes{i}(k,7)=-1;
                end
            end
            fprintf('Check point %d of Cluster %d.\n',k,i);
        end
        clear input output;
    end
end