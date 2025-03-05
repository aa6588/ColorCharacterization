function [eq_uv] = recenter(adjXYZ_white,adjXYZ_color,XYZ_white)
%Uses Smith Pokorny XYZ to LMS
M =   [ 0.15514,  0.54312, -0.03286;
       -0.15514,  0.45684,  0.03286;
        0.     ,  0.     ,  0.01608];
%convert adj XYZs to LMS
LMSw = (M * adjXYZ_white')';
LMSc = (M * adjXYZ_color')';
refLMS = (M * XYZ_white')';

D = LMSc./LMSw;
D = diag(D);

Cd_cone = (D * refLMS')';
Cd = (M \ Cd_cone')';

%convert to uvY
eq_uv = XYZ2uvY(Cd);
eq_uv = eq_uv(1:2);
% w_uv = XYZ2uvY(XYZ_white);
% 
% b = ...
%  sqrt( (chrom_uv(1) - eq_uv(1)).^2 + (chrom_uv(2) - eq_uv(2)).^2);
% 
% a = ...
%  sqrt( (chrom_uv(1) - w_uv(1)).^2 + (chrom_uv(2) - w_uv(2)).^2);
% 
% CI = 1 - (b./a);

end