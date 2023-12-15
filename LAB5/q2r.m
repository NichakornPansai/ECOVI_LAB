function R=q2r(q)
    qx = q(1); 
    qy = q(2);
    qz = q(3);
    qw = q(4);
    
    R = [1 - 2*qy^2 - 2*qz^2   2*qx*qy - 2*qz*qw     2*qx*qz + 2*qy*qw;
         2*qx*qy + 2*qz*qw     1 - 2*qx^2 - 2*qz^2   2*qy*qz - 2*qx*qw;
         2*qx*qz - 2*qy*qw     2*qy*qz + 2*qx*qw     1 - 2*qx^2 - 2*qy^2]';
end