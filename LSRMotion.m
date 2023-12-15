function [R, t] = LSRMotion(pointSet1, pointSet2)

    % point sets must have one 3-dimensional point per col
    
    % compute the centroids of the 2 sets
    pCentroid = mean(pointSet1, 2);
    qCentroid = mean(pointSet2, 2);
    
    % normalize feature points w.r.t. centroids
    X = pointSet1 - pCentroid; 
    Y = pointSet2 - qCentroid;
    
    % find R and t matrices by SVD decomposition
    S = X * Y';
    [U, ~, V] = svd(S);
    
    R = V * diag([1, 1, det(V*U')]) * U';
    t = qCentroid - R * pCentroid;
    
end