% return nodes of point cloud
% allNodesCloud is matrix of all nodes of point Cloud in 3 dimensions
% allL is matrix of first principal curvature quantity of 9 neighor nodes
% allN is matrix of second principal curvature quantity of 9 neighor nodes
% nearPoints is matrix with selected points of 9 neighor nodes
% allDir is curvature directions
function [allNodes,allL,allN,allNearPoints,allDir]=extractLN(data,iterations,step,dslim)
% initialize variables which store all discovered nodes of point cloud
allNodes=[]; allN=[]; allL=[]; allNearPoints=[]; allDir=[];
% method for segmentation of total surface
segmentation=data; 
segmentation(:,4)=0; % 0 is for no-segmentantion point
for i=1:iterations
    % find nearest points
    points=knnsearch(segmentation(:,1:3),segmentation(1,1:3),'K',round(size(data,1)/iterations),'Distance','seuclidean');
    numClusters{i}=segmentation(points,1:3);  % store points
    segmentation(points,4)=1; % 1 is for segmentantion point
    indexCluster=find(segmentation(:,end)==0); % find no-segmentantion points
    segmentation=segmentation(indexCluster,:); % remove segmentantion points
end
% for each cluster 
for i=1:iterations
    endIndex=0;
    while endIndex==0
        % print number of cluster of point cloud
        fprintf('Cluster %d.\n',i); 
        % store permanent nodes of sample point cloud
        sampleNodes=[];
        % store curvature directions
        sampleDir=[];
        % sample is matrix of selected points in this cluster
        sample=numClusters{i};
        % PolynomialParameters are parameters of estimated polynom of surface, 
        % which compute through Least Square Estimation method. 
        PolynomialParameters=LeastSquareErrorEstimate(sample);
        % for random point in sample
        point=sample(randi([1 size(sample,1)]),:);
        % Initiative procedure of finding nodes of each sample
        % Find all next nodes with certain search pattern
        % First compute all nodes in vertical direction, towards up and down
        % then move to next node in horizontal direction towards up
        % and procedure continues until reach last point.
        % Then go back to initial node and now find new node towards back
        % in horizontal direction and continue the process until reach the first point.
        [sampleNodes,sampleDir]=increaseX(sample,point,PolynomialParameters,sampleNodes,sampleDir,step,dslim);
        % find next node in horizontal direction but in decreasing x-axis value
        [sampleNodes,sampleDir]=decreaseX(sample,point,PolynomialParameters,sampleNodes,sampleDir,step,dslim);
        % if not find at least 9 nodes in this sample, try another start
        % point
        if size(sampleNodes,1)>=9
            endIndex=1;
        end
    end
    % object of mapping near nodes
    kdTree=ExhaustiveSearcher(sampleNodes(:,1:3));
    % create rows of 9 near nodes
    nearPoints=knnsearch(kdTree,sampleNodes(:,1:3),'K',9,'Distance','seuclidean');
    for p=1:size(nearPoints,1)
        % same pattern of 9 nodes
        ind=find(sampleNodes(nearPoints(p,:),2)>sampleNodes(nearPoints(p,1),2));
        if ~isempty(ind)
            [~,in]=max(sampleNodes(nearPoints(p,ind),1));
            index=ind(in);
            cL(p,1:8)=sampleNodes(nearPoints(p,1:end ~=index),4); 
            cL(p,9)=sampleNodes(nearPoints(p,index),4);
            cN(p,1:8)=sampleNodes(nearPoints(p,1:end ~=index),5); 
            cN(p,9)=sampleNodes(nearPoints(p,index),5);
            nearPoints(p,[index 9]) = nearPoints(p,[9 index]);
        else
            cL(p,1:9)=sampleNodes(nearPoints(p,:),4);
            cN(p,1:9)=sampleNodes(nearPoints(p,:),5); 
        end
    end
    % store training inputs
    allN{i}=cN; % rows of first principal curvature
    allL{i}=cL; % rows of second principal curvature
    sampleNodes(:,6)=0; sampleNodes(:,7)=0;
    allNodes{i}=sampleNodes; % store nodes
    allNearPoints{i}=nearPoints; % store near nodes
    allDir{i}=sampleDir; % store curvature directions
    clear cN cL nearPoints sample;
end
end

