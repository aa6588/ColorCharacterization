% Define the angles for 12 directions (like a clock)
angles = linspace(0, 2*pi, 12);

% Define the radius steps
radii = linspace(0, 20, 4); % 3 steps from 0 to 20

% Define the fixed levels of L*
L_levels = [55 70 85];

% Initialize an array to store the L*a*b* values
lab_values = [];

% Loop over the L* levels, angles, and radii to generate the values
for L = L_levels
    for angle = angles
        for r = radii
            a_value = r * cos(angle);
            b_value = r * sin(angle);
            lab_values = [lab_values; L, a_value, b_value];
        end
    end
end
lab_values = round(lab_values);

viz = Lab2XYZ(lab_values,[95.04  100  108.88] );
rgb = XYZ2RGB(viz);
figure;
for i = 1:48
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgb(i, :), ...
        'markerfacecolor', rgb(i, :), 'markersize', msize);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
figure;
for i = 49:96
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgb(i, :), ...
        'markerfacecolor', rgb(i, :), 'markersize', msize);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
figure;
for i = 97:144
    plot(lab_values(i, 2), lab_values(i, 3), 'o', 'color', rgb(i, :), ...
        'markerfacecolor', rgb(i, :), 'markersize', msize);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end

%apply characterization
XYZs_forLab = Lab2XYZ(lab_values,white.color.XYZ);
rgb_aim = (PM \ XYZs_forLab')';

for i=1:size(rgb_aim,1)
    RGB_forLabs(i,1) = interp1(radiometric(:, 1),x,rgb_aim(i,1),'linear',1);
    RGB_forLabs(i,2) = interp1(radiometric(:, 2),x,rgb_aim(i,2),'linear',1);
    RGB_forLabs(i,3) = interp1(radiometric(:, 3),x,rgb_aim(i,3),'linear',1);
end

