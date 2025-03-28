%lightness comparison 
%CI white is everything in first block
cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\
load VRData.mat %doing VR data

%delete extra interjected trials 
idx = (finalTable.Illuminant == 'w') & (finalTable.Lightness == 'L55') & (finalTable.Rep > 3); 
% Remove those rows from the table
finalTable(idx, :) = []; %index to interjected white trials

%average repetition XYZs
avgTable = groupsummary(finalTable,{'ParticipantID','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
mergedTable = innerjoin(avgTable, unique(finalTable(:, {'ParticipantID' , 'Illuminant','illum_order','Mode'})), 'Keys', {'ParticipantID', 'Illuminant'});
mergedTable.CI = zeros(height(mergedTable),1);
%white chrom XYZ
D65XYZ = whitepoint("d65").*model.w.wp(2);
w_uv = XYZ2uvY(D65XYZ);
% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};
mergedTable.uvY = XYZ2uvY(mergedTable.mean_XYZ);

% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};

    % Find the row indices where Illuminant matches current_illum
    rows = find(mergedTable.Illuminant == current_illum);
    rows_white = find(mergedTable.Illuminant == 'w'); 

    % Extract necessary data once
    obsXYZ = mergedTable.mean_XYZ(rows, :);
    adj_uv = mergedTable.uvY(rows, :);
    adjXYZ_white = mergedTable.mean_XYZ(rows_white, :);
    adj_uv_white = mergedTable.uvY(rows_white, :);

    % Get chromatic illuminant uv (changes)
    chrom_test_uv = illum_uvY(i+1, :);

    % Ensure preallocation of recenter_uv and CI columns if not already done
    if ~ismember('recenter_uv', mergedTable.Properties.VariableNames)
        mergedTable.recenter_uv = nan(height(mergedTable), 2);
    end
    if ~ismember('CI', mergedTable.Properties.VariableNames)
        mergedTable.CI = nan(height(mergedTable), 1);
    end
    if ~ismember('delta_uv', mergedTable.Properties.VariableNames)
        mergedTable.delta_uv = nan(height(mergedTable), 1);
    end
    % Calculate recentered UV and CI for each participant
    for part = 1:length(obsXYZ)
        recentered_uv = recenter(adjXYZ_white(part,:), obsXYZ(part,:), D65XYZ);
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), adj_uv_white(part,1:2), adj_uv(part,1:2));
        mergedTable.recenter_uv(rows(part), :) = recentered_uv; 
        mergedTable.CI(rows(part)) = CI_value;
        mergedTable.delta_uv(rows(part)) = delta_uv_value;
    end
end

avgDataCI_all = mergedTable;

%separate by lightness
avgTable = groupsummary(finalTable,{'ParticipantID','Lightness','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
mergedTable = innerjoin(avgTable, unique(finalTable(:, {'ParticipantID' ,'Lightness', 'Illuminant','illum_order','Mode'})), 'Keys', {'ParticipantID', 'Lightness', 'Illuminant'});
mergedTable.CI = zeros(height(mergedTable),1);
%white chrom XYZ
D65XYZ = whitepoint("d65").*model.w.wp(2);
w_uv = XYZ2uvY(D65XYZ);
% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};
mergedTable.uvY = XYZ2uvY(mergedTable.mean_XYZ);

% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};

    % Find the row indices where Illuminant matches current_illum
    rows = find(mergedTable.Illuminant == current_illum);
    rows_white = find(mergedTable.Illuminant == 'w'); 

    % Extract necessary data once
    obsXYZ = mergedTable.mean_XYZ(rows, :);
    adj_uv = mergedTable.uvY(rows, :);
    adjXYZ_white = mergedTable.mean_XYZ(rows_white, :);
    adj_uv_white = mergedTable.uvY(rows_white, :);

    % Get chromatic illuminant uv (changes)
    chrom_test_uv = illum_uvY(i+1, :);

    % Ensure preallocation of recenter_uv and CI columns if not already done
    if ~ismember('recenter_uv', mergedTable.Properties.VariableNames)
        mergedTable.recenter_uv = nan(height(mergedTable), 2);
    end
    if ~ismember('CI', mergedTable.Properties.VariableNames)
        mergedTable.CI = nan(height(mergedTable), 1);
    end
    if ~ismember('delta_uv', mergedTable.Properties.VariableNames)
        mergedTable.delta_uv = nan(height(mergedTable), 1);
    end
    % Calculate recentered UV and CI for each participant
    for part = 1:length(obsXYZ)
        recentered_uv = recenter(adjXYZ_white(part,:), obsXYZ(part,:), D65XYZ);
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), adj_uv_white(part,1:2), adj_uv(part,1:2));
        mergedTable.recenter_uv(rows(part), :) = recentered_uv; 
        mergedTable.CI(rows(part)) = CI_value;
        mergedTable.delta_uv(rows(part)) = delta_uv_value;
    end
end

