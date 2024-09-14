% 
% % Define ranges and steps
% b_min = -2;
% b_max = 14;
% b_step = 2;
% a_min = -10;
% a_max = 10;
% a_step = 2;
% 
% % Define L values
% L_values = [40, 60, 80];
% 
% % Create a grid for a and b
% [b_grid, a_grid] = meshgrid(b_min:b_step:b_max, a_min:a_step:a_max);
% 
% % Get the number of elements in the a and b grids
% num_a = size(a_grid, 1);
% num_b = size(a_grid, 2);
% 
% % Preallocate matrices for each L value
% Lab_L40 = zeros(num_a * num_b, 3);
% Lab_L60 = zeros(num_a * num_b, 3);
% Lab_L80 = zeros(num_a * num_b, 3);
% 
% % Populate matrices
% for i = 1:num_a
%     for j = 1:num_b
%         idx = (i - 1) * num_b + j;
%         Lab_L40(idx, :) = [40, a_grid(i, j), b_grid(i, j)];
%         Lab_L60(idx, :) = [60, a_grid(i, j), b_grid(i, j)];
%         Lab_L80(idx, :) = [80, a_grid(i, j), b_grid(i, j)];
%     end
% end

%% different
% Define ranges and steps for each L value
b_min_L40 = -10; b_max_L40 = 10; b_step_L40 = 2;
a_min_L40 = -10; a_max_L40 = 10; a_step_L40 = 2;

b_min_L55 = -12; b_max_L55 = 12; b_step_L55 = 2;
a_min_L55 = -12; a_max_L55 = 12; a_step_L55 = 2;

b_min_L70 = -14; b_max_L70 =14; b_step_L70 = 2;
a_min_L70 = -14; a_max_L70 = 14; a_step_L70 = 2;

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