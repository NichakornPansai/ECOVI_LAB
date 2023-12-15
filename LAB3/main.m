clear;
close all;

stereoParams = importdata("stereoParams.mat");

subfignum = 1;

for frame = 0:5:44

% read pair of images

path_l = strcat('calib_stereo_1/left/left-00', num2str(frame,'%02d'));
path_r = strcat('calib_stereo_1/right/right-00', num2str(frame,'%02d'));

I1 = imread(strcat(path_l, '.png'));
I2 = imread(strcat(path_r, '.png'));

% gaussian blur to reduce noise
I1 = imgaussfilt(I1, 4);
I2 = imgaussfilt(I2, 4);

% rectify images using calculated stereo parameters

[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);

%imtool(cat(3, J1, J2, J2));

min = 4;
max = 28;
% disparity range
dispRange = [16*min, 16*max];
disparityMap = disparity(J1, J2, ...
    'DisparityRange', dispRange, ...
    'BlockSize', 15, ...                % no more than 15
    'ContrastThreshold', 0.5, ...       % [0,1] nothing really changes
    'UniquenessThreshold', 1);         % the lower the better
    
% show disparity map

%figure 
subplot(3,3,subfignum);   subfignum = subfignum+1;
imshow(disparityMap, dispRange);
colormap(gca,jet) 
colorbar
title(num2str(frame));
%{
points3D = reconstructScene(disparityMap, stereoParams);

% expand gray image to three channels (simulate RGB)

J1_col = cat(3, J1, J1, J1);

% Convert to meters and create a pointCloud object

points3D = points3D ./ 1000;
ptCloud = pointCloud(points3D, 'Color', J1_col);

% Create a streaming point cloud viewer

player3D = pcplayer([-3, 3], [-3, 3], [0, 8], 'VerticalAxis', 'y', ...
   'VerticalAxisDir', 'down');

% Visualize the point cloud

view(player3D, ptCloud);
%}

end