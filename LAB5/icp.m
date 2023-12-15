function [refined_WorldPoints1, transf] = icp(reference, moving)

gridSize = 0.1;
fixed_pt = pcdownsample(pointCloud(reference), 'gridAverage', gridSize);
moving_pt = pcdownsample(pointCloud(moving), 'gridAverage', gridSize);

s = size(moving);
icp = pcregistericp(moving_pt, fixed_pt, 'Metric', 'pointToPlane');
transf = icp.T';
refined_WorldPoints1 = transf * [moving'; ones(1,s(1))];
refined_WorldPoints1 = refined_WorldPoints1(1:3, :)';


end