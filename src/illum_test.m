%%illuminants

%how to calculate
% xyY2XYZ(illum_xyY)
% XYZ2RGB(ans)
%  ans.*255
% round

%illum measurements are done with white patch measure dto be D65 under
%255,255,255 illuminant
%D65 patch using PM and LUT model from XYZ to RGB
% first use PM to go (PM \ aim')' then 
% outs(1) = interp1(radiometric(:, 1),x,ans(1));
%outs(2) = interp1(radiometric(:, 2),x,ans(2));
%outs(3) = interp1(radiometric(:, 3),x,ans(3));

