%calc uv aims for plot
load LAB_grid_struct.mat LAB_grid
load models_info.mat  model
%model = Flat_model;
%LAB_grid = Flat_LAB_grid;

illuminants = {'w','r', 'g', 'b', 'y'};
lightnessValues = {'L40', 'L55', 'L70'};
uv_aims = struct(); % To store results for each illuminant and lightness

% Loop through each illuminant
for j = 1:length(illuminants)
    illuminant = illuminants{j};
    
    % Loop through each lightness value
    for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        
        % Convert LAB to XYZ and then to uvY
        XYZs = Lab2XYZ(reshape(LAB_grid.(illuminant).(lightness), [], 3), model.(illuminant).wp);
        uv_aims.(illuminant).(lightness) = XYZ2uvY(XYZs);
    end
end