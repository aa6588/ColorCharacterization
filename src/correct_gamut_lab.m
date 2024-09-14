% Find the indices of out-of-gamut rows
out_of_gamut_idx = find(any(gamut, 2));

% Find the indices of in-gamut rows
in_gamut_idx = find(~any(gamut, 2));

% Preallocate the corrected LAB array
corrected_lab_2 = Lab_L80;

% Iterate over out-of-gamut rows to replace them
for i = 1:length(out_of_gamut_idx)
    out_idx = out_of_gamut_idx(i);
    
    % Get the LAB value of the out-of-gamut row
    out_lab_row = Lab_L80(out_idx, :);
    
    distances = abs(in_gamut_idx - out_idx);
    [~, min_idx] = min(distances);
    
    % Get the closest in-gamut LAB row
    closest_in_gamut_lab_row = Lab_L80(in_gamut_idx(min_idx),: );
    
    % Replace the out-of-gamut row with the closest in-gamut row
    corrected_lab_2(out_idx, :) = closest_in_gamut_lab_row;
end