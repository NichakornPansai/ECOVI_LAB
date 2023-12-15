function bw_img = imageSegment(imgPath)

    img = imread (imgPath);

    bw_img = createMask_pink(img);
    bw_img = bw_img | createMask_green(img);
    bw_img = bw_img | createMask_orange(img);
    bw_img = bw_img | createMask_lightGreen(img);

    bw_img = removeNoise(img, bw_img);
    bw_img = filledhole(bw_img);

end