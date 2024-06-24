function [avg_dE] = Day(coeff,XYZmeas,CV_patches,range,Xs,Ys,Zs)
%Day et al display characterization optimization for phosphor matrix and
%LUTs 
%   input measured XYZs, code values, range of measured ramps, XYZ of gray
%   ramp.
pm = [coeff(1) coeff(2) coeff(3); coeff(4) coeff(5) coeff(6); coeff(7) coeff(8) coeff(9)]';

LUT = ( pm \ [Xs(:, 4) Ys(:, 4) Zs(:, 4)]' )';

rgb_scalar = zeros(size(CV_patches));
rgbw = zeros(1,3);
for ch = 1:3
    rgb_scalar(:,ch) = interp1(range,LUT(:,ch),CV_patches(:,ch));
    rgbw(:, ch) = interp1(range, LUT(:, ch), 1);
end

XYZ_predict = (pm * rgb_scalar')';
XYZwhite = (pm * rgbw')' ;

Lab_predict = xyz2lab(XYZ_predict,'WhitePoint',XYZwhite);
    Lab_meas = xyz2lab(XYZmeas,'WhitePoint',[Xs(end,4), Ys(end,4), Zs(end,4)]);
    deltaE = deltaE00(Lab_predict',Lab_meas');
    avg_dE = mean(deltaE);
end

