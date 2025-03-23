function [mu, ellipse_translated] = compute_2std_ellipse(X, Y)
    % Compute the mean of the data
    mu = mean([X Y]); 
    
    % Compute the covariance matrix
    Sigma = cov(X, Y);
    %Sigma= Sigma./sqrt(24);
    % Compute eigenvalues and eigenvectors
    [eigvec, eigval] = eig(Sigma);
    
    % Scaling factor for 2-standard-deviation ellipse
    scale_2std = 1;
    
    
    % Generate unit circle points
    theta = linspace(0, 2*pi, 100);
    ellipse_points = [cos(theta); sin(theta)];
    
    % Transform unit circle to ellipse
    ellipse_scaled = eigvec * sqrt(eigval) * ellipse_points * scale_2std; 
    
    % Translate to the mean position
    ellipse_translated = ellipse_scaled + mu';
end
