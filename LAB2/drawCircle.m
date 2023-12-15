function h = drawCircle(x,y,r)
% code from https://www.mathworks.com/matlabcentral/answers/98665-how-do-i-plot-a-circle-with-a-given-radius-and-center

    for i = 1:length(r)
        th = 0:pi/50:2*pi;
        xunit = r(i) * cos(th) + x(i);
        yunit = r(i) * sin(th) + y(i);
        h = plot(xunit, yunit, 'Color', 'r');
    end
end