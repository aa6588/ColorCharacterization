%% Analysis of Raw data

% organize VR vs Flat
% average trials per lightness level for each participant
% average lightness level for all participants (aggregate)
% should end up with one RGB value per lightness per illum
addpath('C:\Users\Andrea\Documents\GitHub\ColorCharacterization\src\color_transformations\')
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
                    
                    % Create a temporary row to append to the final table
                    newRow = table( ...
                        participant.ID, ...
                        string(participant.mode), ...
                        string(illuminant), ...  % Store as string array
                        string(lightness), ...  % Store as string array
                        trial, ...  % Add the trial number
                        RGB, ...  % RGB values for the current trial
                        Lab, ...
                        'VariableNames', {'ParticipantID', 'Mode', 'Illuminant', 'Lightness', 'Rep', 'RGB','Lab Grid'} ...
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

% calculate CIs?
