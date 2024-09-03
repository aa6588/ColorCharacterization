%plot 3D Labs for each illum
[xyzs,xyzw]=modRGB2XYZ(PM_optim,radiometric_optim,rgbs);
Labs = XYZ2Lab(xyzs,xyzw);
colors = rgbs;
figure;
msize = 10;
for i=1:length(Labs)
    plot3(Labs(i,2),Labs(i,3),Labs(i,1), '-o','color',colors(i, :), ...
        'markerfacecolor', colors(i, :), 'markersize', msize);hold on
end
xlabel('a*')
ylabel('b*')
zlabel('L*')
%%
% Define the range and steps for a* and b*
a_values = -10:2:10;
b_values = -10:2:10;

% Define the fixed levels of L*
L_levels = [40, 60, 80];

% Initialize an array to store the L*a*b* values
lab_values = [];

% Loop over the L* levels, a* values, and b* values to generate the grid
for L = L_levels
    for a = a_values
        for b = b_values
            % Check if the point is on the horizontal, vertical, or diagonal lines
            if (a == 0 || b == 0 || abs(a) == abs(b))
                lab_values = [lab_values; L, a, b];
            end
        end
    end
end

viz = Lab2XYZ(lab_values,[95.04  100  108.88] );
rgbs = XYZ2RGB(viz);

figure;
for i = 1:41
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgbs(i, :), ...
        'markerfacecolor', rgbs(i, :), 'markersize', 40);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
figure;
for i = 42:82
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgbs(i, :), ...
        'markerfacecolor', rgbs(i, :), 'markersize', 40);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
figure;
for i = 82:123
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgbs(i, :), ...
        'markerfacecolor', rgbs(i, :), 'markersize', 40);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
%%
%apply characterization
%load lab_aim.mat
XYZs_forLab = Lab2XYZ(lab_values,xyzw);
[RGBs_pred, gamut] = modXYZ2RGB(PM_optim,radiometric_optim,XYZs_forLab);

%save('Lab_RGBs.mat',"RGB_forLabs_D65","RGB_forLabs_Red","RGB_forLabs_Green",'RGB_forLabs_Blue')
