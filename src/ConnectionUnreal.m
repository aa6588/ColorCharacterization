clc
clear
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\utils\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\src\color_transformations\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Main function for Matlab/Unreal connection measure primaries
%% D:\VR_Projects\CalibrationHMD unreal
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_filename = 'Calibration_FinalScene_WHITE03int_frontlight_1.0wall_16step_Vive_7_1_2024.mat';

% HTC=0;
% Pimax=1;
% Varjo=0;
% 
% if(HTC==1)
%     threshold=0.2;
% else
%     threshold=0.1;
% end

cs2000 = CS2000('COM5');
% Synchronization
pause(3)
sync = CS2000_Sync('Internal', 90);
cs2000.setSync(sync);

% %% Create the connection
t = tcpip('127.0.0.1', 8890);
fopen(t);

% xCompare=1000;
% yCompare=-1;
% zCompare=1000;

range = (0:17:255)./255;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Measure Red channel
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% cont=0;
% saturate=0;
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
    pause(2)
    Red(i) = cs2000.measure;
    xyzObtain_red(i,:)=Red(i).color.XYZ';

    if i > 1
        while abs(xyzObtain_red(i,1) - xyzObtain_red(i-1,1)) < .3 
            fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + range(i) + "," + 0 + "," + 0)
    pause(2)
    Red(i) = cs2000.measure;
    xyzObtain_red(i,:)=Red(i).color.XYZ';
        end

    end
    %Pimax: add ||xyzObtain(2)>20
    % while(cont<3&&xyzObtain(2)-yCompare<threshold)
    %     fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     end
    %     pause(2)
    %     desperdiciar=cs2000.measure;
    %     fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + range(i) + "," + 0 + "," + 0);
    %     end
    %     pause(2)
    %     Red(i) = cs2000.measure;
    %     xyzObtain=Red(i).color.XYZ';
    %     cont=cont+1;
    %     if cont>1
    %         saturate=1;
    %         Red(i:length(range))=Red(i);
    %     end
    % end
    % 
    % 
    % yCompare=xyzObtain(2);
    % 
    % 
    % disp(Red(i).color.xyY')
    
    
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
% cont=0;
% saturate=0;
i=1;
%Green(1)=Red(1);
% yCompare=-1;
while i<=length(range)
    
    tic
    
    fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
    a = fscanf(t, '%s\n');
    
    while ~strcmp(a, "SHOT")
        a = fscanf(t, '%s\n');
        fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
    end
    
    disp("Value:" + 0 + "," + range(i) +  "," + 0)
    pause(2)
    Green(i) = cs2000.measure;
    xyzObtain_green(i,:)=Green(i).color.XYZ';

   if i > 1
        while abs(xyzObtain_green(i,2) - xyzObtain_green(i-1,2)) < .3 
            fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + 0 + "," + range(i) + "," + 0)
    pause(3)
    Green(i) = cs2000.measure;
    xyzObtain_green(i,:)=Green(i).color.XYZ';
        end

    end
    %%Pimax: add ||xyzObtain(2)>20
    % while(cont<3&&xyzObtain(2)-yCompare<threshold)
    %     fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + 1 + "," + 1 +  "," + 1);
    %     end
    %     desperdiciar=cs2000.measure;
    %     fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + 0 + "," + range(i) +  "," + 0);
    %     end
    %     Green(i) = cs2000.measure;
    %     xyzObtain=Green(i).color.XYZ';
    %     cont=cont+1;
    %     if cont>1
    %         saturate=1;
    %         Green(i:length(range))=Green(i);
    %     end
    % end
    
    %yCompare=xyzObtain(2);
    
    
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
%Blue(1)=Red(1);
% yCompare=-1;
% cont=0;
% saturate=0;
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
    pause(2)
    Blue(i) = cs2000.measure;
    xyzObtain_blue(i,:)=Blue(i).color.XYZ';

    if i > 1
        while abs(xyzObtain_blue(i,3) - xyzObtain_blue(i-1,3)) < .3 
            fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + 0 + "," + 0 + "," + range(i))
    pause(3)
    Blue(i) = cs2000.measure;
    xyzObtain_blue(i,:)=Blue(i).color.XYZ';
        end

    end
    %Pimax: add ||xyzObtain(2)>20
    % while(cont<3&&xyzObtain(2)-yCompare<threshold/2)
    %     fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %     a = fscanf(t, '%s\n');
    %     fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     end
    %     desperdiciar=cs2000.measure;
    %     fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + 0 + "," + 0 + "," + range(i));
    %     end
    %     Blue(i) = cs2000.measure;
    %     xyzObtain=Blue(i).color.XYZ';
    %     cont=cont+1;
    %     if cont>1
    %         saturate=1;
    %         Blue(i:length(range))=Blue(i);
    %     end
    % end
    
    % yCompare=xyzObtain(2);
    % 
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
%Gray(1)=Red(1);
% yCompare=-1;
% cont=0;
% saturate=0;
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
    pause(2)
    Gray(i) = cs2000.measure;
    xyzObtain_gray(i,:)=Gray(i).color.XYZ';
    

    if i > 1
        while abs(xyzObtain_gray(i,2) - xyzObtain_gray(i-1,2)) < .3 
            fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
            a = fscanf(t, '%s\n');

        while ~strcmp(a, "SHOT")
            a = fscanf(t, '%s\n');
            fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
        end
    disp('Measurement is the same as previous, taking a new measurement...')
    disp("Retake Value:" + range(i) + "," + range(i) + "," + range(i))
    pause(3)
    Gray(i) = cs2000.measure;
    xyzObtain_gray(i,:)=Gray(i).color.XYZ';
        end

    end
    % while(cont<3&&xyzObtain(2)-yCompare<threshold)
    %     fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     end
    %     desperdiciar=cs2000.measure;
    %     fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + range(i) + "," + range(i) + "," ...
    %             + range(i));
    %     end
    %     Gray(i) = cs2000.measure;
    %     xyzObtain=Gray(i).color.XYZ';
    %     cont=cont+1;
    %     if cont>1
    %         saturate=1;
    %         Gray(i:length(range))=Gray(i);
    %     end
    % end
    
    % yCompare=xyzObtain(2);
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
%yCompare=-1;
load PredefinedRGB.mat
cont=0;
clear range
PredefinedRGB = rgb.*255;
range = double(PredefinedRGB)./255;

