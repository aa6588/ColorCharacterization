clc
clear
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\src\color_transformations\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Main function for Matlab/Unreal connection measure primaries
%% D:\VR_Projects\CalibrationHMD unreal
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_filename = 'Yellow_Calib_12_10_24.mat';

cs2000 = CS2000('COM5');
% Synchronization
pause(1)
sync = CS2000_Sync('Internal', 90);
cs2000.setSync(sync);

% %% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);

range = (0:17:255)./255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Measure Red channel
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=1;
while i <= length(range) 
    
    tic
    

    fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
    a = fscanf(t, '%s\n');
    
    while ~strcmp(a, "SHOT")
        a = fscanf(t, '%s\n');
        fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
    end
    
    disp("Value:" + range(i) + "," + 0 + "," + 0)
    pause(1)
    Red(i) = cs2000.measure;
    xyzObtain_red(i,:)=Red(i).color.XYZ';

    if i > 1
        while abs(xyzObtain_red(i,1) - xyzObtain_red(i-1,1)) < .02 
            fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + range(i) + "," + 0 + "," + 0)
    pause(1)
    Red(i) = cs2000.measure;
    xyzObtain_red(i,:)=Red(i).color.XYZ';
        end

    end

    disp(Red(i).color.xyY')
    
    t_time = toc;
    disp(['It took ', num2str(t_time), ' s']);
    disp(['Trial #: ', num2str(i)])
    disp '-------------------------------------------'
    i=i+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Measure Green channel
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=1;

while i<=length(range)
    
    tic
    
    fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
    a = fscanf(t, '%s\n');
    
    while ~strcmp(a, "SHOT")
        a = fscanf(t, '%s\n');
        fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
    end
    
    disp("Value:" + 0 + "," + range(i) +  "," + 0)
    pause(1)
    Green(i) = cs2000.measure;
    xyzObtain_green(i,:)=Green(i).color.XYZ';

   if i > 1
        while abs(xyzObtain_green(i,2) - xyzObtain_green(i-1,2)) < .05 
            fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + 0 + "," + range(i) + "," + 0)
    pause(1)
    Green(i) = cs2000.measure;
    xyzObtain_green(i,:)=Green(i).color.XYZ';
        end

   end
    
    
    disp(Green(i).color.xyY')

    
    t_time = toc;
    disp(['It took ', num2str(t_time), ' s']);
    disp(['Trial #: ', num2str(i)])
    disp '-------------------------------------------'
    i=i+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Measure Blue channel
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=1;
while i<=length(range)
    
    tic
    
    fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
    a = fscanf(t, '%s\n');
    
    while ~strcmp(a, "SHOT")
        a = fscanf(t, '%s\n');
        fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
    end
    
    disp("Value:" + 0 + "," + 0 + "," + range(i))
    pause(1)
    Blue(i) = cs2000.measure;
    xyzObtain_blue(i,:)=Blue(i).color.XYZ';

    if i > 1
        while abs(xyzObtain_blue(i,3) - xyzObtain_blue(i-1,3)) < .05 
            fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + 0 + "," + 0 + "," + range(i))
    pause(1)
    Blue(i) = cs2000.measure;
    xyzObtain_blue(i,:)=Blue(i).color.XYZ';
        end

    end
    
    disp(Blue(i).color.xyY')

    
    t_time = toc;
    disp(['It took ', num2str(t_time), ' s']);
    disp(['Trial #: ', num2str(i)])
    disp '-------------------------------------------'
    i=i+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Measure Gray channel
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=1;
while i<=length(range)
    
    tic
    
    fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
    a = fscanf(t, '%s\n');
    
    while ~strcmp(a, "SHOT")
        a = fscanf(t, '%s\n');
        fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
    end
    
    disp("Value:" + range(i) + "," + range(i) + "," + range(i))
    pause(1)
    Gray(i) = cs2000.measure;
    xyzObtain_gray(i,:)=Gray(i).color.XYZ';
    

    if i > 1
        while abs(xyzObtain_gray(i,2) - xyzObtain_gray(i-1,2)) < .1 
            fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + range(i) + "," + range(i) + "," + range(i))
    pause(1)
    Gray(i) = cs2000.measure;
    xyzObtain_gray(i,:)=Gray(i).color.XYZ';
        end

    end
    
    White = Gray(i);
   
    disp(Gray(i).color.xyY')

    
    t_time = toc;
    disp(['It took ', num2str(t_time), ' s']);
    disp(['Trial #: ', num2str(i)])
    disp '-------------------------------------------'
    i=i+1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%  Validation predefined values
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load PredefinedRGB.mat %1-125 is cube rgb values. 126-x is lab values 224
%cont=0;
clear range
PredefinedRGB = [rgb;rgbs]; %1-125 is RGB cube, 126-end is labs
range = double([rgb;rgbs]);


for i = 121
    %i = 1:size(PredefinedRGB, 1)
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
    pause(1)
    Validation_rand(i) = cs2000.measure;
    xyzObtain_valid(i,:)=Validation_rand(i).color.XYZ';

    if i > 1
        while max(abs(xyzObtain_valid(i,:) - xyzObtain_valid(i-1,:))) < .05 
            fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + "," ...
            + range(i, 3));
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + ...
            "," + range(i, 3));
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + range(i, 1) + "," + range(i, 2) + "," + range(i, 3))
    pause(1)
    Validation_rand(i) = cs2000.measure;
    xyzObtain_valid(i,:)=Validation_rand(i).color.XYZ';
        end

    end

    t_time = toc;
    disp(['It took ', num2str(t_time), ' s']);
    disp(['Trial #: ', num2str(i),' out of ',num2str(size(PredefinedRGB, 1))])
    disp '-------------------------------------------'

