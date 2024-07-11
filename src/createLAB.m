% Define the range and steps for a* and b*
a_values = -20:5:20;
b_values = -20:5:20;

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
for i = 1:33
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgb(i, :), ...
        'markerfacecolor', rgb(i, :), 'markersize', 40);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
figure;
for i = 34:66
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgb(i, :), ...
        'markerfacecolor', rgb(i, :), 'markersize', 40);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
figure;
for i = 67:99
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgb(i, :), ...
        'markerfacecolor', rgb(i, :), 'markersize', 40);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
%%
%apply characterization
load lab_aim.mat
load Lab_RGBs.mat
XYZs_forLab = Lab2XYZ(lab_values,white.color.XYZ);
rgb_aim = (PM_optim \ XYZs_forLab')';

for i=1:size(rgb_aim,1)
    RGB_forLabs_Red(i,1) = interp1(radiometric_optim(:, 1),x,rgb_aim(i,1),'spline','extrap');
    RGB_forLabs_Red(i,2) = interp1(radiometric_optim(:, 2),x,rgb_aim(i,2),'spline','extrap');
    RGB_forLabs_Red(i,3) = interp1(radiometric_optim(:, 3),x,rgb_aim(i,3),'spline','extrap');
end
RGB_forLabs_Red = min(max(RGB_forLabs_Red,0),1);

save('Lab_RGBs.mat',"RGB_forLabs_D65","RGB_forLabs_Red")
