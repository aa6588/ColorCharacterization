function [CI, delta_uv] = computeCIproj(b1, b2, a1, a2)
    % computeCI calculates the Chromaticity Index (CI) based on input chromaticity values.
    %
    % Inputs:
    %   b1 - Chromaticity of reference illuminant (1x2 vector [x, y])
    %   b2 - Chromaticity of test illuminant (1x2 vector [x, y])
    %   a1 - Adjusted chromaticity under reference illuminant (1x2 vector [x, y])
    %   a2 - Adjusted chromaticity under test illuminant (1x2 vector [x, y])
    %
    % Output:
    %   CI - Constnacy Index (scalar)
    
    % Compute vector differences
    delta_b = b2 - b1; % Change in illuminant chromaticity
    delta_a = a2 - a1; % Change in achromatic setting

    % Compute Constancy Index (CI)
    CI = dot(delta_b, delta_a) / norm(delta_b)^2;

    % Compute projection of delta_a onto delta_b
projection_scalar = CI; % Since CI is the projection coefficient
projection_vector = projection_scalar * delta_b;

% Compute the projected point
a1_proj = a1 + projection_vector;

%distance from original adjustment
d= norm(a1_proj-a2);
s = a2(1) * a1_proj(2) - a2(2) * a1_proj(1); %determine if right or left of original vector
% Assign sign based on cross product (left is -, right is +)
delta_uv = sign(s) * d;
end
