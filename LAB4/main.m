close all;
clear;

% load sample image

I=imread('door.jpg');

% show the image and wait for the points selection (be sure to check if exactly four points were selected)

figure
subplot(1,3,1);
imshow(I)
[x,y] = getpts

% check wether the user select 4 points or more
if length(x) >= 4
    x = x(1:4);
    y = y(1:4);
else
    [x,y] = getpts
end


% prepare reference points


%           bottom-left     top-left        top-right       bottom-right
points_in = [
%            [128;750],      [110;70],       [488;89],       [425;750]
            [x(1);y(1)],     [x(2);y(2)],    [x(3);y(3)],    [x(4);y(4)]
            ];
points_out = [
            [0;600],        [0;0],          [270;0],        [270;600]
];

% calculate the homography

H = calculate_homography(points_in, points_out);

% prepare image reference information

Rin = imref2d(size(I));

% convert homography matrix to the Matlab projective transformation

t = projective2d(H');

% warp the image and get the output reference information
subplot(1,3,2);
[I2, Rout] = imwarp(I, Rin, t);
imshow(I2);

% crop the output based on the reference information
subplot(1,3,3);
margin = 10;
I3 = crop_image(I2, Rout, points_out, margin);
imshow(I3);
