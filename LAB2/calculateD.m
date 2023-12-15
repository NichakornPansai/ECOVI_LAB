function z = calculateD(pixelR)

realR = 10; %(cm)

%u1 = (x1*fx)/2 + cx;

%u2 = (x2*fx)/2 + cx;

%pixDis = u2-u1;

f = 1.4103e+03;

%u2-u1 = (x2-x1)*fx/2;
%du = dx * fx / z;
z = (realR * f) / pixelR;
end