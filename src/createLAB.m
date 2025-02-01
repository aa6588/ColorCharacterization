%plot 3D Labs for each illum
[xyzs,xyzw]=modRGB2XYZ(PM_y,LUT_y,rgbs);
Labs = XYZ2Lab(xyzs,xyzw);
%Labw = XYZ2Lab(XYZw ,xyzw );
colors = XYZ2RGB(Lab2XYZ(Labs,xyzw));
%colors = rgbs;
figure;
msize = 10;
for i=1:length(Labs)
    plot3(Labs(i,2),Labs(i,3),Labs(i,1), '-o','color',colors(i, :), ...
        'markerfacecolor', colors(i, :), 'markersize', msize);hold on
end
xlabel('a*')
ylabel('b*')
zlabel('L*')

total_labs = [Lab_L40;Lab_L55;Lab_L70];
srgbs = XYZ2RGB(Lab2XYZ(total_labs,xyzw));
msize = 10;
for i=1:length(total_labs)
    plot3(total_labs(i,2),total_labs(i,3),total_labs(i,1), '-o','color',srgbs(i, :), ...
        'markerfacecolor', srgbs(i, :), 'markersize', msize);hold on
end

%%
%apply characterization
% plotChrom();
% primary = [0.64, .33; .3, .6; .15, .06; .64, .33];
% display = [xs(end,1), ys(end,1);xs(end,2),ys(end,2);xs(end,3),ys(end,3);xs(end,1),ys(end,1)];
% k1 = plot(primary(:,1),primary(:,2),'--k'); %gamut
% k2 = plot(display(:,1),display(:,2),'-r'); %gamut
% scatter(illums(:,1),illums(:,2),'k')
%reshape
%grid_y_L70_calc = reshape(grid_y_L70,[],3);
%grid_y_L55_calc = reshape(grid_y_L55,[],3);
%grid_y_L40_calc = reshape(grid_y_L40,[],3);

grid_y_L70_calc = reshape(Flat_LAB_grid.b.L70,[],3);
grid_y_L55_calc = reshape(Flat_LAB_grid.b.L55,[],3);
grid_y_L40_calc = reshape(Flat_LAB_grid.b.L40,[],3);

PM = Flat_model.b.PM;
LUT = Flat_model.b.LUT;
wp = Flat_model.b.wp;

XYZs_forLab_70= Lab2XYZ(grid_y_L70_calc,wp);
XYZs_forLab_55 = Lab2XYZ(grid_y_L55_calc,wp);
XYZs_forLab_40 = Lab2XYZ(grid_y_L40_calc,wp);
%xyY = XYZ2xyY(XYZs_forLab_80);
%gamut check
[RGBs_y_L40, gamut] = modXYZ2RGB(PM,LUT,XYZs_forLab_40);
[RGBs_y_L55, gamut] = modXYZ2RGB(PM,LUT,XYZs_forLab_55);
[RGBs_y_L70, gamut] = modXYZ2RGB(PM,LUT,XYZs_forLab_70);
%scatter(xyY(:,1),xyY(:,2),'b')

Flat_RGB_grid.b.L40 = reshape(RGBs_y_L40,size(LAB_grid.b.L40));
Flat_RGB_grid.b.L55 = reshape(RGBs_y_L55,size(LAB_grid.b.L55));
Flat_RGB_grid.b.L70 = reshape(RGBs_y_L70,size(LAB_grid.b.L70));

LAB_grid.y.L70 = reshape(grid_y_L70_calc,size(grid_y_L70));
LAB_grid.y.L55 = reshape(grid_y_L55_calc,size(grid_y_L55));
LAB_grid.y.L40 = reshape(grid_y_L40_calc,size(grid_y_L40));

%% u/v/
uv_illums = XYZ2uvY(xyY2XYZ(illum_xyY));
figure;
hold on;

uv_adj_40 = XYZ2uvY(XYZs_forLab_40);
uv_adj_55 = XYZ2uvY(XYZs_forLab_55);
uv_adj_70 = XYZ2uvY(XYZs_forLab_70);
scatter(uv_adj_40(:,1),uv_adj_40(:,2),'r')
scatter(uv_adj_55(:,1),uv_adj_55(:,2),'g')
scatter(uv_adj_70(:,1),uv_adj_70(:,2),'b')
scatter(uv_illums(:,1),uv_illums(:,2),'k','filled')
title('White uv adjustments')
legend({'L* 40','L* 55','L* 70','illums'})


%save('Lab_RGBs.mat',"RGB_forLabs_D65","RGB_forLabs_Red","RGB_forLabs_Green",'RGB_forLabs_Blue')
%%
%%
% Define the range and steps for a* and b*
% a_values = -10:2:10;
% b_values = -16:2:6;
% 
% % Define the fixed levels of L*
% L_levels = [40, 60, 80];
% 
% % Initialize an array to store the L*a*b* values
% lab_values = [];
% 
% % Loop over the L* levels, a* values, and b* values to generate the grid
% for L = L_levels
%     for a = a_values
%         for b = b_values
%             % Check if the point is on the horizontal, vertical, or diagonal lines
%             if (a == 0 || b == 0 || abs(a) == abs(b))
%                 lab_values = [lab_values; L, a, b];
%             end
%         end
%     end
% end
% 
% viz = Lab2XYZ(lab_values,[95.04  100  108.88] );
% rgbs = XYZ2RGB(viz);
% 
% figure;
% for i = 1:38
%     plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgbs(i, :), ...
%         'markerfacecolor', rgbs(i, :), 'markersize', 30);hold on
%     xlabel('a*','FontSize',15)
%     ylabel('b*','FontSize',15)
% end
% figure;
% for i = 39:76
%     plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgbs(i, :), ...
%         'markerfacecolor', rgbs(i, :), 'markersize', 30);hold on
%     xlabel('a*','FontSize',15)
%     ylabel('b*','FontSize',15)
% end
% figure;
% for i = 77:114
%     plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgbs(i, :), ...
%         'markerfacecolor', rgbs(i, :), 'markersize', 30);hold on
%     xlabel('a*','FontSize',15)
%     ylabel('b*','FontSize',15)
% end