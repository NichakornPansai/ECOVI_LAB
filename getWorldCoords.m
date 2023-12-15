function out = getWorldCoords (x, y, d)

T = [0;0;0];
R = eye(3);

% intrinsic parameters

fx = 481.2;
fy = 480.0; % focal length
sx = 1;   % scaling coef x (px/unit)
sy = 1;   % scaling coef y (px/unit)
s_th = 0; % skew factor
cx = 319.5;   % optical center x (px)
cy = 239.5;   % optical center y (px)
Kint = [
  sx*fx, s_th, cx;
  0,    sy*fy, cy;
  0,    0,    1
];


in = [x; y; 1];
in = Kint^-1 * in;

% homogeneous
in = [in; 1];

in = [R, T] * in;

s = size(in);
% intrinsic normalization
in = in / in(end);
out = in(1:3)';

out = out.*d;


end