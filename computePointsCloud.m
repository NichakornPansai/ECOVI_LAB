function worldPoints = computePointsCloud(D1, resolution)

    % reduced image
    rD = D1(1:resolution:size(D1,1), 1:resolution:size(D1,2));

    rows = size(rD,1);
    cols = size(rD,2);
    
    worldPoints = zeros(rows*cols, 3);
    
    for i = 1:rows
        for j = 1:cols
            x = j*resolution;
            y = (rows-i)*resolution;
            d = rD(i,j);
            wc = getWorldCoords(x,y,d);
            worldPoints((i-1)*cols+j, : ) = wc;
        end
    end
end