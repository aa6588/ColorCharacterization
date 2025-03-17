%together plots VR and Flat

load FLATData.mat finalTable
Flat_DataCI = finalTable;
load VRData.mat finalTable
VR_DataCI = finalTable;

VRavg_CIs = groupsummary(VR_DataCI,{'Illuminant'},'mean','CI_2_recenter');
Flatavg_CIs = groupsummary(Flat_DataCI,{'Illuminant'},'mean','CI_2_recenter');
%reshape table
% Reshape from long to wide format
VR_wide = unstack(VRavg_CIs, 'mean_CI_2_recenter', 'Illuminant');
Flat_wide = unstack(Flatavg_CIs, 'mean_CI_2_recenter', 'Illuminant');
% Convert the table to a matrix for plotting
VR_matrix = VR_wide{1, {'r', 'g', 'b','y'}};
Flat_matrix = Flat_wide{1, {'r', 'g', 'b','y'}};
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

