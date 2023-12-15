function [C, r] = getCenterRadius(bw_img)

    %find finds all non zero elements 
    [y, x] = find(bw_img);  % x and y are column vectors
    % the function outputs first the rows and then the columns, that's why [y,x]

    C = [median(x); median(y)]; % center of the ball
    
    area = length(x);
    r = sqrt(area/pi);
    
    
    
    %{
    threshold = 0.5;
    r = 0;
    ratio = 1;
    [rows, cols] = size(bw_img);
    
    while ratio > threshold
        r = r+5;
        circ_px = 0;
        circ_w_px = 0;
        for i = 0:cols
            for j = 0:rows
                % if the coordinates of the element of the matrix is inside
                % the circle of center C and radius r
                if ((i-C(1))^2 + (j-C(2))^2 <= r^2)
                    % we count the pixels inside the circle (regardless of
                    % the color)
                    circ_px = circ_px + 1;     
                    % we count only the white pixels inside the circle
                    % at position (j,i) we converted into double to fit the
                    % matlab acquirement 
                    % this variable will tell how many white pixel we have
                    circ_w_px = circ_w_px + double(int8(bw_img(j, i)));
                    
                end
            end
        end
        ratio = circ_w_px / circ_px;
    end
    
    % converting to the actual size of the ball
    % bc of threshold r of the ball is oversized
    r = r * sqrt(threshold);
    %}
    
end