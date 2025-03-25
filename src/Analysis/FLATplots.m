%Flat plots
addpath 'C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src'
load FLATData.mat
%load FLATData_CI.mat
load uv_aims_FLAT.mat
load FinalSceneIllums.mat illum_xyY
illum_uvY = xyY2uvY(illum_xyY);

% separate into color illum tables for plot
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
g = scatter(greenData.uvY(:,1),greenData.uvY(:,2),50,'green','filled','MarkerEdgeColor','k');
alpha(g,0.1);
b = scatter(blueData.uvY(:,1),blueData.uvY(:,2),50,'blue','filled','MarkerEdgeColor','k');
alpha(b,0.1);
y = scatter(yellowData.uvY(:,1),yellowData.uvY(:,2),50,'yellow','filled','MarkerEdgeColor','k');
alpha(y,0.1);
%scatter(uv_aims.r.(lightness)(:,1),uv_aims.r.(lightness)(:,2),50,[.8 .8 .8],'o')
ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k');
gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k');
bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k');
yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k');
wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks');

colors = {[.9 0 0], [0 .9 0], [0 0 .9], [.9 .9 0]}; % Colors for ellipses
datasets = {whiteData.uvY(:,1), whiteData.uvY(:,2); redData.uvY(:,1), redData.uvY(:,2); greenData.uvY(:,1), greenData.uvY(:,2); blueData.uvY(:,1), blueData.uvY(:,2); yellowData.uvY(:,1), yellowData.uvY(:,2)}; % Store data pairs
for i = 1:5
    [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
    plot(ellipse_translated(1, :), ellipse_translated(2, :),'Color', colors{i}, 'LineWidth', 2);
    plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
end
hold off
xlabel('u′')
ylabel('v′')
xlim([.16 .24]);
ylim([.41 .52]);
title('[FLAT] Illuminant Achromatic Chromaticity Selections')
legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})

% recentered uv's for all trials (recenter uv 2, white is average of all
% white block for each participant
figure;
r = scatter(redData.recenter_uv_2(:,1),redData.recenter_uv_2(:,2),50,'red','filled','o','MarkerEdgeColor','k');
alpha(r,0.1);
hold on;
g = scatter(greenData.recenter_uv_2(:,1),greenData.recenter_uv_2(:,2),50,'green','filled','o','MarkerEdgeColor','k');
alpha(g,0.1);
b = scatter(blueData.recenter_uv_2(:,1),blueData.recenter_uv_2(:,2),50,'blue','filled','o','MarkerEdgeColor','k');
alpha(b,0.1);
y = scatter(yellowData.recenter_uv_2(:,1),yellowData.recenter_uv_2(:,2),50,'yellow','filled','o','MarkerEdgeColor','k');
alpha(y,0.1);
%scatter(uv_aims.r.(lightness)(:,1),uv_aims.r.(lightness)(:,2),50,[.8 .8 .8],'o')
ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k');
gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k');
bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k');
yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k');
wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks');

%plot ellipses
colors = {[.9 0 0], [0 .9 0], [0 0 .9], [.9 .9 0]}; % Colors for ellipses
datasets = {redData.recenter_uv_2(:,1), redData.recenter_uv_2(:,2); greenData.recenter_uv_2(:,1), greenData.recenter_uv_2(:,2);...
    blueData.recenter_uv_2(:,1), blueData.recenter_uv_2(:,2); yellowData.recenter_uv_2(:,1), yellowData.recenter_uv_2(:,2)}; % Store data pairs
for i = 1:4
    [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
    plot(ellipse_translated(1, :), ellipse_translated(2, :), 'Color',colors{i}, 'LineWidth', 2);
    plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
end
hold off;
xlabel('u′')
ylabel('v′')
xlim([.16 .24]);
ylim([.41 .52]);
title('[Flat] Recentered Achromatic Chromaticity Selections')
legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})

% average recenter (avg reps and lightness)
avg_R = groupsummary(redData,{'ParticipantID'},'mean','recenter_uv_2');
avg_G = groupsummary(greenData,{'ParticipantID'},'mean','recenter_uv_2');
avg_B = groupsummary(blueData,{'ParticipantID'},'mean','recenter_uv_2');
avg_Y = groupsummary(yellowData,{'ParticipantID'},'mean','recenter_uv_2');

