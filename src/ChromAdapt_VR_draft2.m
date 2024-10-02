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
load models_data.mat model
load Illuminants.mat RGB_illum

%% Define randomization of vars

%lights
illum_color = {'w','r','g','b','y'};
illum_rand = randperm(length(RGB_illum));

%patch lightness
L = {'L40' 'L55' 'L70'};
lightness_rand = randperm(length(L));

%%  Run through RGB values by pressing key to advance

 
clear range
Lab_vals = grid_w_L70; 
range = RGBs_w_L70;

%a = fscanf(t, '%s\n');
col_idx = randi(size(range, 1));
row_idx = randi(size(range, 1));
    disp("Starting Lab:" + Lab_vals(row_idx, col_idx, 1) + "," + Lab_vals(row_idx,col_idx, 2) + "," ...
        + Lab_vals(row_idx,col_idx, 3))
a = 'start';
while ~strcmp(a, "next_trial")
    
    fwrite(t, "Value:" + range(row_idx, col_idx, 1) + "," + range(row_idx,col_idx, 2) + "," ...
        + range(row_idx,col_idx, 3));
    a = fscanf(t, '%s\n');

    % while ~strcmp(a, "SHOT")
    %      a = fscanf(t, '%s\n');
    %      fwrite(t, "Value:" + range(row_idx, col_idx, 1) + "," + range(row_idx,col_idx, 2) + "," ...
    %     + range(row_idx,col_idx, 3));
    % end
switch a
    case "rightarrow"
        disp('right')
        if col_idx < size(range, 2)
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
        if row_idx < size(range, 1)
           row_idx = row_idx + 1;
        end
end  

    disp("RGB Value:" + range(row_idx, col_idx, 1) + "," + range(row_idx,col_idx, 2) + "," ...
        + range(row_idx,col_idx, 3));
    disp("Lab:" + Lab_vals(row_idx, col_idx, 1) + "," + Lab_vals(row_idx,col_idx, 2) + "," ...
        + Lab_vals(row_idx,col_idx, 3))
    %press key in Unreal 

end


 %save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White');

%save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White','Validation_rand', 'PredefinedRGB');
% %fwrite(t,"DONE:0");