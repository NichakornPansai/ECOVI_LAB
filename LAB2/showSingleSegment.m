close all;
clear;
hold on;

pic = 6;
D = './1/';
S = dir(fullfile(D,'*.png')); % pattern to match filenames.

F = fullfile(D,S(pic).name);
img = imageSegment(F);
imshow(img);