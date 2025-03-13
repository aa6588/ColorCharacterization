%% Analysis of Raw data
addpath('C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\color_transformations\')
addpath('C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\')
%% FLAT section
%48 trials per participant

cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Participants\Flat\
files = dir('Pa*.mat');
finalTable = table();  % Initialize an empty table

for i = 1:numel(files)
    % load in the file
    load(files(i).name);
     % Loop through each illuminant type ('w', 'r', 'g', 'b', 'y')
    for illuminant = {'w', 'r', 'g', 'b', 'y'}
        illuminant = illuminant{1};
            % Loop through lightness types ('L40', 'L55', 'L70')
        for lightness = {'L40', 'L55', 'L70'}
            lightness = lightness{1};

            tbl = participant.(illuminant).(lightness);
            % Get the number of trials (rows) in the table
                numTrials = size(tbl, 1);
                
                % Loop through each trial dynamically (no fixed trial count)
                for trial = 1:numTrials
                    % Extract the RGB values for the current trial
                    RGB = tbl{trial, 1};
                    Lab = tbl{trial, "Lab Select"};
                    Idx = tbl{trial, "Idx"};
                    
                    % Create a temporary row to append to the final table
                    newRow = table( ...
                        participant.ID, ...
                        string(participant.mode), ...
                        participant.first,...
                        string(strjoin(participant.illum_order)), ...
                        string(illuminant), ...  % Store as string array
                        string(lightness), ...  % Store as string array
                        trial, ...  % Add the trial number
                        RGB, ...  % RGB values for the current trial
                        Lab, ... 
                        Idx, ...
                        'VariableNames', {'ParticipantID', 'Mode', 'First','illum_order','Illuminant', 'Lightness', 'Rep', 'RGB','Lab Grid','Idx'} ...
                    );
                    
                    % Append the new row to the final table
                    finalTable = [finalTable; newRow];
                end
        end

    end

end

%% Divide each illuminant's results
cd ..\..\
load Flat_model.mat Flat_model
finalTable.XYZ = zeros(height(finalTable),3);
finalTable(finalTable.Illuminant == 'w', :).XYZ = modRGB2XYZ(Flat_model.w.PM,Flat_model.w.LUT,finalTable(finalTable.Illuminant == 'w', :).RGB);
finalTable(finalTable.Illuminant == 'r', :).XYZ = modRGB2XYZ(Flat_model.r.PM,Flat_model.r.LUT,finalTable(finalTable.Illuminant == 'r', :).RGB);
finalTable(finalTable.Illuminant == 'g', :).XYZ = modRGB2XYZ(Flat_model.g.PM,Flat_model.g.LUT,finalTable(finalTable.Illuminant == 'g', :).RGB);
finalTable(finalTable.Illuminant == 'b', :).XYZ = modRGB2XYZ(Flat_model.b.PM,Flat_model.b.LUT,finalTable(finalTable.Illuminant == 'b', :).RGB);
finalTable(finalTable.Illuminant == 'y', :).XYZ = modRGB2XYZ(Flat_model.y.PM,Flat_model.y.LUT,finalTable(finalTable.Illuminant == 'y', :).RGB);

% add xyY and uvY
finalTable.xyY = XYZ2xyY(finalTable.XYZ);
finalTable.uvY = xyY2uvY(finalTable.xyY);

%calc illum xy and uv
load FinalSceneIllums.mat illum_xyY
illum_uvY = xyY2uvY(illum_xyY);
cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\
%timestamp = datestr(datetime('now'), 'yyyy-mm-dd_HH-MM-SS');
%filename = ['obsData_' timestamp '.csv'];
%writeTable(finalTable, filename);
save('FLATData.mat','finalTable');
%% calculate CIs
cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\

%delete extra interjected trials 
idx = (finalTable.Illuminant == 'w') & (finalTable.Lightness == 'L55') & (finalTable.Rep > 3); 
% Remove those rows from the table
finalTable(idx, :) = []; %index to interjected white trials

%average repetition XYZs
avgTable = groupsummary(finalTable,{'ParticipantID','Lightness','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
mergedTable = innerjoin(avgTable, unique(finalTable(:, {'ParticipantID' ,'Lightness', 'Illuminant','illum_order','Mode'})), 'Keys', {'ParticipantID', 'Lightness', 'Illuminant'});
mergedTable.CI = zeros(height(mergedTable),1);
%white chrom XYZ
D65XYZ = whitepoint("d65").*Flat_model.w.wp(2);
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
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), adj_uv_white(part,1:2), recentered_uv(1:2));
        mergedTable.recenter_uv(rows(part), :) = recentered_uv; 
        mergedTable.CI(rows(part)) = CI_value;
        mergedTable.delta_uv(rows(part)) = delta_uv_value;
    end
end
 avgDataCI = mergedTable;
% avgDataCI = movevars(avgDataCI, "Mode", "Before", "Lightness");
% avgDataCI = movevars(avgDataCI, "illum_order", "Before", "Lightness");
% avgDataCI = movevars(avgDataCI, "CI", "Before", "delta_uv");
% save('FLATData_CI.mat','avgDataCI');



