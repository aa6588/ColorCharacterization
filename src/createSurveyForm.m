% AUTHOR: Yanmei He
function createSurveyForm(participantID)
    % Check if participantID is provided
    if nargin < 1 || isempty(participantID)
        participantID = getParticipantID(); % Call a function to get participant ID
    end
    % Get the screen size
    screenSize = get(0, 'ScreenSize');

    % Define the figure size
    figWidth = 400;
    figHeight = 800;

    % Calculate the center position
    xCenter = (screenSize(3) - figWidth) / 2;
    yCenter = (screenSize(4) - figHeight) / 2;

    % Create the figure window centered on the screen
    fig = uifigure('Name', '  You''re all done with the experiment!', 'Position', [xCenter, yCenter, figWidth, figHeight]);

    uilabel(fig, 'Position', [50 770 300 20], 'Text', '😊 Let''s do a quick survey!');
  
    % Add age question
    uilabel(fig, 'Position', [50 730 300 20], 'Text', '1. What is your age?');
    ageField = uispinner(fig, 'Position', [50 700 100 22]);

    % Add colorblind questions
    uilabel(fig, 'Position', [50 660 300 20], 'Text', '2. Are you red-green colorblind?');
    bgRgcb = uibuttongroup(fig, 'Position', [50 610 300 40]);
    uiradiobutton(bgRgcb, 'Position', [10 20 100 20], 'Text', 'No');
    uiradiobutton(bgRgcb, 'Position', [10 0 100 20], 'Text', 'Yes');

    uilabel(fig, 'Position', [50 570 300 20], 'Text', '3. Are you blue-yellow colorblind?');
    bgBycb = uibuttongroup(fig, 'Position', [50 520 300 40]);
    uiradiobutton(bgBycb, 'Position', [10 20 100 20], 'Text', 'No');
    uiradiobutton(bgBycb, 'Position', [10 0 100 20], 'Text', 'Yes');

    % Add gender question
    uilabel(fig, 'Position', [50 480 300 20], 'Text', '4. How would you describe yourself?');
    bgGender = uibuttongroup(fig, 'Position', [50 390 300 80]);
    uiradiobutton(bgGender, 'Position', [10 60 100 20], 'Text', 'Male');
    uiradiobutton(bgGender, 'Position', [10 40 100 20], 'Text', 'Female');
    uiradiobutton(bgGender, 'Position', [10 20 150 20], 'Text', 'Non-Binary');
    uiradiobutton(bgGender, 'Position', [10 0 200 20], 'Text', 'Prefer not to respond');

    % Add Hispanic origin question
    uilabel(fig, 'Position', [50 350 300 20], 'Text', '5. Are you of Hispanic, Latino, or of Spanish origin?');
    bgHisp = uibuttongroup(fig, 'Position', [50 300 300 40]);
    uiradiobutton(bgHisp, 'Position', [10 20 100 20], 'Text', 'No');
    uiradiobutton(bgHisp, 'Position', [10 0 100 20], 'Text', 'Yes');

    % Add ethnicity question
    uilabel(fig, 'Position', [50 260 320 20], 'Text', '6. How would you describe yourself?');
    bgEthnic = uibuttongroup(fig, 'Position', [50 90 300 160]);
    uiradiobutton(bgEthnic, 'Position', [10 140 250 20], 'Text', 'Alaska Native or Indigenous American');
    uiradiobutton(bgEthnic, 'Position', [10 120 100 20], 'Text', 'Asian');
    uiradiobutton(bgEthnic, 'Position', [10 100 200 20], 'Text', 'Black or African American');
    uiradiobutton(bgEthnic, 'Position', [10 80 250 20], 'Text', 'Native Hawaiian or Pacific Islander');
    uiradiobutton(bgEthnic, 'Position', [10 60 100 20], 'Text', 'White');
    uiradiobutton(bgEthnic, 'Position', [10 40 100 20], 'Text', 'Multiracial');
    uiradiobutton(bgEthnic, 'Position', [10 20 100 20], 'Text', 'Other');
    uiradiobutton(bgEthnic, 'Position', [10 0 150 20], 'Text', 'Prefer not to respond');

    % Add Submit Button
    submitBtn = uibutton(fig, 'Position', [150 25 100 22], 'Text', 'Submit All', ...
        'ButtonPushedFcn', @(btn,event) submitSurvey(participantID, ageField, bgRgcb, bgBycb, bgGender, bgHisp, bgEthnic, btn, fig));
end

function submitSurvey(participantID, ageField, bgRgcb, bgBycb, bgGender, bgHisp, bgEthnic, submitBtn, fig)
    % Gather data from the form
    Age = ageField.Value;
    RGcb = double(strcmp(bgRgcb.SelectedObject.Text, 'Yes'));
    BYcb = double(strcmp(bgBycb.SelectedObject.Text, 'Yes'));
    genderIndex = find(bgGender.SelectedObject == bgGender.Children);
    Gender = length(bgGender.Children) - genderIndex + 1;  % Reverse index
    Hisp = double(strcmp(bgHisp.SelectedObject.Text, 'Yes'));
    ethnicIndex = find(bgEthnic.SelectedObject == bgEthnic.Children);
    Ethnic = length(bgEthnic.Children) - ethnicIndex + 1;  % Reverse index

    % Save the results to a file
    filename = '../data/survey.xls';

    % Define the row of data to be added
    TimeStamp = sprintf('%s', datestr(now, 'yyyymmdd_HHMMSS'));
    dataRow = {participantID, Age, RGcb, BYcb, Gender, Hisp, Ethnic, TimeStamp};

    if ~isfile(filename)
        % File does not exist, so define headers and initial data
        headers = {'ParticipantID', 'Age', 'RGcb', 'BYcb', 'Gender', 'Hisp', 'Ethnic', 'TimeStamp'};
        data = [headers; dataRow];
        % Write the data to a new Excel file
        writecell(data, filename);
    else
        % File exists, read existing data and append new data
        existingData = readcell(filename);
        newData = [existingData; dataRow];
        % Write the updated data back to the file
        writecell(newData, filename);
    end
    
    % Show a Thank You message directly in the submit button
    thankYouLabel = uilabel(fig, 'Position', [0 60 400 22], ...
        'Text', 'Thank you for completing the survey!', ...
        'HorizontalAlignment', 'center', 'FontColor', 'blue');

    % Change the submit button to a close button
    submitBtn.Text = 'Close';
    submitBtn.ButtonPushedFcn = @(btn, event) close(fig);
end
