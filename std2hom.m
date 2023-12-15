function hom_points = std2hom(points)
    % points must contain each

    % convert in homogeneous coordinates
    hom_points = [points; ones( 1, size(points,2) )];   % homogeneous


end