% chromaticity error for each illum
load ramp_XYZs.mat

white_rampxy = XYZ2xyY(white_rampXYZs);
red_rampxy = XYZ2xyY(red_rampXYZs);
green_rampxy = XYZ2xyY(green_rampXYZs);
blue_rampxy = XYZ2xyY(blue_rampXYZs);
yellow_rampxy = XYZ2xyY(yellow_rampXYZs);

d65 = [.312, .329];
squared_errors = (white_rampxy(:,1) - d65(1)).^2 + (white_rampxy(:,2) - d65(2)).^2;
mse = mean(squared_errors);
w_rmse = sqrt(mse);
squared_errors = (red_rampxy(:,1) - d65(1)).^2 + (red_rampxy(:,2) - d65(2)).^2;
mse = mean(squared_errors);
r_rmse = sqrt(mse);
squared_errors = (green_rampxy(:,1) - d65(1)).^2 + (green_rampxy(:,2) - d65(2)).^2;
mse = mean(squared_errors);
g_rmse = sqrt(mse);
squared_errors = (blue_rampxy(:,1) - d65(1)).^2 + (blue_rampxy(:,2) - d65(2)).^2;
mse = mean(squared_errors);
b_rmse = sqrt(mse);
squared_errors = (yellow_rampxy(:,1) - d65(1)).^2 + (yellow_rampxy(:,2) - d65(2)).^2;
mse = mean(squared_errors);
y_rmse = sqrt(mse);

% Display the RMSE
illuminant_names = {'White Illum', 'Red Illum', 'Green Illum', 'Blue Illum', 'Yellow Illum'};
result_table = table(w_rmse,r_rmse,g_rmse,b_rmse,y_rmse, 'VariableNames', illuminant_names,'RowNames',{'Gray Ramp Chromaticity RMSE'});
result_table{:, :} = round(result_table{:, :}, 4)