%figure;
r1 = scatter(avg_R.mean_recenter_uv_2(:,1),avg_R.mean_recenter_uv_2(:,2),50,'red','filled','^','MarkerEdgeColor','k');
alpha(r1,0.1);
hold on;
g1 = scatter(avg_G.mean_recenter_uv_2(:,1),avg_G.mean_recenter_uv_2(:,2),50,'green','filled','^','MarkerEdgeColor','k');
alpha(g1,0.1);
b1 = scatter(avg_B.mean_recenter_uv_2(:,1),avg_B.mean_recenter_uv_2(:,2),50,'blue','filled','^','MarkerEdgeColor','k');
alpha(b1,0.1);
y1 = scatter(avg_Y.mean_recenter_uv_2(:,1),avg_Y.mean_recenter_uv_2(:,2),50,'yellow','filled','^','MarkerEdgeColor','k');
alpha(y1,0.1);

ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k');
gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k');
bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k');
yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k');
wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks');

%plot ellipses
colors = {[.9 0 0], [0 .9 0], [0 0 .9], [.9 .9 0]}; % Colors for ellipses
datasets = {avg_R.mean_recenter_uv_2(:,1), avg_R.mean_recenter_uv_2(:,2); avg_G.mean_recenter_uv_2(:,1), avg_G.mean_recenter_uv_2(:,2);...
    avg_B.mean_recenter_uv_2(:,1), avg_B.mean_recenter_uv_2(:,2); avg_Y.mean_recenter_uv_2(:,1), avg_Y.mean_recenter_uv_2(:,2)}; % Store data pairs
for i = 1:4
    [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
    s1 = plot(ellipse_translated(1, :), ellipse_translated(2, :), 'Color',colors{i}, 'LineWidth', 2,'LineStyle','--');
    m1 = plot(mu(1), mu(2), 'k*', 'MarkerSize', 10, 'LineWidth', 1.5); % Mean marker
end
hold off;
xlabel('u′')
ylabel('v′')
xlim([.16 .24]);
ylim([.41 .52]);
title('[Flat] Average (Reps and Lightness) Recentered Achromatic Chromaticity')
legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})

h1 = plot(nan, nan, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'none'); % Square, no fill
h2 = plot(nan, nan, '^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'none'); % Triangle, no fil
h3 = plot(nan, nan,'Color', 'k','LineWidth', 2,'LineStyle','--'); % dashed, no fill
h4 = plot(nan, nan, 'Color','k','LineWidth', 2,'LineStyle','-'); % line, no fil
legend([wi,ri,gi,bi,yi,h1,h2,m,h4,m1,h3],{'white illum','red illum','green illum','blue illum','yellow illum','VR','Flat','VR mean','VR std','Flat mean','Flat std'})
% % average recenter (Reps only)
% avg_R = groupsummary(redData,{'ParticipantID','Lightness'},'mean','recenter_uv_2');
% avg_G = groupsummary(greenData,{'ParticipantID','Lightness'},'mean','recenter_uv_2');
% avg_B = groupsummary(blueData,{'ParticipantID','Lightness'},'mean','recenter_uv_2');
% avg_Y = groupsummary(yellowData,{'ParticipantID','Lightness'},'mean','recenter_uv_2');
% 
% figure;
% r = scatter(avg_R.mean_recenter_uv_2(:,1),avg_R.mean_recenter_uv_2(:,2),50,'red','filled','o','MarkerEdgeColor','k');
% alpha(r,0.1);
% hold on;
% g = scatter(avg_G.mean_recenter_uv_2(:,1),avg_G.mean_recenter_uv_2(:,2),50,'green','filled','o','MarkerEdgeColor','k');
% alpha(g,0.1);
% b = scatter(avg_B.mean_recenter_uv_2(:,1),avg_B.mean_recenter_uv_2(:,2),50,'blue','filled','o','MarkerEdgeColor','k');
% alpha(b,0.1);
% y = scatter(avg_Y.mean_recenter_uv_2(:,1),avg_Y.mean_recenter_uv_2(:,2),50,'yellow','filled','o','MarkerEdgeColor','k');
% alpha(y,0.1);
% 
% ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k');
% gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k');
% bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k');
% yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k');
% wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks');
% 
% %plot ellipses
% colors = {'r', 'g', 'b', 'y'}; % Colors for ellipses
% datasets = {avg_R.mean_recenter_uv_2(:,1), avg_R.mean_recenter_uv_2(:,2); avg_G.mean_recenter_uv_2(:,1), avg_G.mean_recenter_uv_2(:,2);...
%     avg_B.mean_recenter_uv_2(:,1), avg_B.mean_recenter_uv_2(:,2); avg_Y.mean_recenter_uv_2(:,1), avg_Y.mean_recenter_uv_2(:,2)}; % Store data pairs
% for i = 1:4
%     [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
%     plot(ellipse_translated(1, :), ellipse_translated(2, :), colors{i}, 'LineWidth', 2);
%     plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
% end
% hold off;
% xlabel('u')
% ylabel('v')
% xlim([.16 .24]);
% ylim([.41 .52]);
% title('[Flat] Average (Reps) Recentered Achromatic Chromaticity')
% legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})

