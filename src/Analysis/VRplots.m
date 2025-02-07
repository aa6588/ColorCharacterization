%VR plots
addpath 'C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src'
load VRData.mat
load VRData_CI.mat
load uv_aims_VR.mat
load FinalSceneIllums.mat illum_xyY
illum_uvY = xyY2uvY(illum_xyY);

%% separate into color illum tables for plot
%separate illums 
redData = finalTable(finalTable.Illuminant == 'r', :);
greenData = finalTable(finalTable.Illuminant == 'g', :);
blueData = finalTable(finalTable.Illuminant == 'b', :);
yellowData = finalTable(finalTable.Illuminant == 'y', :);
whiteData = finalTable(finalTable.Illuminant == 'w', :);

%% All color illums plots
figure;
w = scatter(whiteData.uvY(:,1),whiteData.uvY(:,2),50,'black','filled','o','MarkerEdgeColor','k');
alpha(w,0.1);
hold on
r = scatter(redData.uvY(:,1),redData.uvY(:,2),50,'red','filled','o','MarkerEdgeColor','k');
alpha(r,0.1);
g = scatter(greenData.uvY(:,1),greenData.uvY(:,2),50,'green','filled','o','MarkerEdgeColor','k');
alpha(g,0.1);
b = scatter(blueData.uvY(:,1),blueData.uvY(:,2),50,'blue','filled','o','MarkerEdgeColor','k');
alpha(b,0.1);
y = scatter(yellowData.uvY(:,1),yellowData.uvY(:,2),50,'yellow','filled','o','MarkerEdgeColor','k');
alpha(y,0.1);
%scatter(uv_aims.r.(lightness)(:,1),uv_aims.r.(lightness)(:,2),50,[.8 .8 .8],'o')
ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k');
gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k');
bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k');
yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k');
wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks');
hold off
xlabel('u')
ylabel('v')
xlim([.16 .24]);
ylim([.41 .52]);
title('[VR] Illuminant Achromatic Chromaticity Selections')
legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})