end


 %save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White');

%save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White','Validation_rand', 'PredefinedRGB');

    %%  LAB Validation
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load RGBs_grids_struct.mat %1-125 is cube rgb values. 126-x is lab values
load LAB_grid_struct.mat

%one illum at a time
level = {'L40','L55','L70'};
illum = 'y';

%loop lightness
for j = 1:3
 RGB_forLabs = RGB_grid.(illum).(level{j});
 RGBs = [];
%rand row and col
 rand_row = randperm(size(RGB_forLabs,1),min(size(RGB_forLabs,1),10));
 rand_col = randperm(size(RGB_forLabs,2),min(size(RGB_forLabs,2),10));
 rand_idx.(illum).(level{j}).rand_row = rand_row;
 rand_idx.(illum).(level{j}).rand_col = rand_col;
 min_idx = min(length(rand_row),length(rand_col));
 for sample = 1:min_idx
     RGBs(sample,:) = RGB_forLabs(rand_row(sample),rand_col(sample),:);
     rand_idx.(illum).(level{j}).Labs(sample,:) = LAB_grid.(illum).(level{j})(rand_row(sample),rand_col(sample),:);
 end
rand_idx.(illum).(level{j}).RGBs = RGBs;

%measure
for i = 1:size(RGBs, 1)
    tic

    fwrite(t, "Value:" + RGBs(i,1) + "," + RGBs(i,2) + "," ...
        + RGBs(i,3));
    a = fscanf(t, '%s\n');

    while ~strcmp(a, "SHOT")
        a = fscanf(t, '%s\n');
        fwrite(t, "Value:" + RGBs(i, 1) + "," + RGBs(i, 2) + ...
            "," + RGBs(i, 3));
    end

    disp("Value:" + RGBs(i,1) + "," + RGBs(i,2) + "," + RGBs(i,3))
    pause(1)
    Validation_lab = cs2000.measure;
    xyzObtain_lab(i,:)=Validation_lab.color.XYZ';
    rand_idx.(illum).(level{j}).XYZs(i,:) =Validation_lab.color.XYZ';
   % rand_idx.(illum).(level{j}).Labs(i,:) = LAB_grid.(illum).(level{j})(rand_row(i),rand_col(i),:);

    if i > 1
        while max(abs(xyzObtain_lab(i,:) - xyzObtain_lab(i-1,:))) < .015 
            fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + "," ...
            + range(i, 3));
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + ...
            "," + range(i, 3));
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + range(i, 1) + "," + range(i, 2) + "," + range(i, 3))
    pause(3)
    Validation_lab = cs2000.measure;
    xyzObtain_lab(i,:)=Validation_lab.color.XYZ';
    rand_idx.(illum).(level{j}).XYZs(i,:) =Validation_lab.color.XYZ';
        end

    end

    t_time = toc;
    disp(['It took ', num2str(t_time), ' s']);
    disp(['Trial #: ', num2str(i),' out of ',num2str(size(RGBs, 1))])
    disp '-------------------------------------------'

end       
end
%test(1,:) = LAB_grid.r.L40(rand_row(3),rand_col(3),:)
% save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White','Validation_rand', 'RGB_forLabs','Validation_lab','PredefinedRGB');

% %fwrite(t,"DONE:0");