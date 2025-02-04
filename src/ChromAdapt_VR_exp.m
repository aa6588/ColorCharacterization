function [participant] = ChromAdapt_VR_exp(participant,paths)

%% Main function for Color Constancy Experiment VR
% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);

%load variables
load RGBs_grids_struct.mat RGB_grid
load LAB_grid_struct.mat LAB_grid
%load models_info.mat model
load FinalSceneIllums.mat newRGB_illum
%% Define randomization of vars

%lights
RGB_white_illum = newRGB_illum(1,:);
RGB_chrom_illum = newRGB_illum(2:end,:);
illum_color = {'r','g','b','y'};
illum_rand = randperm(length(illum_color));
participant.illum_order = illum_color(illum_rand);
%patch lightness
L_star = {'L40' 'L55' 'L70'};
colnames = {'RGB Select','Lab Select','Starting Lab','Idx'};
%% Start Experiment

%start with white illum
fwrite(t, "Value:" + 0 + "," + 0 + "," + 0);
adapting(RGB_white_illum,t,120); %run adapting function with set illum
tempTable = table();
for rep = 1:3 %repeat exp 3 times
    rand_L = L_star(randperm(length(L_star))); %randomize lightness
    for L = 1:length(L_star)
        [curr_select,curr_lab_select,curr_lab_start, idx] = run_experiment('w',RGB_white_illum,rand_L{L},RGB_grid,LAB_grid,t);
        tempTable = table(curr_select,curr_lab_select,curr_lab_start,idx, 'VariableNames',colnames);
        participant.w.(rand_L{L})(rep,:)= tempTable;
    end
end

%% white trial is done, advance to chromatic illums
for illums = 1:4
adapting(RGB_chrom_illum(illum_rand(illums),:),t,120); %adapt to illum for 2 mins
    for rep = 1:3
        rand_L = L_star(randperm(length(L_star))); %randomize lightness
        for L = 1:length(L_star)
            curr_illum = illum_color{illum_rand(illums)}; % get label for current illum (rgby)
            curr_illumRGB = RGB_chrom_illum(illum_rand(illums),:);
            [curr_select,curr_lab_select,curr_lab_start,idx] = run_experiment(curr_illum,curr_illumRGB,rand_L{L},RGB_grid,LAB_grid,t);
            tempTable = table(curr_select,curr_lab_select,curr_lab_start,idx,'VariableNames',colnames);
            participant.(curr_illum).(rand_L{L})(rep,:)= tempTable;
        end
    end
%add interjection of white illum trial L55 only
    if illums < 4
        adapting(RGB_white_illum,t,30); %adapt to white for 30 secs
        [curr_select,curr_lab_select,curr_lab_start] = run_experiment('w',RGB_white_illum,'L55',RGB_grid,LAB_grid,t);
        tempTable = table(curr_select,curr_lab_select,curr_lab_start,idx,'VariableNames',colnames);
        participant.w.('L55')(illums+3,:)= tempTable; %adds to column after the first 3 reps
    end
end
% save participant data
save([paths.participant sprintf('Participant_%02g.mat',participant.ID)],'participant');  
%experiment end
beep
fwrite(t,"End:0")
end
%% Run through RGB values by pressing key to advance

function adapting(illumRGB,connect,adapt_time)
fs = 44100;      % Sampling frequency (samples per second)
time = 0:1/fs:0.2;  % Time vector for 0.2 seconds
f = 500;        % Frequency of the bleep (in Hz)
bleep = sin(2*pi*f*time); 
fwrite(connect, "Light:" + illumRGB(1) + "," + illumRGB(2) + "," + illumRGB(3));
pause(1/4)
fwrite(connect, "Light:" + illumRGB(1) + "," + illumRGB(2) + "," + illumRGB(3));
pause(1/4)
sound(bleep, fs);
%adapting . . .
fwrite(connect, "Value:" + 0 + "," + 0 + "," + 0); %set patch to black
%AmAdapting=0
%AmAdapting=1
fclose(connect);
pause(adapt_time) %adapt for x mins
 % Generate a sine wave at 500 Hz
fopen(connect);
sound(bleep, fs);
%AmAdapting=0
end

function [selection,lab_selection,starting_lab,select_idx] = run_experiment(illum_color,illumRGB,lightness_level,rgb_grids,lab_grids,connect)

%set vars
grid = rgb_grids.(illum_color).(lightness_level);
lab = lab_grids.(illum_color).(lightness_level);
selection = zeros(1,3);
lab_selection = zeros(1,3);
select_idx = zeros(1,2);

%set lights
a = "start";

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
            %if AmAdapting=1
        %else
            disp('right')
            if col_idx < size(grid, 2)
                col_idx = col_idx + 1;
                disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
                + grid(row_idx,col_idx, 3));
                disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
                + lab(row_idx,col_idx, 3));
                %end
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
            select_idx = [row_idx,col_idx];
            a = 'next_trial';
            disp(a)
            fwrite(connect, "Value:" + 0 + "," + 0 + "," + 0);
            pause(1/8)
            fwrite(connect, "Value:" + 0 + "," + 0 + "," + 0);
            pause(1/8)
    end  

    end
end
