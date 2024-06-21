function [avg_dE] = Day(coeff,meas_XYZ,CV_patches,rLUT,gLUT,bLUT,gain)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
pm = [coeff(1) coeff(2) coeff(3); coeff(4) coeff(5) coeff(6); coeff(7) coeff(8) coeff(9)]';
%CV_color = [0;16;32;48;64;80;96;112;128;144;160;176;192;208;224;240;256];

%get radiometric scalars from PM
%rgb_r = pm \norm_redXYZ';
%rgb_r = rgb_r(1,:)';
%rgb_g = pm \norm_greenXYZ';
%rgb_g = rgb_g(2,:)';
%rgb_b = pm \norm_blueXYZ';
%rgb_b = rgb_b(3,:)';

%compute LUTs
%xq = 0:1:256;
%rs = spline(CV_color,rgb_r,xq');
%rs = min(max(rs,0),1);
%gs = spline(CV_color,rgb_g,xq');
%gs = min(max(gs,0),1);
%bs = spline(CV_color,rgb_b,xq');
%bs = min(max(bs,0),1);

r_scalar = rLUT(CV_patches(:,1)+1);
g_scalar = gLUT(CV_patches(:,2)+1);
b_scalar = bLUT(CV_patches(:,3)+1);

XYZ_predict = pm* [r_scalar g_scalar b_scalar]';
XYZ_predict = XYZ_predict'.* gain(2) ;

Lab_predict = xyz2lab(XYZ_predict,'WhitePoint',gain);
    Lab_meas = xyz2lab(meas_XYZ,'WhitePoint',gain);
    deltaE = imcolordiff(Lab_predict,Lab_meas,'isInputLab',true);
    avg_dE = mean(deltaE);
end

