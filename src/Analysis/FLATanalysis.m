%% Analysis of Raw data
addpath('C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\color_transformations\')
addpath('C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\')
% FLAT section
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
rawTable = finalTable;

%% calculate CIs
cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\

whiteTable = finalTable;
%delete extra interjected trials 
idx = (finalTable.Illuminant == 'w') & (finalTable.Lightness == 'L55') & (finalTable.Rep > 3); 
% Remove those rows from the table
whiteTable(idx, :) = []; %index to interjected white trials

white_table = whiteTable(whiteTable.Illuminant == 'w',:);
%average repetition XYZs
avgTable = groupsummary(white_table,{'ParticipantID','Lightness','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
avgTable.uvY = XYZ2uvY(avgTable.mean_XYZ);

%white chrom XYZ
D65XYZ = whitepoint("d65").*model.w.wp(2);
w_uv = XYZ2uvY(D65XYZ);
% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};
%mergedTable.uvY = XYZ2uvY(mergedTable.mean_XYZ);
finalTable.CI_1 = nan(height(finalTable), 1);
finalTable.delta_uv_1 = nan(height(finalTable), 1);
finalTable.recenter_uv = nan(height(finalTable), 2);
finalTable.CI_1_recenter = nan(height(finalTable), 1);
finalTable.delta_uv_1_recenter = nan(height(finalTable), 1);
% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};

    % Find the row indices where Illuminant matches current_illum
    rows = find(finalTable.Illuminant == current_illum);
    %rows_white = find(mergedTable.Illuminant == 'w');

    % Extract necessary data once
    obsXYZ = finalTable.XYZ(rows, :);
    adj_uv = finalTable.uvY(rows, :);
    adjXYZ_white = avgTable.mean_XYZ;
    adjXYZ_white = repelem(adjXYZ_white, 3, 1);
    adj_uv_white = avgTable.uvY;
    adj_uv_white = repelem(adj_uv_white, 3, 1);
    finalTable.WhiteXYZ_1(rows, :) = adjXYZ_white; 

    % Get chromatic illuminant uv (changes)
    chrom_test_uv = illum_uvY(i+1, :);

    % Ensure preallocation of recenter_uv and CI columns if not already done

    % Calculate recentered UV and CI for each participant
    for part = 1:length(obsXYZ)
        recentered_uv = recenter(adjXYZ_white(part,:), obsXYZ(part,:), D65XYZ);
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), w_uv(1:2), recentered_uv(1:2));
        finalTable.recenter_uv(rows(part), :) = recentered_uv; 
        finalTable.CI_1_recenter(rows(part)) = CI_value;
        finalTable.delta_uv_1_recenter(rows(part)) = delta_uv_value;
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), adj_uv_white(part,1:2), adj_uv(part,1:2));
        finalTable.CI_1(rows(part)) = CI_value;
        finalTable.delta_uv_1(rows(part)) = delta_uv_value;
    end
end
finalTable = movevars(finalTable, "WhiteXYZ_1", "Before", "CI_1");

%% cI calc averaging ALL whites, (avg lightness avg reps)

white_table = whiteTable(whiteTable.Illuminant == 'w',:);
%average repetition XYZs
avgTable = groupsummary(white_table,{'ParticipantID','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
avgTable.uvY = XYZ2uvY(avgTable.mean_XYZ);

%white chrom XYZ
D65XYZ = whitepoint("d65").*model.w.wp(2);
w_uv = XYZ2uvY(D65XYZ);
% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};
%mergedTable.uvY = XYZ2uvY(mergedTable.mean_XYZ);
finalTable.CI_2 = nan(height(finalTable), 1);
finalTable.delta_uv_2 = nan(height(finalTable), 1);
finalTable.recenter_uv_2 = nan(height(finalTable), 2);
finalTable.CI_2_recenter = nan(height(finalTable), 1);
finalTable.delta_uv_2= nan(height(finalTable), 1);
% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};

    % Find the row indices where Illuminant matches current_illum
    rows = find(finalTable.Illuminant == current_illum);
    %rows_white = find(mergedTable.Illuminant == 'w');

    % Extract necessary data once
    obsXYZ = finalTable.XYZ(rows, :);
    adj_uv = finalTable.uvY(rows, :);
    adjXYZ_white = avgTable.mean_XYZ;
    adjXYZ_white = repelem(adjXYZ_white, 9, 1);
    adj_uv_white = avgTable.uvY;
    adj_uv_white = repelem(adj_uv_white, 9, 1);
    finalTable.WhiteXYZ_2(rows, :) = adjXYZ_white; 

    % Get chromatic illuminant uv (changes)
    chrom_test_uv = illum_uvY(i+1, :);

    % Ensure preallocation of recenter_uv and CI columns if not already done

    % Calculate recentered UV and CI for each participant
    for part = 1:length(obsXYZ)
        recentered_uv = recenter(adjXYZ_white(part,:), obsXYZ(part,:), D65XYZ);
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), w_uv(1:2), recentered_uv(1:2));
        finalTable.recenter_uv_2(rows(part), :) = recentered_uv; 
        finalTable.CI_2_recenter(rows(part)) = CI_value;
        finalTable.delta_uv_2_recenter(rows(part)) = delta_uv_value;
        [CI_value, delta_uv_value] = computeCIproj(w_uv(1:2), chrom_test_uv(1:2), adj_uv_white(part,1:2), adj_uv(part,1:2));
        finalTable.CI_2(rows(part)) = CI_value;
        finalTable.delta_uv_2(rows(part)) = delta_uv_value;
    end
end
finalTable = movevars(finalTable, "WhiteXYZ_2", "Before", "CI_2");
save('FLATData.mat','rawTable','finalTable');
