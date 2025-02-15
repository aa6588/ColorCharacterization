%% Analysis of Raw data

% organize VR vs Flat
% average trials per lightness level for each participant
% average lightness level for all participants (aggregate)
% should end up with one RGB value per lightness per illum
addpath('C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\color_transformations\')
addpath('C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\')
%% VR section
%48 trials per participant

cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Participants\VR\
%cd C:\Users\orange\Documents\GitHub\ColorCharacterization\src\Participants\VR\
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

                    % lab_slice = reshape(Lab, 1, 1, []);
                    % logicalMask = all(LAB_grid.(illuminant).(lightness) == lab_slice, 3); % Check equality along the third dimension
                    % [row_idx, col_idx] = find(logicalMask);
                    % Idx = [row_idx, col_idx];
            

                    % Create a temporary row to append to the final table
                    newRow = table( ...
                        participant.ID, ...
                        string(participant.mode), ...
                        string(strjoin(participant.illum_order)), ...
                        string(illuminant), ...  % Store as string array
                        string(lightness), ...  % Store as string array
                        trial, ...  % Add the trial number
                        RGB, ...  % RGB values for the current trial
                        Lab, ...
                        Idx, ...
                        'VariableNames', {'ParticipantID', 'Mode','illum_order', 'Illuminant', 'Lightness', 'Rep', 'RGB','Lab Grid','Idx'} ...
                    );
                    
                    % Append the new row to the final table
                    finalTable = [finalTable; newRow];
                end
        end

    end

end

%% Divide each illuminant's results
cd ..\..\
load models_info.mat 
finalTable.XYZ = zeros(height(finalTable),3);
finalTable(finalTable.Illuminant == 'w', :).XYZ = modRGB2XYZ(model.w.PM,model.w.LUT,finalTable(finalTable.Illuminant == 'w', :).RGB);
finalTable(finalTable.Illuminant == 'r', :).XYZ = modRGB2XYZ(model.r.PM,model.r.LUT,finalTable(finalTable.Illuminant == 'r', :).RGB);
finalTable(finalTable.Illuminant == 'g', :).XYZ = modRGB2XYZ(model.g.PM,model.g.LUT,finalTable(finalTable.Illuminant == 'g', :).RGB);
finalTable(finalTable.Illuminant == 'b', :).XYZ = modRGB2XYZ(model.b.PM,model.b.LUT,finalTable(finalTable.Illuminant == 'b', :).RGB);
finalTable(finalTable.Illuminant == 'y', :).XYZ = modRGB2XYZ(model.y.PM,model.y.LUT,finalTable(finalTable.Illuminant == 'y', :).RGB);

% add xyY and uvY
finalTable.xyY = XYZ2xyY(finalTable.XYZ);
finalTable.uvY = xyY2uvY(finalTable.xyY);

%calc illum xy and uv
load FinalSceneIllums.mat illum_xyY
illum_uvY = xyY2uvY(illum_xyY);
cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\
% timestamp = datestr(datetime('now'), 'yyyy-mm-dd_HH-MM-SS');
% filename = ['obsData_' timestamp '.csv'];
% writetable(finalTable, filename);
save('VRData.mat','finalTable');
%% calculate CIs
cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\

%average repetition XYZs
avgTable = groupsummary(finalTable,{'ParticipantID','Lightness','Illuminant'},'mean','XYZ');
avgTable.GroupCount = [];
mergedTable = innerjoin(avgTable, unique(finalTable(:, {'ParticipantID' ,'Lightness', 'Illuminant','illum_order','Mode'})), 'Keys', {'ParticipantID', 'Lightness', 'Illuminant'});
mergedTable.CI = zeros(height(mergedTable),1);
%white chrom XYZ
D65XYZ = whitepoint("d65").*model.w.wp(2);
% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};

% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};
    obsXYZ = mergedTable(mergedTable.Illuminant == current_illum, :).mean_XYZ;
    adjXYZ_white = mergedTable(mergedTable.Illuminant == 'w', :).mean_XYZ;
    %get chromatic illuminant uv (changes)
    chrom_test_uv = illum_uvY(i+1, :);

    % Calculate the Color Index (CI) for the current illuminant for all
    % lightnesses and participants
    for part = 1:length(obsXYZ)
    mergedTable(mergedTable.Illuminant == current_illum, :).CI(part) = chrom2CI(adjXYZ_white(part,:),obsXYZ(part,:), D65XYZ,chrom_test_uv);
    end
end
avgDataCI = mergedTable;
save('VRData_CI.mat','avgDataCI');


