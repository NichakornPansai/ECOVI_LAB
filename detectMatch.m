function [matchedPoints1, matchedPoints2] = detectMatch(I1,I2)

    % Find the SURF features. MetricThreshold controls the number of detected

    % points. To get more points make the threshold lower.

    points1 = detectSURFFeatures(I1, 'MetricThreshold', 200);
    points2 = detectSURFFeatures(I2, 'MetricThreshold', 200);

    % Extract the features.

    [f1,vpts1] = extractFeatures(I1, points1);
    [f2,vpts2] = extractFeatures(I2, points2);

    % Match points and retrieve the locations of matched points.

    indexPairs = matchFeatures(f1,f2) ;
    matchedPoints1 = vpts1(indexPairs(:,1));
    matchedPoints2 = vpts2(indexPairs(:,2));
end