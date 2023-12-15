function [R, t, it_count] = ransac(worldFeatPoints1, worldFeatPoints2, iterations, toleranceDistance, inliersFraction)
    
    % the matched points matrix size is the same for both the images
    featPointsNum = size(worldFeatPoints1, 1);
    
    it_count = 0;
    sampledPointsNum = floor(featPointsNum * 0.4); 
    for j = 1:iterations
        it_count = it_count + 1;
        
        % let's choose sonme random feature points as sampled points
        sampledPointsIds = randi([1 featPointsNum], 1, sampledPointsNum);

        % matrices containing the world coordinates of the sampled feature points
        sampledWorldFeatPoints1 = worldFeatPoints1(sampledPointsIds, :);
        sampledWorldFeatPoints2 = worldFeatPoints2(sampledPointsIds, :);
        
        [R,t] = LSRMotion(sampledWorldFeatPoints2', sampledWorldFeatPoints1');
    
        % apply the transformation to all the feature points
        extWorldFeatPoints1 = R * worldFeatPoints2' + t;
        
        dist = vecnorm(worldFeatPoints1' - extWorldFeatPoints1);
        numOfInliers = length(find(dist < toleranceDistance));
        if (numOfInliers >= inliersFraction * featPointsNum)
            break;
        end
    end
    
end