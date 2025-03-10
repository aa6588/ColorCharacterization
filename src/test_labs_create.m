%% Define Lab grids

% Define ranges and steps for each L value
b_min_L40 = -24; b_max_L40 = 4; b_step_L40 = 2;
a_min_L40 = -8; a_max_L40 = 4; a_step_L40 = 2;

b_min_L55 = -30; b_max_L55 = 6; b_step_L55 = 2;
a_min_L55 = -10; a_max_L55 = 4; a_step_L55 = 2;

b_min_L70 = -36; b_max_L70 =6; b_step_L70 = 2;
a_min_L70 = -12; a_max_L70 = 6; a_step_L70 = 2;


% Generate and populate matrices for L40
[b_grid_L40, a_grid_L40] = meshgrid(b_min_L40:b_step_L40:b_max_L40, a_min_L40:a_step_L40:a_max_L40);
num_a_L40 = size(a_grid_L40, 1);
num_b_L40 = size(a_grid_L40, 2);
Lab_L40 = zeros(num_a_L40 * num_b_L40, 3);
for i = 1:num_a_L40
    for j = 1:num_b_L40
        idx = (i - 1) * num_b_L40 + j;
        Lab_L40(idx, :) = [40, a_grid_L40(i, j), b_grid_L40(i, j)];
    end
end

% Generate and populate matrices for L60
[b_grid_L55, a_grid_L55] = meshgrid(b_min_L55:b_step_L55:b_max_L55, a_min_L55:a_step_L55:a_max_L55);
num_a_L55 = size(a_grid_L55, 1);
num_b_L55 = size(a_grid_L55, 2);
Lab_L55 = zeros(num_a_L55 * num_b_L55, 3);
for i = 1:num_a_L55
    for j = 1:num_b_L55
        idx = (i - 1) * num_b_L55 + j;
        Lab_L55(idx, :) = [55, a_grid_L55(i, j), b_grid_L55(i, j)];
    end
end

% Generate and populate matrices for L80
[b_grid_L70, a_grid_L70] = meshgrid(b_min_L70:b_step_L70:b_max_L70, a_min_L70:a_step_L70:a_max_L70);
num_a_L70 = size(a_grid_L70, 1);
num_b_L70 = size(a_grid_L70, 2);
Lab_L70 = zeros(num_a_L70 * num_b_L70, 3);
for i = 1:num_a_L70
    for j = 1:num_b_L70
        idx = (i - 1) * num_b_L70 + j;
        Lab_L70(idx, :) = [70, a_grid_L70(i, j), b_grid_L70(i, j)];
    end
end

grid_y_L70 = reshape(Lab_L70,[],10,3);
grid_y_L55 = reshape(Lab_L55,[],8,3);
grid_y_L40 = reshape(Lab_L40,[],7,3);