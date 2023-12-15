close all;
clear;

% load sample image
I4=imread('974-1.jpg');
I3=imread('975-1.jpg');
imshow(I4)
figure
imshow(I3)
% show the image and wait for the points selection (be sure to check if exactly four points were selected)

figure
%subplot(1,3,1);
%imshow(I)

points_out2 = [
            [527;254], [661; 257], [661;308], [527;305]
];
points_in2 = [
            [19;263], [157;272], [156;324], [17;317]
];

H2 = calculate_homography(points_in2, points_out2);

% prepare image reference information

Rin2 = imref2d(size(I3));

% convert homography matrix to the Matlab projective transformation

t2 = projective2d(H2');

% warp the image and get the output reference information
%subplot(1,3,2);
[I5, Rout] = imwarp(I3, Rin2, t2);
imshow(I5);




p = imfuse(I4,Rin2, I5, Rout,'blend');
imshow(p)
