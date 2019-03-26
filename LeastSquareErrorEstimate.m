% sample is choosen points, B are parameters
function B=LeastSquareErrorEstimate(sample)
    % compute parameters of polyonym of 4th degree through Least Square
    % Estimation Method
    % X is matrix with x,y and Y is matrix with z
    count=size(sample,1);
    X=zeros(count,15);
    X(:,1)=sample(:,1).^4;
    X(:,2)=6*sample(:,1).^2.*sample(:,2).^2;
    X(:,3)=4*sample(:,1).^3.*sample(:,2);
    X(:,4)=4*sample(:,1).*sample(:,2).^3;
    X(:,5)=sample(:,2).^4;
    X(:,6)=sample(:,1).^3;
    X(:,7)=3*sample(:,1).^2.*sample(:,2);
    X(:,8)=3*sample(:,1).*sample(:,2).^2;
    X(:,9)=sample(:,2).^3;
    X(:,10)=sample(:,1).^2;
    X(:,11)=2.*sample(:,1).*sample(:,2);
    X(:,12)=sample(:,2).^2;
    X(:,13)=sample(:,1);
    X(:,14)=sample(:,2);
    X(:,15)=ones(count,1);
    Y=sample(:,3);
    % Least Square Estimation
    B=pinv(X)*Y;
end