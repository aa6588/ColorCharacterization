%% Constancy Index plots (from ANOVA from R)
load FLATData.mat finalTable
Flat_DataCI = finalTable;
Flat_DataCI(Flat_DataCI.Illuminant == 'w', :) = [];

load VRData.mat finalTable
VR_DataCI = finalTable;
VR_DataCI(VR_DataCI.Illuminant == 'w', :) = [];

allDatas = [VR_DataCI;Flat_DataCI];
allDatas.z = zscore(allDatas.CI_2_recenter);

allDatas(allDatas.z < -3,:) = [];
allDatas(allDatas.z > 3,:) = [];
allDatas(allDatas.ParticipantID == 12,:) = []; %outlier from anova

VR_DataCI = allDatas(allDatas.Mode == 'VR',:);
Flat_DataCI = allDatas(allDatas.Mode == 'Flat',:);

savepath = 'C:\Users\Andrea\Documents\GitHub\ColorCharacterization\Figs\Results\FinalFigs\';
%% CI VR vs Flat (average illum and lightness)
% Load the data
mat = readtable('em_df_results.csv');
errors = mat(:,3); 
means = mat(:,2);
VRCIs = VR_DataCI.CI_2_recenter;
FlatCIs = Flat_DataCI.CI_2_recenter;
VRCIs = VRCIs(~isnan(VRCIs(1:1254,:)));
FlatCIs = FlatCIs(~isnan(FlatCIs));

mean_VR = table2array(means(1,1));
mean_Flat = table2array(means(2,1));
std_VR = table2array(errors(1,1));
std_Flat = table2array(errors(2,1));

% Plot the violin plot
figure; hold on;
violin = violinplot(1, VRCIs,'Orientation', 'vertical','DensityDirection','positive');
violin2 = violinplot(1 , FlatCIs,'Orientation', 'vertical','DensityDirection','negative');

%colors
violin2.EdgeColor = [0.8500, 0.3250, 0.0980];
violin2.FaceColor = 'none';

% plot horizontal lines and labels
line([1. 1.5], [mean_VR mean_VR],'Color', [0, 0.4470, 0.7410], 'LineWidth', 1);     % VR line
line([0.5 1],[mean_Flat mean_Flat], 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1);  % Flat line

errorbar(1, mean_VR,std_VR, 'vertical','LineWidth',1,'Color', [0, 0.4470, 0.7410]);
errorbar(1, mean_Flat, std_Flat,'vertical','LineWidth',1,'Color', [0.8500, 0.3250, 0.0980]);

text(1.5, mean_VR + .06, 'VR', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 12, 'Color', [0, 0.4470, 0.7410]);
text(0.43, mean_Flat +.02, 'Flat', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 12, 'Color', [0.8500, 0.3250, 0.0980]);

%legend({'VR', 'Flat', 'VR Mean ± STD', 'Flat Mean ± STD'}, 'Location', 'northeast');

% Aesthetics
xlim([0, 2])
ylim([-.2 1.2])
xticklabels([]);   % Removes X-tick labels only
ylabel('Constancy Index');
title('Average Constancy Index per Condition');
grid on; box on;

%save
fileName = fullfile(savepath, 'CI_avgMode');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');

%% CI Illums (average mode and lightness)
mat = readmatrix('em_df_results_illum.csv');
means = mat(:,2);
error = mat(:,3);
% violin plot illums across modes
VRavg_CIs_violin = groupsummary(VR_DataCI,{'ParticipantID','Illuminant'},'mean','CI_2_recenter');
Flatavg_CIs_violin = groupsummary(Flat_DataCI,{'ParticipantID','Illuminant'},'mean','CI_2_recenter');
merged = [VRavg_CIs_violin;Flatavg_CIs_violin];
redCI = merged.mean_CI_2_recenter(merged.Illuminant == 'r',:);
greenCI = merged.mean_CI_2_recenter(merged.Illuminant == 'g',:);
blueCI = merged.mean_CI_2_recenter(merged.Illuminant == 'b',:);
yellowCI = merged.mean_CI_2_recenter(merged.Illuminant == 'y',:);

