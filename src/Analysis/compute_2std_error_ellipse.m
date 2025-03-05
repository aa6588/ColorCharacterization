function [mu, ellipse_transformed] = compute_2std_error_ellipse(X, Y)
 
    % Compute mean of the data
    mu = [mean(X); mean(Y)];  % 2x1 mean vector
    
    % Compute standard deviations
    std_dev = [std(X); std(Y)]; % 2x1 standard deviation vector
    
    % Generate unit circle points
    theta = linspace(0, 2*pi, 100);
    unit_circle = [cos(theta); sin(theta)];
    
    % Scale unit circle by 2 standard deviations (axis-aligned ellipse)
    ellipse_scaled = [2 * std_dev(1) * unit_circle(1, :); 
                      2 * std_dev(2) * unit_circle(2, :)];

    % Translate ellipse to mean position
    ellipse_transformed = ellipse_scaled + mu;
end
