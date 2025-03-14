%together plots VR and Flat

load FLATData_CI.mat avgDataCI
Flat_avgDataCI = avgDataCI;
load VRData_CI.mat avgDataCI
VR_avgDataCI = avgDataCI;

VRavg_CIs = groupsummary(VR_avgDataCI,{'Illuminant'},'mean','CI');
Flatavg_CIs = groupsummary(Flat_avgDataCI,{'Illuminant'},'mean','CI');
%reshape table
% Reshape from long to wide format
VR_wide = unstack(VRavg_CIs, 'mean_CI', 'Illuminant');
Flat_wide = unstack(Flatavg_CIs, 'mean_CI', 'Illuminant');
% Convert the table to a matrix for plotting
VR_matrix = VR_wide{:, {'r', 'g', 'b','y'}};
Flat_matrix = Flat_wide{:, {'r', 'g', 'b','y'}};
all_matrix = [VR_matrix;Flat_matrix]';
newNames = {'Red';'Green';'Blue';'Yellow'};
figure;
h = bar(all_matrix,'grouped','FaceColor','flat');
h(1).CData = [.8 0 0;0 .8 0;0 0 .9; .9 .9 0];
h(2).CData =[.5 0 0;0 .5 0;0 0 .6; .6 .6 0];
set(gca,'xticklabel',newNames);
ylim([0 .8])
xlabel('Illuminant')
ylabel('Constancy Index')
legend(h,{'VR','Flat'})
title('Average Constancy Index per Illuminant')

