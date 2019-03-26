% train neural network
% return network
function net=createNeuralNet(input,output,trainingPoints,hiddenLayerSize,trainFcn)
    net = fitnet(hiddenLayerSize,trainFcn);
    % division of data for Training, Validation, Testing
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;
    % Train the Neural Network
    [net,~] = train(net,input(:,trainingPoints),output(:,trainingPoints));
end