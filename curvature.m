% Compute E, G, F, e, f, g quantities of first and second fundamental form for each point
% p is point (x,y,z)
% B is polynomial parameters of estimation surface
% LN is matrix with 2 principal curvatures
% v is eigenvector
% dx and dy are differential of estimated function of x and y respectively
% estimate function is 4th degree polynom
function [LN, v, dx, dy]=curvature(p,B)
%     % first partial differantial of value x
    dx=( (4*B(1)) * (p(1)^3) ) + ( (12*B(2)*p(1)) * (p(2)^2) ) + ( (12*B(3)) * (p(1)^2) * p(2) ) + ...
       ( (4*B(4)) * (p(2)^3) ) + ( (3*B(6)) * (p(1)^2) ) + ( 6*B(7)*p(1)*p(2) ) + ...
       ( (3*B(8)) * (p(2)^2) ) + ( 2*B(10)*p(1) ) + ( 2*B(11)*p(2) ) + ( B(13) );
    % second partial differential of value x
    dx2=12*B(1)*p(1)^2 + 12*B(2)*p(2)^2 + 24*B(3)*p(1)*p(2) + ...
        6*B(6)*p(1) + 6*B(7)*p(2) + 2*B(10);
    % first partial differential of value y
    dy=4*B(5)*p(2)^3 + 12*B(2)*p(1)^2*p(2) + 4*B(3)*p(1)^3 + ...
       12*B(4)*p(1)*p(2)^2 + 3*B(9)*p(2)^2 + 3*B(7)*p(1)^2 + ...
       6*B(8)*p(1)*p(2) + 2*B(12)*p(2) + 2*B(11)*p(1) + B(14);
   % second partial differential of value y
    dy2=12*B(5)*p(2)^2 + 12*B(2)*p(1)^2 + 24*B(4)*p(1)*p(2) + ...
        6*B(9)*p(2) + 6*B(8)*p(1) + 2*B(12); 
    % partial differential of value x and y
    dxdy=24*B(2)*p(1)*p(2) + 12*B(3)*p(1)^2 + 12*B(4)*p(2)^2 + ...
        6*B(7)*p(1) + 6*B(8)*p(2) + 2*B(11);
    % estimate quantities
    E= 1 + dx^2;
    G= 1 + dy^2;
    F= dx*dy;
    w= sqrt((E*G)-(F^2));
    efg(1)=det([1 0 dx; ...
                0 1 dy; ...
                0 0 dx2])/w;
    efg(2)=det([1 0 dx; ...
                 0 1 dy; ...
                 0 0 dxdy])/w;
    efg(3)=det([1 0 dx; ...
                 0 1 dy; ...
                 0 0 dy2])/w;
    % matrix of curvature
    WC=[E F; F G]\[efg(1) efg(2); efg(2) efg(3)];
    % compute eigenvalues and eigenvectors of matrix WC
    [v, eigval]=eig(WC);
    % store 2 principal curvatures
    LN=diag(eigval);
    % check for correct storing
    if abs(LN(1))<abs(LN(2))
        LN([1 2])=LN([2 1]);
    end
end