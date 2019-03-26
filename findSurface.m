% find surface which passed to e1 and e2 perpendicular vectors
% return 2 surfaces (ax+by+c) and e matrix with 3 direction vectors
function [sf1,sf2,e]=findSurface(v,dx,dy,f)
    % create 2 vector directions in point p, perpedicular each other
    e(1,:)=[v(1,1),v(2,1),v(1,1)*dx+v(2,1)*dy];
    e(2,:)=[v(1,2),v(2,2),v(1,2)*dx+v(2,2)*dy];
    % outer product of 2 directions
    e(3,:)=cross(e(1,:),e(2,:));
    % check for maximum direction and minimum direction
    if norm(e(1,:))<norm(e(2,:))
        e([1 2],:)=e([2 1],:);
    end
    
    dir=1;
    % find surface function passed from point p in e1 and e3, z=Ax+By+C
    G1=e(dir,1)*e(3,2)-e(3,1)*e(dir,2);
    sf1(1)=-(e(dir,2)*e(3,3)-e(3,2)*e(dir,3))/G1;
    sf1(2)=-(e(3,1)*e(dir,3)-e(dir,1)*e(3,3))/G1;
    Ca1=-det([f(1) f(2) f(3); e(dir,1) e(dir,2) e(dir,3); e(3,1) e(3,2) e(3,3)]);
    sf1(3)=-Ca1/G1;
    
    dir=2;
    % find surface function passed from point p in e2 and e3, z=Ax+By+C
    G2=e(dir,1)*e(3,2)-e(3,1)*e(dir,2);
    sf2(1)=-(e(dir,2)*e(3,3)-e(3,2)*e(dir,3))/G2;
    sf2(2)=-(e(3,1)*e(dir,3)-e(dir,1)*e(3,3))/G2;
    Ca2=-det([f(1) f(2) f(3); e(dir,1) e(dir,2) e(dir,3); e(3,1) e(3,2) e(3,3)]);
    sf2(3)=-Ca2/G2;
end