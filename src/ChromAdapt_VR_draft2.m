function [participant] = ChromAdapt_VR_draft2(participant,paths)
%% startup
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))

%% Main function for Color Constancy Experiment VR
% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);

%load variables
load RGB_grid_struct.mat RGB_grid
load LAB_grid_struct.mat LAB_grid
%load models_data.mat model
load Illuminants.mat RGB_illum

%% Define randomization of vars

%lights
RGB_white_illum = RGB_illum(1,:);
RGB_chrom_illum = RGB_illum(2:end,:);
illum_color = {'r','g','b','y'};
illum_rand = randperm(length(illum_color));

%patch lightness
L_star = {'L40' 'L55' 'L70'};

%% Start Experiment

%start with white illum always
rand_L = L_star(randperm(length(L_star)));
for L = 1:length(L_star)

 participant.w.rand_L(L) = run_experiment(RGB_white_illum,rand_L(L));

end


% save participant data
save([paths.participant sprintf('Participant_%03g.mat',participant.ID)],'participant');  
%% experiment function

% Run through RGB values by pressing key to advance

function [selection] = run_experiment(illum_color,lightness_level,rgb_grids,lab_grids)

grid = rgb_grids.(illum_color).(lightness_level);
lab = lab_grids.(illum_color).(lightness_level);
selection = zeros(1,3);

%random starting point
col_idx = randi(size(grid, 1));
row_idx = randi(size(grid, 1));
a = 'start';
disp("Starting Lab:" + Lab_vals(row_idx, col_idx, 1) + "," + Lab_vals(row_idx,col_idx, 2) + "," ...
        + Lab_vals(row_idx,col_idx, 3))   

while ~strcmp(a, "next_trial")
    
    % Send illum and patch info to Unreal
    fwrite(t, "Light:" + illum_color(1) + "," + illum_color(2) + "," + illum_color(3));
    pause(1)
    fwrite(t, "Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
        + grid(row_idx,col_idx, 3));

    %search for key press from Unreal (a) answer
    a = fscanf(t, '%s\n');


switch a
    case "rightarrow"
        disp('right')
        if col_idx < size(grid, 2)
           col_idx = col_idx + 1;
        end
    case "leftarrow"
        disp('left')
        if col_idx > 1
           col_idx = col_idx - 1;
        end
    case "uparrow"
        disp('up')
        if row_idx > 1
           row_idx = row_idx - 1;
        end
    case "downarrow"
        disp('down')
        if row_idx < size(grid, 1)
           row_idx = row_idx + 1;
        end
    case "enter"
        disp('enter')
        selection(1,:) = grid(row_idx,col_idx,:);
        a = 'next trial';
end  

    disp("RGB Value:" + grid(row_idx, col_idx, 1) + "," + grid(row_idx,col_idx, 2) + "," ...
        + grid(row_idx,col_idx, 3));
    disp("Lab:" + lab(row_idx, col_idx, 1) + "," + lab(row_idx,col_idx, 2) + "," ...
        + lab(row_idx,col_idx, 3))
    %press key in Unreal 

end
