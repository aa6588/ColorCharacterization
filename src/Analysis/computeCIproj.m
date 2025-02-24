function CI = computeCIproj(b1, b2, a1, a2)
    % computeCI calculates the Chromaticity Index (CI) based on input chromaticity values.
    %
    % Inputs:
    %   b1 - Chromaticity of reference illuminant (1x2 vector [x, y])
    %   b2 - Chromaticity of test illuminant (1x2 vector [x, y])
    %   a1 - Adjusted chromaticity under reference illuminant (1x2 vector [x, y])
    %   a2 - Adjusted chromaticity under test illuminant (1x2 vector [x, y])
    %
    % Output:
    %   CI - Chromaticity Index (scalar)
    
    % Compute vector differences
    delta_b = b2 - b1; % Change in illuminant chromaticity
    delta_a = a2 - a1; % Change in achromatic setting

    % Compute Chromaticity Index (CI)
    CI = dot(delta_b, delta_a) / norm(delta_b)^2;
end
