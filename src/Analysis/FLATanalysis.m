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
                        string(strjoin(participant.illum_order)), ...
                        string(illuminant), ...  % Store as string array
                        string(lightness), ...  % Store as string array
                        trial, ...  % Add the trial number
                        RGB, ...  % RGB values for the current trial
                        Lab, ... 
                        Idx, ...
                        'VariableNames', {'ParticipantID', 'Mode', 'illum_order','Illuminant', 'Lightness', 'Rep', 'RGB','Lab Grid','Idx'} ...
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

%number of chrom trials 
trial_num = height(finalTable(finalTable.Illuminant == 'r', :));
% add xyY and uvY
finalTable.xyY = XYZ2xyY(finalTable.XYZ);
finalTable.uvY = xyY2uvY(finalTable.xyY);

%calc illum xy and uv
load FinalSceneIllums.mat illum_xyY
illum_uvY = xyY2uvY(illum_xyY);

%% calculate CIs
cd C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\Analysis\
finalTable.CI = zeros(length(finalTable.xyY),1);
finalTable.CI_uv = zeros(length(finalTable.xyY),1);

% CI = d(color to obs) / d(color to ref)

% List of illuminants
illuminants = {'r', 'g', 'b', 'y'};

% Loop through each illuminant
for i = 1:length(illuminants)
    % Get the current illuminant
    current_illum = illuminants{i};

    % Extract the 'xyY' and 'uvY' data for the current illuminant
    obs = finalTable(finalTable.Illuminant == current_illum, :).xyY(:,1:2);
    obs_uv = finalTable(finalTable.Illuminant == current_illum, :).uvY(:,1:2);
    
    % Dynamically select the chrom_test index (1 to 5)
    chrom_test = illum_xyY(i+1, :);  % Start at index 1 and go up to index 5
    chrom_test_uv = illum_uvY(i+1, :);
    chrom_ref = illum_xyY(1, :);   % Reference chromaticity remains the same
    chrom_ref_uv = illum_uvY(1, :);

    % Calculate the Color Index (CI) for the current illuminant
    finalTable(finalTable.Illuminant == current_illum, :).CI = chrom2CI(obs, chrom_test, chrom_ref);
    
    % Calculate the UV-based Color Index (CI_uv) for the current illuminant
    finalTable(finalTable.Illuminant == current_illum, :).CI_uv = chrom2CI(obs_uv, chrom_test_uv, chrom_ref_uv);
end

%timestamp = datestr(datetime('now'), 'yyyy-mm-dd_HH-MM-SS');
%filename = ['obsData_' timestamp '.csv'];
%writeTable(finalTable, filename);
save('FLATData.mat','finalTable');
