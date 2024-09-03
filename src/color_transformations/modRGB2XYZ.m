function [XYZs, XYZwhite]= modRGB2XYZ(PM,LUTs,RGBs)
%Converts given RGBs to predicted XYZ for given model

x = (0:5:255)./255;
for ch = 1:3

    linRGBs(:, ch) = interp1(x, LUTs(:, ch), RGBs(:, ch));
    RGBSwhite(:, ch) = interp1(x, LUTs(:, ch), 1);
    
end

XYZs = (PM * linRGBs')';
XYZwhite = (PM * RGBSwhite')';

end