function [RGBs,Gamut] = modXYZ2RGB(PM,LUTs,XYZs)
%Converts given XYZs to predicted RGB for given model

rgb_aim = (PM\ XYZs')';
x = (0:17:255)./255;
for i=1:size(rgb_aim,1)
    RGBs(i,1) = interp1(LUTs(:, 1),x,rgb_aim(i,1));
    RGBs(i,2) = interp1(LUTs(:, 2),x,rgb_aim(i,2));
    RGBs(i,3) = interp1(LUTs(:, 3),x,rgb_aim(i,3));
end

Gamut = isnan(RGBs);

    if any(isnan(RGBs(:)))
        warning('Out of Gamut values');
    end
end