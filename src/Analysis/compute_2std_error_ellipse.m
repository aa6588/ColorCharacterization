function [mu, ellipse_translated] = compute_2std_error_ellipse(X, Y)
    % Compute the mean of the data
    mu = mean([X Y]); 
    
    % Compute standard error for X and Y
    N = length(X);
    SE_x = std(X) / sqrt(N);
    SE_y = std(Y) / sqrt(N);
    
    % 2-standard-error scaling factor
    scale_2se = 2;
    
    % Generate unit circle points
    theta = linspace(0, 2*pi, 100);
    ellipse_points = [cos(theta); sin(theta)];
    
    % Scale ellipse by standard errors
    ellipse_scaled = [SE_x * ellipse_points(1, :); SE_y * ellipse_points(2, :)]; 
    
    % Scale further by 2-standard-error
    ellipse_scaled = ellipse_scaled * scale_2se;
    
    % Translate to mean position
    ellipse_translated = ellipse_scaled + mu';
end