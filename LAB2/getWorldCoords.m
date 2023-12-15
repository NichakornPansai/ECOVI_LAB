function out = getWorldCoord (x, y)

T = [0;0;0];
R = eye(3);

% intrinsic parameters

f = 1.4103e+03;    % focal length
sx = 1;   % scaling coef x (px/unit)
sy = 1;   % scaling coef y (px/unit)
s_th = 0; % skew factor
ox = 0;   % optical center x (px)
oy = 0;   % optical center y (px)
Kint = [
  sx*f, s_th, ox;
  0,    sy*f, oy;
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
out = in(1:3);

end