avgDataCI_lightness = mergedTable;

%plots
avg_CIs_all = groupsummary(avgDataCI_all,{'Illuminant'},'mean','CI');
avg_CIs_lightness = groupsummary(avgDataCI_lightness,{'Illuminant','Lightness'},'mean','CI');
T_wide = unstack(avg_CIs_lightness, 'mean_CI', 'Lightness');
T_wide_All = unstack(avg_CIs_all, 'mean_CI','Illuminant');
data_matrix_all = T_wide_All{:, {'b','g','r','w','y'}};
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
barplot = [data_matrix,data_matrix_all'];
barplot = [barplot(1:3,:);barplot(5,:)];
figure;
h = bar(barplot, 'grouped');
title('[VR] Lightness Separated CI per Illuminant')
xlabel('Illuminants')
xticklabels({'b','g','r','y'})
legend({'L40','L55','L70','Average'})

% Run two-way ANOVA
[p, tbl, stats] = anovan(avgDataCI_lightness.CI, {avgDataCI_lightness.Lightness, avgDataCI_lightness.Illuminant}, ...
    'model', 'interaction', 'varnames', {'Lightness', 'Illuminant'});

% Display ANOVA table
disp(tbl)
%If p(1) < 0.05, lightness significantly affects CI.
%If p(2) < 0.05, illuminant significantly affects CI.
%If p(3) < 0.05, there is a significant interaction between lightness and illuminant.

%% ellipses scatter
% Define unique illuminants and lightness levels
illuminants = {'w','r','g','b','y'};
illuminants_plot ={'k','r','g','b','y'};
lightness_levels = {'L40', 'L55', 'L70'}; % Cell array

% Define base colors for each illuminant (RGBY pattern)
base_colors = [ 
    1 1 1; %white
    1 0 0;  % Red
    0 1 0;  % Green
    0 0 1;  % Blue
    1 1 0]; % Yellow

% Map illuminants to base colors
illuminant_color_map = containers.Map(illuminants, num2cell(base_colors, 2));

% Define lightness intensity scaling (L40 → 0.5, L55 → 0.7, L70 → 0.9)
lightness_scaling = containers.Map(lightness_levels, [0.5, 0.7, 0.9]);

figure; hold on; grid on;
xlabel('u'); ylabel('v');
title('[VR] uv chromaticity per lightness for all participants (average reps)');

% Loop through illuminants and lightness levels
for i = 1:length(illuminants)
    baseColor = illuminant_color_map(illuminants{i}); % Get base color
    
    for j = 1:length(lightness_levels)
        % Get data for this illuminant & lightness
        idx = (avgDataCI_lightness.Illuminant == illuminants{i}) & (avgDataCI_lightness.Lightness == lightness_levels{j});
        u_vals = avgDataCI_lightness.uvY(idx,1);
        v_vals = avgDataCI_lightness.uvY(idx,2);

        % Adjust color intensity
        plotColor = baseColor * lightness_scaling(lightness_levels{j});

        % Scatter plot
        scatter(u_vals, v_vals, 50, plotColor, 'filled', 'DisplayName', sprintf('%s %s', illuminants{i}, lightness_levels{j}));

        % Compute ellipse and average (assuming function [ellipseX, ellipseY, avgU, avgV] = myEllipseFunction(u, v))
        [mu, ellipse] = compute_2std_ellipse(u_vals, v_vals);

        % Plot ellipse
        plot(ellipse(1,:), ellipse(2,:), 'Color', illuminants_plot{i}, 'LineWidth', 1.5);

        % Mark the average with an "X"
        plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2);
    end
end

hold off;

%% Flat version

load FLATData.mat

idx = (finalTable.Illuminant == 'w') & (finalTable.Lightness == 'L55') & (finalTable.Rep > 3); 
% Remove those rows from the table
finalTable(idx, :) = []; %index to interjected white trials

