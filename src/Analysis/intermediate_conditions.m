%intermediate conditions effect

load VRData.mat

%find interjected white trials
idx = (finalTable.Illuminant == 'w') & (finalTable.Lightness == 'L55') & (finalTable.Rep > 3);
white_interData = finalTable(idx,:);

for i = 1:height(white_interData)
    colors = strsplit(white_interData.illum_order{i}, ' '); % Split the order string
    rep_idx = white_interData.Rep(i) - 3; % Map Rep 4->1, 5->2, 6->3
    if rep_idx >= 1 && rep_idx <= length(colors)
        white_interData.post_color(i) = "post-" + colors{rep_idx}; % Assign post-color
    end
end

post_R = white_interData(white_interData.post_color == 'post-r',:);
post_G = white_interData(white_interData.post_color == 'post-g',:);
post_B = white_interData(white_interData.post_color == 'post-b',:);
post_Y = white_interData(white_interData.post_color == 'post-y',:);

%find first block L55
idx = (finalTable.Illuminant == 'w') & (finalTable.Lightness == 'L55')& (finalTable.Rep < 4);
white_firstData = finalTable(idx,:);
%% plots
load FinalSceneIllums.mat illum_xyY
illum_uvY = xyY2uvY(illum_xyY);

figure;
w = scatter(white_firstData.uvY(:,1),white_firstData.uvY(:,2),50,'black','filled','o');
alpha(w,0.4);
hold on
r = scatter(post_R.uvY(:,1),post_R.uvY(:,2),50,'red','filled','o','MarkerEdgeColor','k');
alpha(r,0.4);
g = scatter(post_G.uvY(:,1),post_G.uvY(:,2),50,'green','filled','o','MarkerEdgeColor','k');
alpha(g,0.4);
b = scatter(post_B.uvY(:,1),post_B.uvY(:,2),50,'blue','filled','o','MarkerEdgeColor','k');
alpha(b,0.4);
y = scatter(post_Y.uvY(:,1),post_Y.uvY(:,2),50,'yellow','filled','o','MarkerEdgeColor','k');
alpha(y,0.4);
wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks');

colors = {'k', 'r', 'g', 'b', 'y'}; % Colors for ellipses
datasets = {white_firstData.uvY(:,1), white_firstData.uvY(:,2); post_R.uvY(:,1), post_R.uvY(:,2); post_G.uvY(:,1), post_G.uvY(:,2); post_B.uvY(:,1), post_B.uvY(:,2); post_Y.uvY(:,1), post_Y.uvY(:,2)}; % Store data pairs
for i = 1:5
    [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
    plot(ellipse_translated(1, :), ellipse_translated(2, :), colors{i}, 'LineWidth', 2);
    scatter(mu(1), mu(2),80,colors{i},'x','LineWidth',3); % Mean marker
end
title('L55 white block vs post-color trials')