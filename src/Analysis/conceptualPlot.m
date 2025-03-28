% Conceptual Plot to explain CI

load models_info.mat model
load FinalSceneIllums.mat illum_xyY

illum_uvY = xyY2uvY(illum_xyY);
wXYZ = [4.34000873565674	4.77082967758179	5.16557168960571];
rXYZ = [3.62309360504150	3.15533709526062	4.20155191421509];
D65XYZ = whitepoint("d65").*model.w.wp(2);
figure; hold on;
ri = scatter(illum_uvY(2,1),illum_uvY(2,2),80,'filled','rs','MarkerEdgeColor','k','LineWidth',1);
wi = scatter(illum_uvY(1,1),illum_uvY(1,2),80,'filled','ws','MarkerEdgeColor','k','LineWidth',1);
ow = scatter(.1899,.4698,60,'wo','MarkerEdgeColor','k','LineWidth',1);
oc = scatter(0.228, 0.446,60,'ro','MarkerEdgeColor','r','LineWidth',1);

%recenter
 recentered_uv = recenter(wXYZ, rXYZ, D65XYZ);
 rc = scatter(recentered_uv(1), recentered_uv(2),80,'ro','filled','MarkerEdgeColor','k','LineWidth',1);
% %projection
pc = scatter(0.2251,0.4368,80,'r*','LineWidth',1);

%add arrows
red_square = [illum_uvY(2,1),illum_uvY(2,2)];
white_square = [illum_uvY(1,1),illum_uvY(1,2)];
white_circle = [.1899,.4698];
red_circle = [0.228, 0.446];
red_filled_circle = [recentered_uv(1), recentered_uv(2)];
red_star = [0.2251,0.4368];

% arrows for recenter
quiver(white_circle(1), white_circle(2), ...
       white_square(1) - white_circle(1), white_square(2) - white_circle(2), ...
       0, 'Color', 'b', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);

recentering = quiver(red_circle(1), red_circle(2), ...
       red_filled_circle(1) - red_circle(1), red_filled_circle(2) - red_circle(2), ...
       0, 'Color', 'b', 'LineWidth', 1.5, 'MaxHeadSize', 0.5);

%lines for projections
% Solid line
wp = plot([white_square(1), red_star(1)], [white_square(2), red_star(2)], '-', ...
   'Color', [0, .8, 0], 'LineWidth', 1.5);  % Green
wr = plot([white_square(1), red_square(1)], [white_square(2), red_square(2)], ':', ...
    'Color', [0, 0, 0, 0.5], 'LineWidth', 1.5);  % Semi-transparent black

wc = plot([white_square(1), red_filled_circle(1)], [white_square(2), red_filled_circle(2)], ':', ...
    'Color', [0, 0.7, 1, 0.5], 'LineWidth', 1.5);  % Semi-transparent blue

% Dashed line
duv = plot([red_filled_circle(1), red_star(1)], [red_filled_circle(2), red_star(2)], '--', ...
    'Color', 'r', 'LineWidth', 1.5);
%projection on top
pc = scatter(0.2251,0.4368,80,'r*','LineWidth',1);

% Add labels
text(white_square(1) + 0.001, white_square(2) + 0.001, 'w', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(red_filled_circle(1) + 0.002, red_filled_circle(2) + 0.001, 'r_c''', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(red_square(1) + 0.001, red_square(2) - 0.001, 'c', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(red_star(1) - 0.005, red_star(2) - 0.001, 'r_c''''', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');

text(red_circle(1) - 0.003, red_circle(2) - 0.001, 'r_c', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(white_circle(1) - 0.003, white_circle(2) - 0.001, 'r_w', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
%axes and titles
ylim([.42,.48])
xlabel('u′')
ylabel('v′')
title('Example Constancy Index Calculation from Observer Responses')
axis equal;
xlim([.18,.25])
%legend([wi,ri,rc,pc,wr,wc,wp,duv],{'white illuminant','chromatic illuminant','recentered c response','projected response','illuminant line','response line','projection wr_c'' onto wc','\delta_u_v'}...
    %,'Location','southwest')
legend([wi,ri,ow,oc,rc,pc,recentering, wr,wc,wp,duv],...
   {'white illuminant','chromatic illuminant','w response','c response','recentered c resp','projected c resp','recentering','illuminant line','response line','projection wr onto wc','\delta_u_v'}...
   ,'Location','southwest')