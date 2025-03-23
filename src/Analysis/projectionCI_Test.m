% Define chromaticity coordinates of the reference and test illuminants
b1 = [0.1978, 0.4683];  % Reference illuminant chromaticity
b2 = [0.2336, 0.427]; % Test illuminant chromaticity

% Define achromatic settings under the reference and test illuminants
a1 = [0.1978, 0.4683]; % Observer1s neutral point under reference illuminant
a2 = [0.2351    0.4455]; % Observer0s neutral point under test illuminant

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

% Plot the vectors
figure; hold on; grid on; axis equal;
xlabel('Chromaticity u'''); ylabel('Chromaticity v''');
title(sprintf('Dot Product Projection & Constancy Index (CI = %.4f)', CI));

% Plot illuminant shift vector
quiver(b1(1), b1(2), delta_b(1), delta_b(2), 0, 'b', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Illuminant Shift (b2 - b1)');

% Plot achromatic setting shift vector
quiver(a1(1), a1(2), delta_a(1), delta_a(2), 0, 'r', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Achromatic Shift (a2 - a1)');

% Plot projection vector
quiver(a1(1), a1(2), projection_vector(1), projection_vector(2), 0, 'g', 'LineWidth', 2, 'MaxHeadSize', 0.5, 'DisplayName', 'Projection onto b2-b1');

% Mark points
scatter([b1(1), b2(1), a1(1), a2(1), a1_proj(1)], ...
        [b1(2), b2(2), a1(2), a2(2), a1_proj(2)], 100, 'k', 'filled');

% Add labels for points
text(b1(1), b1(2), ' b1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(b2(1), b2(2), ' b2', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
text(a1(1), a1(2), ' a1', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
text(a2(1), a2(2), ' a2', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');
text(a1_proj(1), a1_proj(2), ' Projection', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'left');

x_limits = xlim;
y_limits = ylim;
x_pos = x_limits(1) + 0.05 * (x_limits(2) - x_limits(1)); % Left 5% margin
y_pos = y_limits(1) + 0.05 * (y_limits(2) - y_limits(1)); % Bottom 5% margin

% Display CI value in the bottom-left corner
text(x_pos, y_pos, sprintf('CI = %.4f', CI), 'FontSize', 12, 'FontWeight', 'bold', ...
     'Color', 'k', 'BackgroundColor', 'w', 'EdgeColor', 'k');

legend;
hold off;

% Display CI value in command window
fprintf('Chromaticity Index (CI): %.4f\n', CI);
