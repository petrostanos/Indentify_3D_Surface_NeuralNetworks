% returen merged neural networks and nodes
function [mergeNetworks,nodes]=mergeNetworks(allData,networks,nodes)
    allTesting=allData(allData(:,7)==-1,:);
    for i=1:size(networks,2)
        for j=1:size(networks,2)
            allSum(i,j)=sum(allTesting(:,6)==i & allTesting(:,8)==j);
        end
    end
    % merge networks
    for i=1:size(allSum,1)
        if allSum(i,i)==max(allSum(i,:))
            mergeMatrix(i,1)=i;
            mergeMatrix(i,2)=i;
        else
            [~,ind]=max(allSum(i,:));
            mergeMatrix(i,1)=i;
            mergeMatrix(i,2)=ind;
            for j=1:size(nodes,2)
                nodes{j}(nodes{j}(:,6)==i,6)=ind;
            end
        end
    end
    mergeNet=unique(mergeMatrix(:,2));
    for i=1:size(nodes,2)
        for j=1:size(nodes{i},1)
            if ~nodes{i}(j,6)==0
                indice=find(mergeNet==nodes{i}(j,6));
                nodes{i}(j,6)=indice;
            end
        end
    end
    for i=1:size(mergeNet,1)
        mergeNetworks{i}=networks{mergeNet(i)};
    end
end