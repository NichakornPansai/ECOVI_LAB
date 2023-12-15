clc;
clear;
close all;

camera_story = [0, 0, 0, -2.5, 0, 0, 0, 1];
cam_pos_story = [0, 0, -2.5];

initialRT = [
    1   0   0   0
    0   1   0   0
    0   0   1   -2.5
    0   0   0   1
];
RT_cell{1} = initialRT;

pg = poseGraph3D;

step = 10;
last_frame = 880;

for frame1 = 0:step:last_frame-step
    
    frame2 = frame1+step;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Read the two images.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    I1 = rgb2gray(imread(sprintf('rgb/%d.png', frame1)));
    I2 = rgb2gray(imread(sprintf('rgb/%d.png', frame2)));

    D1 = imread(sprintf('depth/%d.png', frame1));
    D2 = imread(sprintf('depth/%d.png', frame2));
    D1 = double(D1)/5000;   % rescale to 1 m
    D2 = double(D2)/5000;   % rescale to 1 m
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find matched points
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [matchedPoints1, matchedPoints2] = detectMatch(I1,I2);
    %showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
    %legend('matched points 1', 'matched points 2');

    featPoints1 = matchedPoints1.Location;
    featPoints2 = matchedPoints2.Location;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Compute the (almost) full points clouds
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    resolution = 2;
    worldPoints1 = computePointsCloud(D1, resolution);
    worldPoints2 = computePointsCloud(D2, resolution);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % RanSaC to find the RT transformation matrix
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    worldFeatPoints1 = getWorldFeatPoint(featPoints1, D1);
    worldFeatPoints2 = getWorldFeatPoint(featPoints2, D2);
    
    iterations = 5000;
    toleranceDist = 0.02;
    inliersFraction = 0.5;
    
    [R, t, it_count] = ransac(worldFeatPoints1, worldFeatPoints2, iterations, toleranceDist, inliersFraction);
    fprintf("frame: %g - RanSaC iterations: %d\n", frame2, it_count);
    
    RT = [R, t; [0 0 0 1]];
    eWorldPoints1 = applyTransfToPoints(worldPoints2', RT)';

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ICP
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % the transformation from points2 to points1 (refined)
    [refined_WorldPoints1, transf] = icp(worldPoints1, eWorldPoints1);
    RT = transf * RT;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Loop closure
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    addRelativePose( pg, [RT(1:3,4)', rotm2quat(RT(1:3,1:3)')] );
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Update camera story
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    old_row = floor(frame2/step);
    RT_cell{old_row + 1} = RT_cell{old_row} * RT;
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot an example of points cloud matching
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
hold on;
ax = pcshow(worldPoints1, 'r', 'VerticalAxis','Y', 'VerticalAxisDir', 'Down' );
ax = pcshow(refined_WorldPoints1, 'c', 'VerticalAxis','Y', 'VerticalAxisDir', 'Up' );

ylim([-1.5, 0.3]);
ax.XDir = 'Reverse';
set(ax, 'YLim', [-1.5, 0.3]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot the graph representation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
title('Original Pose Graph')
show(pg,'IDs','off');
view(-30,45)

updatedPG = optimizePoseGraph(pg);
figure
title('Updated Pose Graph')
show(updatedPG,'IDs','off');
view(-30,45)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot camera positions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load reference trajectory from file
traj=load('traj.txt');

figure;
hold on;
axis equal;
numposes = floor(last_frame/step);

% reference cam
cmap = jet(numposes);
for i = 1:numposes
    p = traj(i,:);
    T = p(2:4);      % position
    R = q2r(p(5:8)); % orientation (convert from quaternion)
    cam = plotCamera('Location',T,'Orientation',R,'Opacity',0, 'Size', 0.02, 'Color', cmap(i,:));
end

% our cam
for i = 1:numposes
    RT = RT_cell{i};
    T = RT(1:3, 4);
    R = RT(1:3, 1:3)^-1;
    cam = plotCamera('Location',T,'Orientation',R,'Opacity',0, 'Size', 0.02, 'Color', [0,0,0]);
end

view(0,0)