figure; hold on;
v_r = violinplot(.95, redCI,DensityDirection="negative");
v_g = violinplot(1.05, greenCI,DensityDirection="positive");
v_b = violinplot(1.95, blueCI,DensityDirection="negative");
v_y = violinplot(2.05, yellowCI,DensityDirection="positive");
v_r.FaceColor = 'r';
v_g.FaceColor = [0, 0.6, 0.2];
v_b.FaceColor = 'b';
v_y.FaceColor = [0.85, 0.75, 0.1];

% Plot mean dots with error bars next to violins
xPos = [.95, 1.05, 1.95, 2.05];  % X positions for the two groups
% Loop through all data points
for i = 1:4
    % Adjust X position with offset
    x = xPos(i);  
    scatter(x, means(i), 8, 'k', 'filled');               % Mean dot
    errorbar(x, means(i), error(i), 'k', 'LineWidth', 1);  % Error bar
end
% Aesthetics
xlim([0 3])
newNames = {[],[],'Red|Green',[],'Blue|Yellow',[],[]};
set(gca,'xticklabel',newNames);
ylabel('Constancy Index');
title('Average Constancy Index per Illuminant');
ylim([-.2, 1.2]);
grid on; box on;

%save
fileName = fullfile(savepath, 'CI_avgIllum');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');
%% CI lightness (average mode and illums)
mat = readmatrix('em_df_avgLightness.csv');
means = mat(:,2);
errors = mat(:,3);
avgLVR =groupsummary(VR_DataCI,{'ParticipantID','Lightness'},'mean','CI_2_recenter');
avgLFlat =groupsummary(Flat_DataCI,{'ParticipantID','Lightness'},'mean','CI_2_recenter');
data = [avgLVR;avgLFlat];

L40_dat = data(data.Lightness == 'L40',:).mean_CI_2_recenter;
L55_dat = data(data.Lightness == 'L55',:).mean_CI_2_recenter;
L70_dat = data(data.Lightness == 'L70',:).mean_CI_2_recenter;

figure;hold on;
v_L40 = violinplot(0.95,L40_dat,'DensityDirection','negative');
v_L55 = violinplot(0.95,L55_dat,'DensityDirection','negative');
v_L70 = violinplot(1.05,L70_dat,'DensityDirection','positive');

v_L40.FaceColor = [.2 .2 .2];
v_L55.FaceColor = [.4 .4 .4];
v_L70.FaceColor = [.9 .9 .9];
v_L55.FaceAlpha = .3;
v_L40.FaceAlpha = .3;
v_L70.EdgeColor = 'k';
v_L55.EdgeColor = 'k';
v_L40.EdgeColor = 'k';

xOffset = 0; % Offset for mean and error bars
xs = [0.95 0.95 1.05];
clrs = {[.2, 0.2, 0.2],[0.4, 0.4, 0.4],[.8, 0.8, 0.8]};
for i = 1:3
    s = scatter(xs(i), means(i), 8, clrs{i}, 'filled'); % Mean dot
    e = errorbar(xs(i), means(i), errors(i), 'Color',clrs{i}, 'LineWidth', 1); % Error bar
end

line([.45 .95], [means(1) means(1)],'Color', [.2, 0.2, 0.2], 'LineWidth', 1);     % L40 line
line([0.45 .95],[means(2) means(2)], 'Color', [0.4, 0.4, 0.4], 'LineWidth', 1);  % L55 line
line([1.05 1.55], [means(3) means(3)],'Color', [.8, 0.8, 0.8], 'LineWidth', 1);     % L70 line

text(.4, means(1) +.07, 'L40', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 10, 'Color', 'k');
text(.4, means(2) -.01, 'L55', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 10, 'Color','k');
text(1.55, means(2) +.05, 'L70', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10, 'Color', 'k');

