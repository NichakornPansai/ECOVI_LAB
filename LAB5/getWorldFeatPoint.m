function worldFeatPoints1 = getWorldFeatPoint(featPoints1, D1)
    
    % the matched points matrix size is the same for both the images
    %featurePointNum = size(featPoints1, 1);
    
    worldFeatPoints1 = zeros(size(featPoints1,1), 3);
    
    % for each point in feature points
    for i = 1:size(featPoints1,1)
        %worldFeatPoints1(i,:) = getWorldFeatPoint(featPoints1(i,:), D1);
        %worldFeatPoints2(i,:) = getWorldFeatPoint(featPoints2(i,:), D1);
        
        % coordinates of the point in the image
        point1 = featPoints1(i,:);
        % round them to have pixel coords
        x1 = round(point1(1));
        y1 = round(point1(2));
        % get the distance value from the distance image
        dFeat1 = D1(y1,x1);
        % compute the world (3D) coordinates of the point and add the point to the set
        worldFeatPoints1(i,:) = getWorldCoords(x1,y1,dFeat1);
    end
        
end