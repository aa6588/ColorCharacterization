%function [participant] = ChromAdapt_VR_draft2(participant,paths)
%% startup
%addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
%addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))

%% Main function for Color Constancy Experiment VR
% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);

%load variables
load RGB_grid_struct.mat RGB_grid
load LAB_grid_struct.mat LAB_grid
%load models_data.mat model
load FinalSceneIllums.mat newRGB_illum

participant = struct();
%% Define randomization of vars

%lights
RGB_white_illum = newRGB_illum(1,:);
RGB_chrom_illum = newRGB_illum(2:end,:);
illum_color = {'r','g','b','y'};
illum_rand = randperm(length(illum_color));
participant.illum_order = illum_color(illum_rand);
%patch lightness
L_star = {'L40' 'L55' 'L70'};
colnames = {'RGB Select','Lab Select','Starting Lab'};
%% Start Experiment

%start with white illum
adapting(RGB_white_illum,t,5); %run adapting function with set illum
tempTable = table();
for rep = 1:3 %repeat exp 3 times
    rand_L = L_star(randperm(length(L_star))); %randomize lightness
    for L = 1:length(L_star)
        %participant.w.(rand_L{L}) = tempTable;
        [curr_select,curr_lab_select,curr_lab_start] = run_experiment('w',RGB_white_illum,rand_L{L},RGB_grid,LAB_grid,t);
        tempTable = table(curr_select,curr_lab_select,curr_lab_start,'VariableNames',colnames);
        participant.w.(rand_L{L})(rep,:)= tempTable;
        %[participant.w(rep).(rand_L{L}), participant.w(rep+3).(rand_L{L}),participant.w(rep+6).(rand_L{L})] = run_experiment('w',RGB_white_illum,rand_L{L},RGB_grid,LAB_grid,t);
    end
end

%% white trial is done, advance to chromatic illums
for illums = 1:4
adapting(RGB_chrom_illum(illum_rand(illums),:),t,5); %adapt to illum for 2 mins
    for rep = 1:3
        rand_L = L_star(randperm(length(L_star))); %randomize lightness
        for L = 1:length(L_star)
            curr_illum = illum_color{illum_rand(illums)}; % get label for current illum (rgby)
            curr_illumRGB = RGB_chrom_illum(illum_rand(illums),:);
            [curr_select,curr_lab_select,curr_lab_start] = run_experiment(curr_illum,curr_illumRGB,rand_L{L},RGB_grid,LAB_grid,t);
            tempTable = table(curr_select,curr_lab_select,curr_lab_start,'VariableNames',colnames);
            participant.(curr_illum).(rand_L{L})(rep,:)= tempTable;
        end
    end
%add interjection of white illum trial L55 only
    if illums < 4
        adapting(RGB_white_illum,t,5); %adapt to white for 30 secs
        [curr_select,curr_lab_select,curr_lab_start] = run_experiment('w',RGB_white_illum,'L55',RGB_grid,LAB_grid,t);
        tempTable = table(curr_select,curr_lab_select,curr_lab_start,'VariableNames',colnames);
        participant.w.('L55')(illums+3,:)= tempTable; %adds to column after the first 3 reps
    end
end
% save participant data
%save([paths.participant sprintf('Participant_%03g.mat',participant.ID)],'participant');  
% experiment function
%end
%% Run through RGB values by pressing key to advance

function adapting(illumRGB,connect,adapt_time)
fwrite(connect, "Light:" + illumRGB(1) + "," + illumRGB(2) + "," + illumRGB(3));
pause(1/8)

%adapting . . .
fwrite(connect, "Value:" + 1+ "," + 1 + "," + 1); %set patch to blend in with BG (1,1,1)
pause(adapt_time) %adapt for x mins
fs = 44100;      % Sampling frequency (samples per second)
time = 0:1/fs:0.2;  % Time vector for 0.2 seconds
f = 500;        % Frequency of the bleep (in Hz)
bleep = sin(2*pi*f*time);  % Generate a sine wave at 500 Hz
sound(bleep, fs);
end

function [selection,lab_selection,starting_lab] = run_experiment(illum_color,illumRGB,lightness_level,rgb_grids,lab_grids,connect)

%set vars
grid = rgb_grids.(illum_color).(lightness_level);
lab = lab_grids.(illum_color).(lightness_level);
selection = zeros(1,3);
lab_selection = zeros(1,3);

%set lights
a = "start";
% fwrite(connect, "Light:" + illumRGB(1) + "," + illumRGB(2) + "," + illumRGB(3));
% pause(1/8)
% 
% %adapting . . .
% fwrite(connect, "Value:" + 1+ "," + 1 + "," + 1); %set patch to blend in with BG (1,1,1)
% pause(adapt_time) %adapt for x mins
% beep %make noise

%random starting point
col_idx = randi(size(grid, 2));
row_idx = randi(size(grid, 1));

starting_lab(1,:) = lab(row_idx, col_idx, :);
disp("Starting Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
        + lab(row_idx,col_idx, 3)) 

    while ~strcmp(a, "next_trial")

        % Send patch info to Unreal
        fwrite(connect, "Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
            + grid(row_idx,col_idx, 3));
        %search for key press from Unreal (a) answer
         a = fscanf(connect, '%s\n');
        % disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
        %     + grid(row_idx,col_idx, 3));
        % disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
        %     + lab(row_idx,col_idx, 3))

    switch a
        case "rightarrow"
            disp('right')
            if col_idx < size(grid, 2)
                col_idx = col_idx + 1;
                disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
                + grid(row_idx,col_idx, 3));
                disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
                + lab(row_idx,col_idx, 3));
            end
        case "leftarrow"
            disp('left')
            if col_idx > 1
               col_idx = col_idx - 1;
               disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
                + grid(row_idx,col_idx, 3));
                disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
                + lab(row_idx,col_idx, 3));
            end
        case "uparrow"
            disp('up')
            if row_idx > 1
               row_idx = row_idx - 1;
               disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
                + grid(row_idx,col_idx, 3));
                disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
                + lab(row_idx,col_idx, 3));
            end
        case "downarrow"
            disp('down')
            if row_idx < size(grid, 1)
               row_idx = row_idx + 1;
               disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
                + grid(row_idx,col_idx, 3));
                disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
                + lab(row_idx,col_idx, 3));
            end
        case "enter"
            disp('enter')
            disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
                + grid(row_idx,col_idx, 3));
                disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
                + lab(row_idx,col_idx, 3))
            selection(1,:) = grid(row_idx,col_idx,:);
            lab_selection(1,:) = lab(row_idx,col_idx,:);
            a = 'next_trial';
            disp(a)
    end  

    end
end
