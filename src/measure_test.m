%find
grid = LAB_grid.w.L40;
[rows, cols] = find(grid(:, :, 1) == 40 & grid(:, :, 2) == 0 & grid(:, :, 3) == 0);
verify = grid(rows,cols,:)
val(1,:) = RGB_grid.w.L40(rows,cols,:);
%save_filename = 'White_withVRlens_10_16_2024.mat';

cs2000 = CS2000('COM5');
% Synchronization
sync = CS2000_Sync('Internal', 90);
cs2000.setSync(sync);

% %% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);
data = repmat({NaN(1,3)}, 3, 5);  % Each entry is a 1x3 NaN array
XYZw_VRlens = cell2table(data);
XYZw_VRlens.Properties.VariableNames = {'w','r','g','b','y'};
XYZw_VRlens.Properties.RowNames = {'L40' 'L55' 'L70'};
%% range = (0:15:255)./255;
% fwrite(t, "Light:" + RGB_illum(1,1) + "," + RGB_illum(1,2) + "," + RGB_illum(1,3));
% pause(1)
fwrite(t, "Value:" + val(1) + "," + val(2) + "," + val(3));

Lab_Ls.w(1,:) = val;

Gray = cs2000.measure;
XYZw_VRlens.w(1,:)=Gray.color.XYZ';
beep

%%
VR_data = VR_w_rampXYZ;
OG_data = white_rampXYZs;

% Assuming you have your VR and OG data as 16x3 matrices: VR_data and OG_data

% Objective function: computes the SSE for all 3 columns with different scaling and offsets
objectiveFunction = @(params) ...
    sum((VR_data(:, 1) - (params(1) * OG_data(:, 1) + params(4))).^2) + ... % 1st column
    sum((VR_data(:, 2) - (params(2) * OG_data(:, 2) + params(5))).^2) + ... % 2nd column
    sum((VR_data(:, 3) - (params(3) * OG_data(:, 3) + params(6))).^2);      % 3rd column

% Initial guess for scaling factors (a1, a2, a3) and offsets (b1, b2, b3)
initial_guess = [1, 1, 1, 0, 0, 0];  % Initial guess: a1=a2=a3=1, b1=b2=b3=0

% Use fminsearch to minimize the objective function
optimal_params = fminsearch(objectiveFunction, initial_guess);

% Extract optimal scaling factors and offsets for each column
optimal_a1 = optimal_params(1);
optimal_a2 = optimal_params(2);
optimal_a3 = optimal_params(3);
optimal_b1 = optimal_params(4);
optimal_b2 = optimal_params(5);
optimal_b3 = optimal_params(6);

% Apply the transformation to OG data for each column
OG_transformed(:, 1) = optimal_a1 * OG_data(:, 1) + optimal_b1;
OG_transformed(:, 2) = optimal_a2 * OG_data(:, 2) + optimal_b2;
OG_transformed(:, 3) = optimal_a3 * OG_data(:, 3) + optimal_b3;

% Plot the results for each column
figure;
plot(range,VR_data(:, 1), 'bo'); hold on;
plot(range,OG_transformed(:, 1), 'ro');
legend('VR (1st Column)', 'Transformed OG (1st Column)');
title('Optimized Mapping of OG to VR (1st Column)');
xlabel('Data Index');
ylabel('Luminance');

figure;
plot(range,VR_data(:, 2), 'go'); hold on;
plot(range,OG_transformed(:, 2), 'mo');
legend('VR (2nd Column)', 'Transformed OG (2nd Column)');
title('Optimized Mapping of OG to VR (2nd Column)');
xlabel('Data Index');
ylabel('Luminance')

figure;
plot(range,VR_data(:, 3), 'ko'); hold on;
plot(range,OG_transformed(:, 3), 'co');
legend('VR (3rd Column)', 'Transformed OG (3rd Column)');
title('Optimized Mapping of OG to VR (3rd Column)');
xlabel('Data Index');
ylabel('Luminance');
%%
fitData(:, 1) = optimal_a1 * XYZw_expect.w(:, 1) + optimal_b1;
fitData(:, 2) = optimal_a2 * XYZw_expect.w(:, 2)+ optimal_b2;
fitData(:, 3)= optimal_a3 * XYZw_expect.w(:, 3) + optimal_b3;