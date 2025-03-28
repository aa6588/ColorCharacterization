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

%% CI VR vs Flat (average illum and lightness)
% Load the data
mat = readtable('em_df_results.csv');
errors = mat(:,3); 
means = mat(:,2);
VRCIs = VR_DataCI.CI_2_recenter;
FlatCIs = Flat_DataCI.CI_2_recenter;
VRCIs = VRCIs(~isnan(VRCIs(1:1254,:)));
FlatCIs = FlatCIs(~isnan(FlatCIs));

data = [VRCIs, FlatCIs];

% Create matching group labels (1 for VR, 2 for Flat)
groupLabels = [zeros(size(VRCIs)), zeros(size(FlatCIs))];

% Plot the overlaid horizontal violin plot
figure; hold on;
violin = violinplot(groupLabels,data,'Orientation', 'horizontal','DensityDirection','positive');

% plot vertical lines and labels
mean_VR = table2array(means(1,1));
mean_Flat = table2array(means(2,1));
std_VR = table2array(errors(1,1));
std_Flat = table2array(errors(2,1));

line([mean_VR mean_VR], [0 0.5], 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1);     % VR line
line([mean_Flat mean_Flat], [0 0.5], 'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1);  % Flat line

errorbar(mean_VR, .5, std_VR, 'horizontal','LineWidth',1,'Color', [0, 0.4470, 0.7410]);
errorbar(mean_Flat, .5,std_Flat,'horizontal','LineWidth',1,'Color', [0.8500, 0.3250, 0.0980]);

text(mean_VR + .02, .5, 'VR', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontSize', 12, 'Color', [0, 0.4470, 0.7410]);
text(mean_Flat - .08, .5, 'Flat', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 12, 'Color', [0.8500, 0.3250, 0.0980]);

legend({'VR', 'Flat', 'VR Mean ± STD', 'Flat Mean ± STD'}, 'Location', 'northeast');

% Aesthetics
xlim([-.5, 1.5])
ylim([0 .6])
xlabel('Constancy Index');
title('Average Constancy Index for per Condition');
grid on;

%% CI Illums (average mode and lightness)
newNames = {'Red';'Green';'Blue';'Yellow'};
mat = readmatrix('em_df_results_illum.csv');
b = bar(mat(:,2),'FaceColor','flat'); %emmeans from R
hold on
errorbar(mat(:,2), mat(:,3), 'k','LineStyle', 'none','LineWidth',1); %standard error from R
b.CData = [.8 0 0;0 .8 0;0 0 .9; .9 .9 0];
set(gca,'xticklabel',newNames);
xlabel('Illuminant')
ylabel('Constancy Index')
title('Average Constancy Index per Illuminant')

clrs = {'r','g','b','y'};
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
v= violinplot([redCI,greenCI,blueCI,yellowCI],DensityDirection="positive");
v(1).FaceColor = 'r';
v(2).FaceColor = 'g';
v(3).FaceColor = 'b';
v(4).FaceColor = 'y';
% Plot mean dots with error bars next to violins
xOffset = 0; % Offset for mean and error bars
for i = 1:4
    s = scatter(i - xOffset, means(i), 8, 'k', 'filled'); % Mean dot
    e = errorbar(i - xOffset, means(i), error(i), 'k', 'LineWidth', 1); % Error bar
end

% Aesthetics
set(gca,'xticklabel',newNames);
ylabel('Constancy Index');
title('Average Constancy Index per Illuminant');
ylim([-.5, 1.5]);
grid on; box on;

%% CI lightness (average mode and illums)
mat = readmatrix('em_df_avgLightness.csv');
%VR_DataCI(VR_DataCI.Illuminant == 'w', :) = [];
%Flat_DataCI(Flat_DataCI.Illuminant == 'w', :) = [];
means = mat(:,2);
errors = mat(:,3);
avgLVR =groupsummary(VR_DataCI,{'ParticipantID','Lightness'},'mean','CI_2_recenter');
avgLFlat =groupsummary(Flat_DataCI,{'ParticipantID','Lightness'},'mean','CI_2_recenter');
data = [avgLVR;avgLFlat];

L40_dat = data(data.Lightness == 'L40',:).mean_CI_2_recenter;
L55_dat = data(data.Lightness == 'L55',:).mean_CI_2_recenter;
L70_dat = data(data.Lightness == 'L70',:).mean_CI_2_recenter;

figure;hold on;
violinplot([L40_dat,L55_dat,L70_dat],'DensityDirection','positive')

xOffset = 0; % Offset for mean and error bars
for i = 1:3
    s = scatter(i - xOffset, means(i), 8, 'k', 'filled'); % Mean dot
    e = errorbar(i - xOffset, means(i), errors(i), 'k', 'LineWidth', 1); % Error bar
end

newNames = {'L40','L55','L70'};
% Aesthetics
set(gca,'xticklabel',newNames);
ylabel('Constancy Index');
title('Average Constancy Index per Lightness');
ylim([0, 1]);
grid on; box on;

%% interaction illums and mode
mat = readmatrix('em_df_results_ALLpairwise.csv');
errors = [mat(1:2:end,4),mat(2:2:end,4)]; 
means = [mat(1:2:end,3),mat(2:2:end,3)];
newNames = {'Red';'Green';'Blue';'Yellow'};

figure;
h = bar(means,'grouped','FaceColor','flat');
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
h(1).CData = [.8 0 0;0 .8 0;0 0 .9; .9 .9 0];
h(2).CData =[.5 0 0;0 .5 0;0 0 .6; .6 .6 0];
set(gca,'xticklabel',newNames);
xlabel('Illuminant')
ylabel('Constancy Index')
legend(h,{'VR','Flat'})
title('Average Constancy Index per Illuminant')

%% interaction lightness vs mode

mat = readtable('em_df_mode_Lightness.csv');
VR = mat{1:2:end,3};
VR_err = mat{1:2:end,4};
Flat = mat{2:2:end,3};
Flat_err = mat{2:2:end,4};
errs = [VR_err,Flat_err];
means = [VR,Flat];
figure;
b = bar([VR,Flat],'grouped');
% b(2).FaceColor= [0.8500, 0.3250, 0.0980];
% b(1).FaceColor = [0, 0.4470, 0.7410];
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
legend({'VR','Flat'})
xlabel('Lightness')
ylabel('Constancy Index')
title('Average Constancy Index per Lightness for Each Condition')

%% three-way interaction

%VR
mat = readtable('em_df_results_lightness.csv');
errors = mat{1:2:end,5}; 
means = mat{1:2:end,4};
means = reshape(means,4,3);
errors =reshape(errors,4,3); 

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

h(1).CData = [.5 0 0; 0 .5 0; 0 0 .5; .5 .5 0];
h(2).CData = [.7 0 0; 0 .7 0; 0 0 .7;.7 .7 0];
h(3).CData = [.9 0 0; 0 .9 0; 0 0 .9;.9 .9 0];

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
figure;
h = histogram(VR_DataCI.delta_uv_2_recenter,28);
xlabel('\delta_u_v')
ylabel('frequency')
title('[VR] Frequency \delta_u_v')

%correlation CI vs delta_uv
figure;
scatter(abs(VR_DataCI.delta_uv_2_recenter),VR_DataCI.CI_2_recenter)
xlabel('| \delta_u_v|')
ylabel('Constancy Index')
title('[VR] Average CI vs \delta_u_v')
xlim([0 .035])
figure;
scatter(abs(Flat_DataCI.delta_uv_2_recenter),Flat_DataCI.CI_2_recenter)
xlabel('| \delta_u_v|')
ylabel('Constancy Index')
title('[Flat] Average CI vs \delta_u_v')
xlim([0 .035])