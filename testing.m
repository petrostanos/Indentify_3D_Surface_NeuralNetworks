% return data and performance of neural networks
function [allData,allPerformance]=testing(networks,all,allNearPoints,nodes)
    % for curvature quantity
    for k=1:size(all,2)
        for j=1:size(networks,2)
            net=networks{j};
            estimate = net(all{k}(:,1:8)');
            for i=1:size(all{k}(:,1:8)',2)
                performance{k}(i,j) = mean((estimate(1,allNearPoints{k}(i,:))-all{k}(allNearPoints{k}(i,:),9)').^2);
            end
            clear estimate;
        end
    end
    allPerformance=[];
    for i=1:size(performance,2)
        allPerformance=[allPerformance;performance{i}];
    end
    % % store each model fit to each point
    for i=1:size(performance,2)
        for j=1:size(performance{i},1)
            if ~nodes{i}(j,6)==0
                [minmin,idx]=min(performance{i}(j,:));
                nodes{i}(j,8:10)=[idx minmin performance{i}(j,nodes{i}(j,6))];
            end
        end
    end
    allData=[];
    for i=1:size(nodes,2)
        allData=[allData;nodes{i}];
    end
end