%newNames = {'L40','L55','L70'};
% Aesthetics
%set(gca,'xticklabel',newNames);
xticklabels([]);
ylabel('Constancy Index');
title('Average Constancy Index per Lightness');
ylim([-.2, 1.2]);
xlim([.25 1.75])
grid on; box on;

%save
fileName = fullfile(savepath, 'CI_avgLight');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');
%% interaction illums and mode
mat = readmatrix('em_df_results_ALLpairwise.csv');
errors = [mat(1:2:end,4),mat(2:2:end,4)]; 
means = [mat(1:2:end,3),mat(2:2:end,3)];

figure;hold on;
h = bar(means,'grouped','FaceColor','flat','EdgeColor','flat');
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
h(1).CData = [.8 0 0;0, 0.6, 0.2;0 0 .9; 0.85, 0.75, 0.1];
h(2).CData =[.8 0 0;0, 0.6, 0.2;0 0 .9; 0.85, 0.75, 0.1];
set(h(2), 'FaceAlpha', 0, 'LineWidth',1.5);

%labels
xticks(1:4);
newNames = {'Red';'Green';'Blue';'Yellow'};
set(gca,'xticklabel',newNames);
ylim([0 1])
xlabel('Illuminant')
ylabel('Constancy Index')
legend(h,{'VR','Flat'},'Location','Northwest')
title('Average Constancy Index per Illuminant for Each Condition')
box on;

%save
fileName = fullfile(savepath, 'CI_Mode_Illum');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');
%% interaction lightness vs mode

mat = readtable('em_df_mode_Lightness.csv');
VR = mat{1:2:end,3};
VR_err = mat{1:2:end,4};
Flat = mat{2:2:end,3};
Flat_err = mat{2:2:end,4};
errs = [VR_err,Flat_err];
means = [VR,Flat];
figure;
b = bar([VR,Flat],'grouped','FaceColor','flat','EdgeColor','flat');
b(1).CData= [.2, 0.2, 0.2;0.4, 0.4, 0.4;.8, 0.8, 0.8];
b(2).CData = [.2, 0.2, 0.2;0.4, 0.4, 0.4;.8, 0.8, 0.8];
set(b(2), 'FaceAlpha', 0, 'LineWidth',1.5);
ylim([0,1])
hold on;
%errors
[numGroups, numBars] = size(means);
% X positions for error bars
x = nan(numGroups, numBars);
for i = 1:numBars
    x(:,i) = b(i).XEndPoints;  % Get the X positions for each bar
end

% Add error bars
for i = 1:numBars
    errorbar(x(:,i), means(:,i), errs(:,i), 'k','LineStyle', 'none','LineWidth',1);
end
%newNames = {'VR','Flat'};
newNames = {'L40','L55','L70'};
% Aesthetics
set(gca,'xticklabel',newNames);
%legend({'L40','L55','L70'})
legend({'VR','Flat'},'Location','Northwest')
xlabel('Lightness')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness for Each Condition')
box on;

%save
fileName = fullfile(savepath, 'CI_Mode_Light');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');

%% three-way interaction

%VR
mat = readtable('em_df_results_lightness.csv');
errors = mat{1:2:end,5}; 
means = mat{1:2:end,4};
means = reshape(means,4,3);
errors =reshape(errors,4,3); 

newNames = {'Red','Green','Blue','Yellow'};
figure;
h = bar(means, 'grouped','FaceColor','flat','EdgeColor','flat');
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

h(1).CData = [.5 0 0; 0 .5 .1; 0 0 .5; .45 .45 0];
h(2).CData = [.7 0 0; 0 .65 .15; 0 0 .7;.65 .58 .08];
h(3).CData = [.9 0 0; 0 .8 .2; 0 0 .9;0.85, 0.75, 0.1];

