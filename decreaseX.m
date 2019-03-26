% return nodes of this sample point cloud
% allNodes is matrix with nodes in 3 dimensions
function [allNodes,sampleDir]=decreaseX(sample,point,PolynomialParameters,allNodes,sampleDir,step,dslim)
    [nextNode,LN,e]=gridCreationHorizontal(point,PolynomialParameters,-step,-dslim);
    if isreal(nextNode)
        point=nextNode;
        nextNode(1,4:5)=LN;
        allNodes=[allNodes;nextNode];
        % store curvature directions
        sizeNum=size(sampleDir,1);
        sampleDir{sizeNum+1,1}=e;
        sampleDir{sizeNum+1,2}=point;
        roi=[min(sample(:,1)),max(sample(:,1)); min(sample(:,2)),max(sample(:,2)); ...
        min(sample(:,3)),max(sample(:,3))];
        sCloud=pointCloud(point);
        indices = findPointsInROI(sCloud, roi);
    else
        indices=[];
    end
    while ~isempty(indices)
        % increasing x-axis value in vertical direction
        [allNodes,sampleDir]=findVerticalUp(sample,PolynomialParameters,point,step,dslim,allNodes,sampleDir);
        % decreasin x-axis value in vertical direction
        [allNodes,sampleDir]=findVerticalDown(sample,PolynomialParameters,point,-step,-dslim,allNodes,sampleDir);
        % find node in horizontal direction
        [nextNode,LN,e]=gridCreationHorizontal(point,PolynomialParameters,-step,-dslim);
        if isreal(nextNode)
            point=nextNode; 
            nextNode(1,4:5)=LN;
            allNodes=[allNodes;nextNode];
            % store curvature directions
            sizeNum=size(sampleDir,1);
            sampleDir{sizeNum+1,1}=e;
            sampleDir{sizeNum+1,2}=point;
            sCloud=pointCloud(point);
            indices = findPointsInROI(sCloud, roi);
        else
            indices=[];
        end
    end
end