% while i<=length(range)
% 
%     tic
% 
%     fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
%     a = fscanf(t, '%s\n');
% 
%     while ~strcmp(a, "SHOT")
%         a = fscanf(t, '%s\n');
%         fwrite(t, "Value:" + range(i) + "," + range(i) + "," + range(i));
%     end
% 
%     disp("Value:" + range(i) + "," + range(i) + "," + range(i))
%     pause(3)
%     Validation_rand(i) = cs2000.measure;
%     xyzObtain=Validation_rand(i).color.XYZ';
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
    pause(3)
    Validation_rand(i) = cs2000.measure;
    xyzObtain_valid(i,:)=Validation_rand(i).color.XYZ';

    if i > 1
        while max(abs(xyzObtain_valid(i,:) - xyzObtain_valid(i-1,:))) < .4 
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
    Validation_rand(i) = cs2000.measure;
    xyzObtain_valid(i,:)=Validation_rand(i).color.XYZ';
        end

    end

    % while(cont<3&&(abs(xyzObtain(1)-xCompare)<=0.8)&&...
    %         (abs(xyzObtain(2)-yCompare)<=0.8)&&...
    %         (abs(xyzObtain(3)-zCompare)<=0.8))
    %     fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + 1 + "," + 1 + "," + 1);
    %     end
    %     desperdiciar=cs2000.measure;
    %     fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + ...
    %         "," + range(i, 3));
    %     a = fscanf(t, '%s\n');
    %     while ~strcmp(a, "SHOT")
    %         a = fscanf(t, '%s\n');
    %         fwrite(t, "Value:" + range(i, 1) + "," + range(i, 2) + ...
    %             "," + range(i, 3));
    %     end
    %     Validation_rand(i) = cs2000.measure;
    %     xyzObtain=Validation_rand(i).color.XYZ';
    %     cont=cont+1;
    % end

    % xCompare=xyzObtain(1);
    % yCompare=xyzObtain(2);
    % zCompare=xyzObtain(3);
    % disp(Validation_rand(i).color.xyY')
    % cont=0;

    t_time = toc;
    disp(['It took ', num2str(t_time), ' s']);
    disp(['Trial #: ', num2str(i),' out of ',num2str(size(PredefinedRGB, 1))])
    disp '-------------------------------------------'

end


% save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White','-v7.3');

save(save_filename, 'Red', 'Blue', 'Green', 'Gray', 'White', ...
                     'Validation_rand', 'PredefinedRGB');

                
%fwrite(t,"DONE:0");