%CI plots average all illum, each illum CI
avg_CIs = groupsummary(avgDataCI,{'Illuminant'},'mean','CI');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI', 'Illuminant');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'r', 'g', 'b','y'}};
newNames = {'r', 'g', 'b','y'};
figure;
h = bar(data_matrix, 'grouped');
h.FaceColor = 'flat';
h.CData = [.8 0 0; 0 .8 0; 0 0 .9; .9 .9 0];
set(gca, 'XTick',1:numel(newNames), 'XtickLabel',newNames)
ylim([0 .8])
xlabel('Illuminant')
ylabel('Constancy Index')
title('[VR] Average Constancy Index per Illuminant')
%% WHITE
x = whiteData.uvY(:,1);
y = whiteData.uvY(:,2);
figure;
s = scatter(x,y,50,'black','filled','MarkerEdgeColor','k');
alpha(s,0.2);
hold on
%scatter(uv_aims.r.(lightness)(:,1),uv_aims.r.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')
hold off
xlabel('u')
ylabel('v')
title('White Illuminant Achromatic Chromaticity Selections')
%% RED
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = redData(redData.Lightness == lightness, :);
        x = currentData.uvY(:,1);
        y = currentData.uvY(:,2);
%x = redData.uvY(:,1);
%y = redData.uvY(:,2);
figure;
s = scatter(x,y,50,'red','filled');
alpha(s,0.2);
hold on
scatter(uv_aims.r.(lightness)(:,1),uv_aims.r.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')
hold off
xlabel('u')
ylabel('v')
title('Red Illuminant Achromatic Chromaticity Selections')
end
%GRID LIGHTNESS CHROMATICITY PLOTS (HEATMAP)
% lightnessValues = {'L40', 'L55','L70'};
% for i = 1:length(lightnessValues)
%         lightness = lightnessValues{i};
%         % Extract the subset for the current lightness
%         currentData = redData(redData.Lightness == lightness, :);
% [unique_coords, ~, ind] = unique(currentData.uvY(:,1:2), 'rows');
% counts = accumarray(ind, 1);
% 
% % Separate data for plotting
% x = unique_coords(:, 1);
% y = unique_coords(:, 2);
% c = counts;
% 
% map = [.3 0 0; .5 0 0; .7 0 0];
% % Create scatter plot
% figure;
% scatter_handle = scatter(x, y, 50, c, 'filled');
% %num_steps = numel(unique(c));
% %colormap(copper(num_steps))
% colormap(map)
% cb = colorbar;
% cb.Ticks = min(c):max(c);
% %clim([min(c), max(c)]);
% 
% hold on
% scatter(uv_aims.r.(lightness)(:,1),uv_aims.r.(lightness)(:,2),50,[.8 .8 .8],'o')
% scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs')
% scatter(illum_uvY(1,1),illum_uvY(1,2),60,'k*')
% 
% % Add labels and grid
% xlabel('u');
% ylabel('v');
% title(['Participant responses Red Illuminant ', lightness]);
% grid on;
% end

% CI plots
avgRedData = avgDataCI(avgDataCI.Illuminant == 'r', :);
avg_CIs = groupsummary(avgRedData,{'ParticipantID','Lightness'},'mean','CI');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
figure;
h = bar(data_matrix, 'grouped');
xlabel('Participant')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness Under Red Illuminant')
%% GREEN
% Count occurrences of each (x, y) pair
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = greenData(greenData.Lightness == lightness, :);
[unique_coords, ~, ind] = unique(currentData.uvY(:,1:2), 'rows');
counts = accumarray(ind, 1);

% Separate data for plotting
x = unique_coords(:, 1);
y = unique_coords(:, 2);
c = counts;

map = [0 .3 0; 0 0.5 0; 0 0.7 0];
% Create scatter plot
figure;
scatter_handle = scatter(x, y, 50, c, 'filled');
%num_steps = numel(unique(c));
%colormap(copper(num_steps))
colormap(map)
cb = colorbar;
cb.Ticks = min(c):max(c);
%clim([min(c), max(c)]);

hold on
scatter(uv_aims.g.(lightness)(:,1),uv_aims.g.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'k*')

% Add labels and grid
xlabel('u');
ylabel('v');
title(['Participant responses Green Illuminant ', lightness]);
grid on;
end

% CI plots
avg_CIs = groupsummary(greenData,{'ParticipantID','Lightness'},'mean','CI');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
figure;
h = bar(data_matrix, 'grouped');
xlabel('Participant')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness Under Green Illuminant')
%% blue
% Count occurrences of each (x, y) pair
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = blueData(blueData.Lightness == lightness, :);
[unique_coords, ~, ind] = unique(currentData.uvY(:,1:2), 'rows');
counts = accumarray(ind, 1);

% Separate data for plotting
x = unique_coords(:, 1);
y = unique_coords(:, 2);
c = counts;

map = [0 0 0.3; 0 0 0.5; 0 0 0.7];
% Create scatter plot
figure;
scatter_handle = scatter(x, y, 50, c, 'filled');
%num_steps = numel(unique(c));
%colormap(copper(num_steps))
colormap(map)
cb = colorbar;
cb.Ticks = min(c):max(c);
%clim([min(c), max(c)]);

hold on
scatter(uv_aims.b.(lightness)(:,1),uv_aims.b.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'k*')

% Add labels and grid
xlabel('u');
ylabel('v');
title(['Participant responses Blue Illuminant ', lightness]);
grid on;
end

% CI plots
avg_CIs = groupsummary(blueData,{'ParticipantID','Lightness'},'mean','CI');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
figure;
h = bar(data_matrix, 'grouped');
xlabel('Participant')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness Under Blue Illuminant')
%% yellow
% Count occurrences of each (x, y) pair
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = yellowData(yellowData.Lightness == lightness, :);
[unique_coords, ~, ind] = unique(currentData.uvY(:,1:2), 'rows');
counts = accumarray(ind, 1);

% Separate data for plotting
x = unique_coords(:, 1);
y = unique_coords(:, 2);
c = counts;

map = [.4 .4 0; .6 .6 0; .8 .8 0];
% Create scatter plot
figure;
scatter_handle = scatter(x, y, 50, c, 'filled');
%num_steps = numel(unique(c));
%colormap(copper(num_steps))
colormap(map)
cb = colorbar;
cb.Ticks = min(c):max(c);
%clim([min(c), max(c)]);

hold on
scatter(uv_aims.y.(lightness)(:,1),uv_aims.y.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'k*')

% Add labels and grid
xlabel('u');
ylabel('v');
title(['Participant responses Yellow Illuminant ', lightness]);
grid on;
end

% CI plots
avg_CIs = groupsummary(yellowData,{'ParticipantID','Lightness'},'mean','CI');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
figure;
h = bar(data_matrix, 'grouped');
xlabel('Participant')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness Under Yellow Illuminant')