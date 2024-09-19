clc
clear
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\src\color_transformations\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Main function for Color Constancy Experiment VR
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save_filename = 'Participant.mat'; %look at HK files

% %% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Run through RGB values by pressing key to advance
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load rgb_grids.mat 
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