function [BW,maskedImage] = removeNoise(RGB,MASK)
%segmentImage Segment image using auto-generated code from imageSegmenter App
%  [BW,MASKEDIMAGE] = segmentImage(RGB,MASK) segments image RGB using
%  auto-generated code from the imageSegmenter App. The final segmentation
%  is returned in BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 21-Oct-2019
%----------------------------------------------------


% Convert RGB image into L*a*b* color space.
X = rgb2lab(RGB);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Load Mask
BW = MASK;

% Open mask with disk
radius = 1;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end

