function [avg_dE] = Day(coeff,XYZmeas,CV_patches,range,Xs,Ys,Zs)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
pm = [coeff(1) coeff(2) coeff(3); coeff(4) coeff(5) coeff(6); coeff(7) coeff(8) coeff(9)]';
%CV_patches = [0;16;32;48;64;80;96;112;128;144;160;176;192;208;224;240;256];

LUT = ( pm \ [Xs(:, 4) Ys(:, 4) Zs(:, 4)]' )';
%LUT = [Xs(:, 4) Ys(:, 4) Zs(:, 4)]* inv(PM);

%get radiometric scalars from PM
% rgb_r = pm \ r_ramp';
% rgb_r = rgb_r(1,:)';
% rgb_g = pm \ g_ramp';
% rgb_g = rgb_g(2,:)';
% rgb_b = pm \ b_ramp';
% rgb_b = rgb_b(3,:)';

%compute LUTs
% xq = (0:5:255)./255;
% rs = spline(CV_color,rgb_r,xq');
% rLUT = min(max(rs,0),1);
% gs = spline(CV_color,rgb_g,xq');
% gLUT = min(max(gs,0),1);
% bs = spline(CV_color,rgb_b,xq');
% bLUT = min(max(bs,0),1);

r_scalar = interp1(range,LUT(:,1),CV_patches(:,1));
g_scalar = interp1(range,LUT(:,2),CV_patches(:,2));
b_scalar = interp1(range,LUT(:,3),CV_patches(:,3));

XYZ_predict = (pm * [r_scalar g_scalar b_scalar]')';

Lab_predict = xyz2lab(XYZ_predict,'WhitePoint',white.color.XYZ');
    Lab_meas = xyz2lab(XYZmeas,'WhitePoint',white.color.XYZ');
    deltaE = deltaE00(Lab_predict',Lab_meas');
    avg_dE = mean(deltaE);
end
