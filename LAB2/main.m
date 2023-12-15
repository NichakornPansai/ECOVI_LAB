close all;
clear;

figure(1);

imshow('./1/2018-10-29_10-50-48.403_L.png');
hold on;

% trajectory plots
figure(2);
subplot(3,1,1);
%axis([2,22,50,100]);
title('x');
subplot(3,1,2);
%axis([2,22,0,300]);
title('y');
subplot(3,1,3);
%axis([2,22,100,500]);
title('z');

D = './1/';
S = dir(fullfile(D,'*.png')); % pattern to match filenames. List of files in this dir
C = [0; 0];
r = 0;
C_story = [];
r_story = [];
it_story = [];
wc = [];
pred_story = [];

disp("iterations:");
for k = 1:numel(S)
    
    fprintf("%d / %d \n", k, numel(S));
    r_story = [r_story, r];
    it_story = [it_story, k];
    
    F = fullfile(D,S(k).name);
    img = imageSegment(F);
    [C, r] = getCenterRadius(img);
    C_story = [C_story, C];
    
    %fprintf('radius = %.1f', r);
    
    figure(1);
    if (k>1 && k<numel(S)-1)
        imshow(F);
        scatter(C_story(1,:), C_story(2,:), 'c*');
        drawCircle(C_story(1,:), C_story(2,:), r_story);
        V = C - C_story(:,end-1);
        quiver(C_story(1,end-1), C_story(2,end-1), V(1), V(2), 'MaxHeadSize', 1, 'Color', 'g');      % plot arrow
    end
    
    wc = [ wc, getWorldCoords(C(1), C(2)) .* calculateD(r) ];
    
    polyDegree = 3;
    %window size is the number of frames we passs to polyfit
    wSize = 10; % story window size
    if (k>polyDegree && k<numel(S)-1)
        %clamping
        wStart = max(k-wSize, 1);  % story window start
        
        ax = polyfit(it_story(wStart:end), C_story(1, wStart:end), polyDegree);    %CsX = C_story(1,:);
        ay = polyfit(it_story(wStart:end), C_story(2, wStart:end), polyDegree);    %CsY = C_story(2,:);
        
        pred = [polyval(ax, k+1); polyval(ay, k+1)];
        pred_story = [pred_story, pred];
          
        scatter(pred_story(1,:), pred_story(2,:), 'yo');
    end
    
    if (k>=2 && k<=22)
        trj_time = it_story(2:k);
        trj_coord = wc(:,2:k);
        figure(2);
        subplot(3,1,1); plot(trj_time, trj_coord(1,:));
        title('x');
        subplot(3,1,2); plot(trj_time, trj_coord(2,:));
        title('y');
        subplot(3,1,3); plot(trj_time, trj_coord(3,:));
        title('z');
    end

    
    drawnow;
end






