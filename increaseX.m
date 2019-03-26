% return nodes of this sample point cloud
% allNodes is matrix with nodes in 3 dimensions
function [allNodes,sampleDir]=increaseX(sample,point,PolynomialParameters,allNodes,sampleDir,step,dslim) 
    % calculate principal curvatures
    [LN,~,~,~]=curvature(point,PolynomialParameters);
    % first node to start process
    node=point; node(1,4:5)=LN;
    allNodes=[allNodes;node];
    % boundaries of sample
    roi=[min(sample(:,1)),max(sample(:,1)); min(sample(:,2)),max(sample(:,2)); ...
        min(sample(:,3)),max(sample(:,3))];
    sCloud=pointCloud(point); % transform point to object of point cloud
    indices = findPointsInROI(sCloud, roi); % function to check if is inside of boundaries
    while ~isempty(indices)
        % to towards up and in vertical direction
        [allNodes,sampleDir]=findVerticalUp(sample,PolynomialParameters,point,step,dslim,allNodes,sampleDir);
        % to towards down and in vertical direction
        % decrease of step in x value
        [allNodes,sampleDir]=findVerticalDown(sample,PolynomialParameters,point,-step,-dslim,allNodes,sampleDir);
        % next node in horizontal direction and increasing value of x-axis
        [nextNode,LN,e]=gridCreationHorizontal(point,PolynomialParameters,step,dslim);
        % check if node doesn't have imaginary numbers
        if isreal(nextNode)
            % store node
            point=nextNode;
            nextNode(1,4:5)=LN;
            allNodes=[allNodes;nextNode];
            % store curvature directions
            sizeNum=size(sampleDir,1);
            sampleDir{sizeNum+1,1}=e;
            sampleDir{sizeNum+1,2}=point;
            % check if is inside in boundaries
            sCloud=pointCloud(point);
            indices = findPointsInROI(sCloud, roi);
        else
            indices=[]; % stop while loop
        end
    end
end