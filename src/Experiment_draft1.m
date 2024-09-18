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
save_filename = 'Participant.mat'; %look at HK files

% %% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Run through RGB values by pressing key to advance
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load PredefinedRGB.mat %1-125 is cube rgb values. 126-x is lab values 224
%cont=0;
clear range
PredefinedRGB = [rgb;rgbs]; %1-125 is RGB cube, 126-end is labs
range = double([rgb;rgbs]);

for i = 1:size(PredefinedRGB, 1)
    tic

    fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + "," ...
        + range(i, 3));
    a = fscanf(t, '%s\n');

    while ~strcmp(a, "SHOT")
        a = fscanf(t, '%s\n');
        fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + ...
            "," + range(i, 3));
    end

    disp("Value:" + range(i, 1) + "," + range(i, 2) + "," + range(i, 3))
    %press key

     t_time = toc;
     disp(['It took ', num2str(t_time), ' s']);
     disp(['Trial #: ', num2str(i),' out of ',num2str(size(PredefinedRGB, 1))])
     disp '-------------------------------------------'

end


 %save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White');

save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White','Validation_rand', 'PredefinedRGB');
% %fwrite(t,"DONE:0");