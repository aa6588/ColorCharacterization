pixels = reshape(LAB_grid.r.L55, [], 3);  % (11*15) x 3
matched_values = [];
% Loop through each target and find match
for i = 1:size(targets, 1)
    idx = find(ismember(pixels, targets(i, :), 'rows'));
    matched_values = [matched_values; uv_aims.r.L55(idx, :)];
    
end

