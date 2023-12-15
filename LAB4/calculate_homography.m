function H = calculate_homography(pin, pout)

    % note: pin and pout are column vectors stacked horizontally

    p1 = pout(:,1);
    p2 = pout(:,2);
    p3 = pout(:,3);
    p4 = pout(:,4);
    
    P1 = pin(:,1);
    P2 = pin(:,2);
    P3 = pin(:,3);
    P4 = pin(:,4);
    
    % since we have 4 points (8 equations) for 8 unknown parameters, we can
    % find the parameters simply using a linear system
    
    % definition of the matrix representing the linear system
    
    A = [
        P1(1),  P1(2),  1,  0,      0,      0,  -P1(1)*p1(1),   -P1(2)*p1(1);
        P2(1),  P2(2),  1,  0,      0,      0,  -P2(1)*p2(1),   -P2(2)*p2(1);
        P3(1),  P3(2),  1,  0,      0,      0,  -P3(1)*p3(1),   -P3(2)*p3(1);
        P4(1),  P4(2),  1,  0,      0,      0,  -P4(1)*p4(1),   -P4(2)*p4(1);
        0,      0,      0,  P1(1),  P1(2),  1,  -P1(1)*p1(2),   -P1(2)*p1(2);
        0,      0,      0,  P2(1),  P2(2),  1,  -P2(1)*p2(2),   -P2(2)*p2(2);
        0,      0,      0,  P3(1),  P3(2),  1,  -P3(1)*p3(2),   -P3(2)*p3(2);
        0,      0,      0,  P4(1),  P4(2),  1,  -P4(1)*p4(2),   -P4(2)*p4(2);
    ];
    
    % known terms vector
    b = [
        p1(1);
        p2(1);
        p3(1);
        p4(1);
        p1(2);
        p2(2);
        p3(2);
        p4(2);
    ];
    
    % solving the system
    h = A\b;
    
    % reshaping the unknowns into the homography matrix
    % since H is up to a scale, we set the last element equal to 1
    H = [
        h(1),   h(2),   h(3);
        h(4),   h(5),   h(6);
        h(7),   h(8),   1;
    ];
    
end