%mark significant bars
xPos = [1 - .23, 4, 4 + .23];         % X-position of the bar
yPos = [means(1,1) + 0.05, means(4,2) + 0.05, means(4,3) + 0.05]; % Y-position slightly above the bar
% Add a red *
plot(xPos, yPos, 'r*', 'MarkerSize', 10, 'LineWidth', 2);

set(gca, 'XTick',1:numel(newNames), 'XtickLabel',newNames)
xlabel('Illuminant')
ylabel('Constancy Index')
ylim([0 1])
title('[VR] Average Constancy Index per Illuminant per Lightness')
legend([h(1) h(2) h(3)],{'L40','L55','L70'})

% Flat
mat = readtable('em_df_results_lightness.csv');
errors = mat{2:2:end,5}; 
means = mat{2:2:end,4};
means = reshape(means,4,3);
errors =reshape(errors,4,3); 

newNames = {'Red','Green','Blue','Yellow'};
figure;
h = bar(means, 'grouped','FaceColor','flat','EdgeColor','Flat');
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

%set colors for bars
h(1).CData = [.5 0 0; 0 .5 .1; 0 0 .5; .45 .45 0];
h(2).CData = [.7 0 0; 0 .65 .15; 0 0 .7;.65 .58 .08];
h(3).CData = [.9 0 0; 0 .8 .2; 0 0 .9;0.85, 0.75, 0.1];
set(h, 'FaceAlpha', 0, 'LineWidth',1.5);

%mark significant bars
xPos = [1 - .23, 4, 4 + .23];         % X-position of the bar
yPos = [means(1,1) + 0.05, means(4,2) + 0.05, means(4,3) + 0.05]; % Y-position slightly above the bar
% Add a red *
plot(xPos, yPos, 'r*', 'MarkerSize', 10, 'LineWidth', 2);

set(gca, 'XTick',1:numel(newNames), 'XtickLabel',newNames)
xlabel('Illuminant')
ylabel('Constancy Index')
ylim([0 1])
title('[Flat] Average Constancy Index per Illuminant per Lightness')
legend([h(1) h(2) h(3)],{'L40','L55','L70'})

%% delta uv
figure;
h = histogram(Flat_DataCI.delta_uv_2_recenter,28);
xlabel('\delta_u_v')
ylabel('frequency')
title('[Flat] Frequency \delta_u_v')
h.EdgeColor = [0.8500, 0.3250, 0.0980];
h.FaceAlpha = 0;
h.LineWidth = 1.5;
xlim([-.03 .02])
ylim([0 200])
%save
fileName = fullfile(savepath, 'Flat_delta_uv');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');

figure;
h = histogram(VR_DataCI.delta_uv_2_recenter,28);
xlabel('\delta_u_v')
ylabel('frequency')
title('[VR] Frequency \delta_u_v')
h.EdgeColor = [0, 0.4470, 0.7410];
h.LineWidth = 1;
%save
fileName = fullfile(savepath, 'VR_delta_uv');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');

%% correlation CI vs delta_uv
figure;
scatter(abs(VR_DataCI.delta_uv_2_recenter),VR_DataCI.CI_2_recenter)
xlabel('| \delta_u_v|')
ylabel('Constancy Index')
title('[VR] Average CI vs \delta_u_v')
xlim([0 .035])
ylim([-.2 1.2])
box on;
%save
fileName = fullfile(savepath, 'VR_CI_vs_duv');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');

figure;
scatter(abs(Flat_DataCI.delta_uv_2_recenter),Flat_DataCI.CI_2_recenter,[],[0.8500, 0.3250, 0.0980])
xlabel('| \delta_u_v|')
ylabel('Constancy Index')
title('[Flat] Average CI vs \delta_u_v')
xlim([0 .035])
ylim([-.2 1.2])
box on;
%save
fileName = fullfile(savepath, 'Flat_CI_vs_duv');
exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
savefig(gcf, [fileName,'.fig']);
%exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');