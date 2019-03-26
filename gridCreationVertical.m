% BM is matrix with parameters of function estimation
% return node, 2 principal curvatures and curvature directions 
function [node,curv,e]=gridCreationVertical(point,BM,step,dslim)
    % Curvature function compute estimation of 2 curvature quantities (L and N) of each point
    % dx and dy are partial differential of polynomial function 
    [LN,eigenvalues,dx,dy]=curvature(point,BM);
    % one or opposite direction
    if step<0
        eigenvalues=-eigenvalues;
    end
    % function findSurface() estimates surfaces
    % sf1 is matrix with parameters of surface (Ax+By+C) in horizontal direction 
    % sf2 is matrix with parameters of surface (Ax+By+C) in vertical direction
    % e is matrix with 3 direction vectors
    [~,surface2,e]=findSurface(eigenvalues,dx,dy,point);
    % parameters of function z=Ax+By+C
    A=surface2(1); B=surface2(2); C=surface2(3);
    % first value of x
    px=point(1);
    % parameters of polynomial function
    polyn=[BM(5), 4*BM(4)*px+BM(9), BM(12)+6*BM(2)*px^2+3*BM(8)*px, ...
           4*BM(3)*px^3+3*BM(7)*px^2+2*BM(11)*px+BM(14)-B, ...
           BM(1)*px^4-A*px-C+BM(6)*px^3+BM(10)*px^2+BM(13)*px+BM(15)];
    % compute roots of polynomial function
    solutions=roots(polyn);
    % find nearest solution
    [~,idx]=min(abs(point(2)-solutions));
    % compute values y and z
    py=solutions(idx); 
    pz=A*px+B*py+C;
    % calculate dy/dx and dz/dx
    dd1=-4*BM(1)*px^3-12*BM(2)*py^2*px-12*BM(3)*px^2*py-4*BM(4)*py^3 ...
        -3*BM(6)*px^2-6*BM(7)*px*py-3*BM(8)*py^2-2*BM(10)*px-2*BM(11)*py-BM(13)+A;
    dd2=12*BM(2)*px^2*py+4*BM(3)*px^3+12*BM(4)*px*py^2+4*BM(5)*py^3+ ...
        3*BM(7)*px^2+6*BM(8)*px*py+3*BM(9)*py^2+2*BM(11)*px+2*BM(12)*py+BM(14)-B;
    dydx=dd1/dd2;
    dzdx=A+B*dydx;
    qxFirst=sqrt(1+dydx^2+dzdx^2);
    
    % compute next node
    % initialize parameters
    error=1; ds=0;
    while error==1
        % calculate roots
        px=px+step;
        polyn=[BM(5), 4*BM(4)*px+BM(9), BM(12)+6*BM(2)*px^2+3*BM(8)*px, ...
               4*BM(3)*px^3+3*BM(7)*px^2+2*BM(11)*px+BM(14)-B, ...
               BM(1)*px^4-A*px-C+BM(6)*px^3+BM(10)*px^2+BM(13)*px+BM(15)];
        solutions=roots(polyn);
        % calculate y and z
        [~,idx]=min(abs(py-solutions));
        py=solutions(idx);
        pz=A*px+B*py+C;
        % calculate dy/dx and dz/dx
        dd1=-4*BM(1)*px^3-12*BM(2)*py^2*px-12*BM(3)*px^2*py-4*BM(4)*py^3 ...
            -3*BM(6)*px^2-6*BM(7)*px*py-3*BM(8)*py^2-2*BM(10)*px-2*BM(11)*py-BM(13)+A;
        dd2=12*BM(2)*px^2*py+4*BM(3)*px^3+12*BM(4)*px*py^2+4*BM(5)*py^3+ ...
            3*BM(7)*px^2+6*BM(8)*px*py+3*BM(9)*py^2+2*BM(11)*px+2*BM(12)*py+BM(14)-B;
        dydx=dd1/dd2;
        dzdx=A+B*dydx;
        % calculate distance in surface
        qx=sqrt(1+dydx^2+dzdx^2);
        ds=ds+((qxFirst+qx)*step)/2;
        if step<0
            if ds<dslim 
                error=0; 
            end
        else
            if ds>dslim 
                error=0; 
            end            
        end
        % compute surfaces of this new point
        point=[px,py,pz];
        [LN,eigenvalues,dx,dy]=curvature(point,BM);
        if step<0
            eigenvalues=-eigenvalues;
        end
        [~,surface2,e]=findSurface(eigenvalues,dx,dy,point);
        A=surface2(1); B=surface2(2); C=surface2(3);
        qxFirst=qx; 
    end
    % return node and principal curvatures
    node=[px,py,pz];
    curv=LN;
end