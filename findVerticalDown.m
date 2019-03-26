% compute next nodes in vertical direction towards down
% process ended when reached last point of sample
% return all nodes which discovered and curvature directions 
function [allNodes,sampleDir]=findVerticalDown(sample,PolynomialParameters,point,step,dslim,allNodes,sampleDir)
    % loop until reach last point of sample
    roi=[min(sample(:,1)),max(sample(:,1)); min(sample(:,2)),max(sample(:,2)); ...
        min(sample(:,3)),max(sample(:,3))];
    sCloud=pointCloud(point);
    indices = findPointsInROI(sCloud, roi);
    while ~isempty(indices)
        % function gridCreation() finds next node
        [nextNode,LN,e]=gridCreationVertical(point,PolynomialParameters,step,dslim);
        % check if node has real number values
        if isreal(nextNode)
            point=nextNode;
            nextNode=[nextNode,LN(1),LN(2)];
            allNodes=[allNodes;nextNode];
            sCloud=pointCloud(point);
            indices = findPointsInROI(sCloud, roi);
            % store curvature directions
            sizeNum=size(sampleDir,1);
            sampleDir{sizeNum+1,1}=e;
            sampleDir{sizeNum+1,2}=point;
        else
            indices=[];
        end
    end
end