%% CI plots lightness each illum CI

mat = readtable('em_df_results_lightness.csv');
errors = mat{1:2:end,5}; 
means = mat{1:2:end,4};
means = reshape(means,4,3);
errors =reshape(errors,4,3); 
%avg_CIs = groupsummary(finalTable,{'Illuminant','Lightness'},'mean','CI_2_recenter');
%reshape table
% Reshape from long to wide format
%T_wide = unstack(avg_CIs, 'mean_CI_2_recenter', 'Illuminant');
% Convert the table to a matrix for plotting
%data_matrix = T_wide{1:3, {'r', 'g', 'b','y'}};
newNames = {'Red','Green','Blue','Yellow'};
figure;
h = bar(means, 'grouped');
hold on
[numGroups, numBars] = size(means);

% X positions for error bars
x = nan(numGroups, numBars);
for i = 1:numBars
    x(:,i) = h(i).XEndPoints;  % Get the X positions for each bar
end

% Add error bars
for i = 1:numBars
    errorbar(x(:,i), means(:,i), errors(:,i), 'k','LineStyle', 'none','LineWidth',1);
end
h(1).FaceColor = 'flat';
h(2).FaceColor = 'flat';
h(3).FaceColor = 'flat';
%h(4).FaceColor = 'flat';
h(1).CData = [.5 0 0; 0 .5 0; 0 0 .5; .5 .5 0];
h(2).CData = [.7 0 0; 0 .7 0; 0 0 .7;.7 .7 0];
h(3).CData = [.9 0 0; 0 .9 0; 0 0 .9;.9 .9 0];
%h(4).CData = [.5 .5 0; .7 .7 0; .9 .9 0];
set(gca, 'XTick',1:numel(newNames), 'XtickLabel',newNames)
xlabel('Lightness')
ylabel('Constancy Index')
ylim([0 .8])
title('[Flat] Average Constancy Index per Illuminant per Lightness')
legend([h(1) h(2) h(3)],{'L40','L55','L70'})
%lightness separate line plot
clrs = {'r','g','b',[.8 .8 0]};
figure
grid on;
hold on;
%means = means';
%errors = errors';
xtic = {'L40', 'L55', 'L70'};
for i = 1:size(means, 1)
    plot([1 2 3], means(i, :), 'o-','Color',clrs{i});
    errorbar(means(i,:), errors(i,:), 'k','LineStyle', 'none','LineWidth',1,'Color',clrs{i});
end

