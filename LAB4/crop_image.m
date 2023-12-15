function out = crop_image(in, Rinfo, crop_points, m)

    % We have 4 points, we use only the top-left and bottom-right to define
    % a rectangle containing the door. 
    % We also subtract the WorldLimits parameters to take into
    % consideration the new coordinates of the image origin after the
    % transformation
    
    door_corn_1 = [
        crop_points(1,2) - Rinfo.XWorldLimits(1);     % x1
        crop_points(2,2) - Rinfo.YWorldLimits(1);     % y1
    ];
    
    door_corn_2 = [
        crop_points(1,4) - Rinfo.XWorldLimits(1);     % x2
        crop_points(2,4) - Rinfo.YWorldLimits(1);     % y2
    ];
    
    % we add the desired cropping margin
    crop_corn_1 = door_corn_1 - m;
    crop_corn_2 = door_corn_2 + m;
    
    % for the cropping function we need 1 corner and the rectangle size
    crop_size = crop_corn_2 - crop_corn_1;
    
    out = imcrop(in, [crop_corn_1; crop_size]);
    
end