%average repetition XYZs
avgTable = groupsummary(finalTable,{'ParticipantID','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
mergedTable = innerjoin(avgTable, unique(finalTable(:, {'ParticipantID' , 'Illuminant','illum_order','Mode'})), 'Keys', {'ParticipantID', 'Illuminant'});
mergedTable.CI = zeros(height(mergedTable),1);
%white chrom XYZ
D65XYZ = whitepoint("d65").*model.w.wp(2);
w_uv = XYZ2uvY(D65XYZ);
% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};
mergedTable.uvY = XYZ2uvY(mergedTable.mean_XYZ);

% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};

    % Find the row indices where Illuminant matches current_illum
    rows = find(mergedTable.Illuminant == current_illum);
    rows_white = find(mergedTable.Illuminant == 'w'); 

    % Extract necessary data once
    obsXYZ = mergedTable.mean_XYZ(rows, :);
    adj_uv = mergedTable.uvY(rows, :);
    adjXYZ_white = mergedTable.mean_XYZ(rows_white, :);
    adj_uv_white = mergedTable.uvY(rows_white, :);

    % Get chromatic illuminant uv (changes)
    chrom_test_uv = illum_uvY(i+1, :);

    % Ensure preallocation of recenter_uv and CI columns if not already done
    if ~ismember('recenter_uv', mergedTable.Properties.VariableNames)
        mergedTable.recenter_uv = nan(height(mergedTable), 2);
    end
    if ~ismember('CI', mergedTable.Properties.VariableNames)
        mergedTable.CI = nan(height(mergedTable), 1);
    end
    if ~ismember('delta_uv', mergedTable.Properties.VariableNames)
        mergedTable.delta_uv = nan(height(mergedTable), 1);
    end
    % Calculate recentered UV and CI for each participant
    for part = 1:length(obsXYZ)
        recentered_uv = recenter(adjXYZ_white(part,:), obsXYZ(part,:), D65XYZ);
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), adj_uv_white(part,1:2), adj_uv(part,1:2));
        mergedTable.recenter_uv(rows(part), :) = recentered_uv; 
        mergedTable.CI(rows(part)) = CI_value;
        mergedTable.delta_uv(rows(part)) = delta_uv_value;
    end
end

avgDataCI_all = mergedTable;

%separate by lightness
avgTable = groupsummary(finalTable,{'ParticipantID','Lightness','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
mergedTable = innerjoin(avgTable, unique(finalTable(:, {'ParticipantID' ,'Lightness', 'Illuminant','illum_order','Mode'})), 'Keys', {'ParticipantID', 'Lightness', 'Illuminant'});
mergedTable.CI = zeros(height(mergedTable),1);
%white chrom XYZ
D65XYZ = whitepoint("d65").*model.w.wp(2);
w_uv = XYZ2uvY(D65XYZ);
% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};
mergedTable.uvY = XYZ2uvY(mergedTable.mean_XYZ);

% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};

    % Find the row indices where Illuminant matches current_illum
    rows = find(mergedTable.Illuminant == current_illum);
    rows_white = find(mergedTable.Illuminant == 'w'); 

    % Extract necessary data once
    obsXYZ = mergedTable.mean_XYZ(rows, :);
    adj_uv = mergedTable.uvY(rows, :);
    adjXYZ_white = mergedTable.mean_XYZ(rows_white, :);
    adj_uv_white = mergedTable.uvY(rows_white, :);

    % Get chromatic illuminant uv (changes)
    chrom_test_uv = illum_uvY(i+1, :);

    % Ensure preallocation of recenter_uv and CI columns if not already done
    if ~ismember('recenter_uv', mergedTable.Properties.VariableNames)
        mergedTable.recenter_uv = nan(height(mergedTable), 2);
    end
    if ~ismember('CI', mergedTable.Properties.VariableNames)
        mergedTable.CI = nan(height(mergedTable), 1);
    end
    if ~ismember('delta_uv', mergedTable.Properties.VariableNames)
        mergedTable.delta_uv = nan(height(mergedTable), 1);
    end
    % Calculate recentered UV and CI for each participant
    for part = 1:length(obsXYZ)
        recentered_uv = recenter(adjXYZ_white(part,:), obsXYZ(part,:), D65XYZ);
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), adj_uv_white(part,1:2), adj_uv(part,1:2));
        mergedTable.recenter_uv(rows(part), :) = recentered_uv; 
        mergedTable.CI(rows(part)) = CI_value;
        mergedTable.delta_uv(rows(part)) = delta_uv_value;
    end
end

avgDataCI_lightness = mergedTable;

%plots
avg_CIs_all = groupsummary(avgDataCI_all,{'Illuminant'},'mean','CI');
avg_CIs_lightness = groupsummary(avgDataCI_lightness,{'Illuminant','Lightness'},'mean','CI');
T_wide = unstack(avg_CIs_lightness, 'mean_CI', 'Lightness');
T_wide_All = unstack(avg_CIs_all, 'mean_CI','Illuminant');
data_matrix_all = T_wide_All{:, {'b','g','r','w','y'}};
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
barplot = [data_matrix,data_matrix_all'];
barplot = [barplot(1:3,:);barplot(5,:)];
figure;
h = bar(barplot, 'grouped');
title('[Flat] Lightness Separated CI per Illuminant')
xlabel('Illuminants')
ylim([0 .8])
xticklabels({'b','g','r','y'})
legend({'L40','L55','L70','Average'})

% Run two-way ANOVA
[p, tbl, stats] = anovan(avgDataCI_lightness.CI, {avgDataCI_lightness.Lightness, avgDataCI_lightness.Illuminant}, ...
    'model', 'interaction', 'varnames', {'Lightness', 'Illuminant'});

% Display ANOVA table
disp(tbl)
%If p(1) < 0.05, lightness significantly affects CI.
%If p(2) < 0.05, illuminant significantly affects CI.
%If p(3) < 0.05, there is a significant interaction between lightness and illuminant.