% Set categorical x-ticks
xticks(1:3);
xticklabels(xtic);
xlim([0.5, 3 + 0.5]);  % Adds padding on both sides
ylim([0, 1]); 
xlabel('Lightness');
ylabel('Constancy Index');
title('[Flat] Average CIs per Illuminant per Lightness');
%% WHITE
x = whiteData.uvY(:,1);
y = whiteData.uvY(:,2);
figure;
s = scatter(x,y,50,'black','filled','MarkerEdgeColor','k');
alpha(s,0.1);
hold on
%scatter(uv_aims.w.(lightness)(:,1),uv_aims.w.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')
hold off
xlabel('u')
ylabel('v')
title('White Illuminant Achromatic Chromaticity Selections')

color = {'r','g','b'};
figure;
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = whiteData(whiteData.Lightness == lightness, :);
        x = currentData.uvY(:,1);
        y = currentData.uvY(:,2);
%x = redData.uvY(:,1);
%y = redData.uvY(:,2);
%figure;

hold on
s = scatter(x,y,50,'black','filled');
alpha(s,0.1);

%scatter(uv_aims.w.(lightness)(:,1),uv_aims.w.(lightness)(:,2),50,[.8 .8 .8],'o')
%scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')

    [mu, ellipse_translated] = compute_2std_ellipse(x ,y);
    h(i) = plot(ellipse_translated(1, :), ellipse_translated(2, :), color{i}, 'LineWidth', 2);
    plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
hold off
end
xlabel('u')
ylabel('v')
title('White Illuminant Achromatic Chromaticity Selections')
legend([h(1), h(2), h(3)],{'L40','L55','L70'})
ylim([.43 .49])
xlim([.17 .23])

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

% CI plots
avgRedData = finalTable(finalTable.Illuminant == 'r', :);
avg_CIs = groupsummary(avgRedData,{'ParticipantID','Lightness'},'mean','CI_1_recenter');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI_1_recenter', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
cats = string(unique(avg_CIs.ParticipantID));
figure;
h = bar(data_matrix, 'grouped');
xticks(1:length(cats))
xticklabels(cats)
xlabel('Participant')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness Under Red Illuminant')

%scatter 
figure
hold on;
xtic = {'L40', 'L55', 'L70'};
for i = 1:size(data_matrix, 1)
    plot([1 2 3], data_matrix(i, :), 'o-');
end
avg_all = mean(data_matrix);
plot([1 2 3], avg_all,'o-','Color','r','LineWidth',2)
% Set categorical x-ticks
xticks(1:3);
xticklabels(xtic);
xlabel('Lightness');
ylabel('Constancy Index');
title('[Flat] Red Illuminant Average CIs per Lightness');
%% GREEN
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = greenData(greenData.Lightness == lightness, :);
        x = currentData.uvY(:,1);
        y = currentData.uvY(:,2);
%x = redData.uvY(:,1);
%y = redData.uvY(:,2);
figure;
s = scatter(x,y,50,'green','filled');
alpha(s,0.2);
hold on
scatter(uv_aims.g.(lightness)(:,1),uv_aims.g.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')
hold off
xlabel('u')
ylabel('v')
title('[FLAT] Green Illuminant Achromatic Chromaticity Selections')
end

% CI plots
avgGreenData = finalTable(finalTable.Illuminant == 'g', :);
avg_CIs = groupsummary(avgGreenData,{'ParticipantID','Lightness'},'mean','CI_1_recenter');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI_1_recenter', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
cats = string(unique(avg_CIs.ParticipantID));
figure;
h = bar(data_matrix, 'grouped');
xticks(1:length(cats))
xticklabels(cats)
xlabel('Participant')
ylabel('Constancy Index')
title('[FLAT] Average Constancy Index per Lightness Under Green Illuminant')

%scatter 
figure
hold on;
xtic = {'L40', 'L55', 'L70'};
for i = 1:size(data_matrix, 1)
    plot([1 2 3], data_matrix(i, :), 'o-');
end
avg_all = mean(data_matrix);
plot([1 2 3], avg_all,'o-','Color','g','LineWidth',2)
% Set categorical x-ticks
xticks(1:3);
xticklabels(xtic);
xlabel('Lightness');
ylabel('Constancy Index');
title('[Flat] Green Illuminant Average CIs per Lightness');
%% blue
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = blueData(blueData.Lightness == lightness, :);
        x = currentData.uvY(:,1);
        y = currentData.uvY(:,2);
%x = redData.uvY(:,1);
%y = redData.uvY(:,2);
figure;
s = scatter(x,y,50,'blue','filled');
alpha(s,0.2);
hold on
scatter(uv_aims.b.(lightness)(:,1),uv_aims.b.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')
hold off
xlabel('u')
ylabel('v')
title('[FLAT] Blue Illuminant Achromatic Chromaticity Selections')
end

% CI plots
avgBlueData = avgDataCI(avgDataCI.Illuminant == 'b', :);
avg_CIs = groupsummary(avgBlueData,{'ParticipantID','Lightness'},'mean','CI');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
cats = string(unique(avg_CIs.ParticipantID));
figure;
h = bar(data_matrix, 'grouped');
xticks(1:length(cats))
xticklabels(cats)
xlabel('Participant')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness Under Blue Illuminant')
%% yellow
lightnessValues = {'L40', 'L55','L70'};
for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = yellowData(yellowData.Lightness == lightness, :);
        x = currentData.uvY(:,1);
        y = currentData.uvY(:,2);
%x = redData.uvY(:,1);
%y = redData.uvY(:,2);
figure;
s = scatter(x,y,50,'yellow','filled');
alpha(s,0.2);
hold on
scatter(uv_aims.y.(lightness)(:,1),uv_aims.y.(lightness)(:,2),50,[.8 .8 .8],'o')
scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys')
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')
hold off
xlabel('u')
ylabel('v')
title('[FLAT] Yellow Illuminant Achromatic Chromaticity Selections')
end

% CI plots
avgYellowData = avgDataCI(avgDataCI.Illuminant == 'y', :);
avg_CIs = groupsummary(avgYellowData,{'ParticipantID','Lightness'},'mean','CI');
%reshape table
% Reshape from long to wide format
T_wide = unstack(avg_CIs, 'mean_CI', 'Lightness');
% Convert the table to a matrix for plotting
data_matrix = T_wide{:, {'L40', 'L55', 'L70'}};
cats = string(unique(avg_CIs.ParticipantID));
figure;
h = bar(data_matrix, 'grouped');
xticks(1:length(cats))
xticklabels(cats)
xlabel('Participant')
ylabel('Constancy Index')
title('[FLAT] Average Constancy Index per Lightness Under Yellow Illuminant')