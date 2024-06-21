function [rLUT,gLUT,bLUT] = Day_LUTs(pm,norm_redXYZ,norm_greenXYZ,norm_blueXYZ)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%pm = [coeff(1) coeff(2) coeff(3); coeff(4) coeff(5) coeff(6); coeff(7) coeff(8) coeff(9)]';
CV_color = [0;16;32;48;64;80;96;112;128;144;160;176;192;208;224;240;255];
%wp = [0.9579	1.0000	1.0825];
%get radiometric scalars from PM
rgb_r = pm \norm_redXYZ';
rgb_r = rgb_r(1,:)';
rgb_g = pm \norm_greenXYZ';
rgb_g = rgb_g(2,:)';
rgb_b = pm \norm_blueXYZ';
rgb_b = rgb_b(3,:)';

%compute LUTs
xq = 0:1:255;
rLUT = spline(CV_color,rgb_r,xq');
rLUT = min(max(rLUT,0),1);
gLUT = spline(CV_color,rgb_g,xq');
gLUT = min(max(gLUT,0),1);
bLUT = spline(CV_color,rgb_b,xq');
bLUT = min(max(bLUT,0),1);


end

