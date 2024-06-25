%%illuminants

%how to calculate
% xyY2XYZ(illum_xyY)
% XYZ2RGB(ans)
%  ans.*255
% round

%illum measurements are done with white patch measure dto be D65 under
%255,255,255 illuminant
%D65 patch using PM and LUT model from XYZ to RGB
aim = xyY2XYZ([.3127 .3290 35]);
rgb_aim = (PM \ aim')';
RGB_D65(1) = interp1(radiometric(:, 1),x,rgb_aim(1));
RGB_D65(2) = interp1(radiometric(:, 2),x,rgb_aim(2));
RGB_D65(3) = interp1(radiometric(:, 3),x,rgb_aim(3));

