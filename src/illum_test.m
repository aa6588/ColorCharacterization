%%illuminants

%how to calculate
% xyY2XYZ(illum_xyY)
%based on illum_xyY is 100 Y
% XYZ2RGB(ans)
%  ans.*255
% round

%illum measurements are done with white patch measure dto be D65 under
%255,255,255 illuminant
%D65 patch using PM and LUT model from XYZ to RGB
%  aim = xyY2XYZ(illum_xyY); %white red, green, blue, yellow
%  rgb_aim = (PM \ aim')';
% 
% 
% for i=1:5
%     RGB_illum(i,1) = interp1(radiometric(:, 1),x,rgb_aim(i,1));
%     RGB_illum(i,2) = interp1(radiometric(:, 2),x,rgb_aim(i,2));
%     RGB_illum(i,3) = interp1(radiometric(:, 3),x,rgb_aim(i,3));
% end
% 
% RGB_illum = round(RGB_illum .* 255);

%xys = XYZ2xyY(colors);
figure;
plot(illum_xyY(:,1),illum_xyY(:,2),'o','Color','black') %aim
hold on
axis([.24 .42 .24 .42])
plot(srgb_illum(:,1),srgb_illum(:,2),'x','Color','red') %srgb
%plot(LUT_illum(:,1),LUT_illum(:,2),'+','Color','blue') 
plot(final_illum_xyY(:,1),final_illum_xyY(:,2),'+','Color','blue') 
title('xy')


figure;
uv_aim = xyY2uvY(illum_xyY);
uv_srgb = xyY2uvY(srgb_illum);
%uv_LUT = xyY2uvY(LUT_illum);
uv_final = xyY2uvY(final_illum_xyY);
plot(uv_aim(:,1),uv_aim(:,2),'o','Color','black') %aim
hold on
plot(uv_srgb(:,1),uv_srgb(:,2),'x','Color','red') %srgb
%plot(uv_LUT(:,1),uv_LUT(:,2),'+','Color','blue') 
plot(uv_final(:,1),uv_final(:,2),'+','Color','blue') 
title('uv')

%calculate deltaE's for illum vs aim
% for ch = 1:3
% 
%     test_illum(:, ch) = interp1(x, radiometric(:, ch), ...
%         illumRGB(:, ch)./255);
% 
% end
% xyz_illum = (PM * test_illum')';
