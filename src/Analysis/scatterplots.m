%% Scatter Final Plots

%load data 
load FLATData.mat
FlatData = finalTable;
load VRData.mat
VRData = finalTable;
allData = {VRData,FlatData};
titles = {'VR','Flat'};
load uv_aims_FLAT.mat
load uv_aims_VR.mat
load FinalSceneIllums.mat illum_xyY
illum_uvY = xyY2uvY(illum_xyY);
savepath = 'C:\Users\Andrea\Documents\GitHub\ColorCharacterization\Figs\Results\FinalFigs\';

for mode = 1:2
    finalTable = allData{mode};
    %separate illums 
    redData = finalTable(finalTable.Illuminant == 'r', :);
    greenData = finalTable(finalTable.Illuminant == 'g', :);
    blueData = finalTable(finalTable.Illuminant == 'b', :);
    yellowData = finalTable(finalTable.Illuminant == 'y', :);
    whiteData = finalTable(finalTable.Illuminant == 'w', :);

    figure; %raw scatter plots
    w = scatter(whiteData.uvY(:,1),whiteData.uvY(:,2),50,'black','filled','o');
    alpha(w,0.05);
    hold on;
       r = scatter(redData.uvY(:,1),redData.uvY(:,2),50,'red','filled','o','MarkerEdgeColor','k');
    alpha(r,0.05);
    g = scatter(greenData.uvY(:,1),greenData.uvY(:,2),50,'green','filled','o','MarkerEdgeColor','k');
    alpha(g,0.05);
    b = scatter(blueData.uvY(:,1),blueData.uvY(:,2),50,'blue','filled','o','MarkerEdgeColor','k');
    alpha(b,0.05);
    y = scatter(yellowData.uvY(:,1),yellowData.uvY(:,2),50,'yellow','filled','o','MarkerEdgeColor','k');
    alpha(y,0.1);
    %illums
    ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k','LineWidth',1);
    gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k','LineWidth',1);
    bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k','LineWidth',1);
    yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k','LineWidth',1);
    wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'filled','ws','MarkerEdgeColor','k','LineWidth',1);
    %plot ellipses
    colors = {'k',[.9 0 0], [0 .9 0], [0 0 .9], [.9 .9 0]};% Colors for ellipses
    datasets = {whiteData.uvY(:,1), whiteData.uvY(:,2); redData.uvY(:,1), redData.uvY(:,2); greenData.uvY(:,1), greenData.uvY(:,2); blueData.uvY(:,1), blueData.uvY(:,2); yellowData.uvY(:,1), yellowData.uvY(:,2)}; % Store data pairs

    for i = 1:5
        [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
        plot(ellipse_translated(1, :), ellipse_translated(2, :),'Color', 'k', 'LineWidth', 2);
        plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
    end
    hold off;
    xlabel('u''')
    ylabel('v''')
    axis equal
    ylim([.4 .52])
    xlim([.14 .26])
    title(['[',titles{mode},']',' ', 'Achromatic Responses'])
    legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})
    %fileName = fullfile(savepath, [titles{mode}, '_', 'allScatter']);
    %exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
    %savefig(gcf, [fileName,'.fig']);
    %exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');

    % recentered uv's for all trials (recenter uv 2, white is average of all
    % white block for each participant
    figure;
    r = scatter(redData.recenter_uv_2(:,1),redData.recenter_uv_2(:,2),50,'red','filled','o','MarkerEdgeColor','k');
    alpha(r,0.1);
    hold on;
    g = scatter(greenData.recenter_uv_2(:,1),greenData.recenter_uv_2(:,2),50,'green','filled','o','MarkerEdgeColor','k');
    alpha(g,0.1);
    b = scatter(blueData.recenter_uv_2(:,1),blueData.recenter_uv_2(:,2),50,'blue','filled','o','MarkerEdgeColor','k');
    alpha(b,0.1);
    y = scatter(yellowData.recenter_uv_2(:,1),yellowData.recenter_uv_2(:,2),50,'yellow','filled','o','MarkerEdgeColor','k');
    alpha(y,0.1);
    %illums
    ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k','LineWidth',1);
    gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k','LineWidth',1);
    bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k','LineWidth',1);
    yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k','LineWidth',1);
    wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'filled','ws','MarkerEdgeColor','k','LineWidth',1);

    %plot ellipses
    colors = {[.9 0 0], [0 .9 0], [0 0 .9], [.9 .9 0]};% Colors for ellipses
    datasets = {redData.recenter_uv_2(:,1), redData.recenter_uv_2(:,2); greenData.recenter_uv_2(:,1), greenData.recenter_uv_2(:,2);...
    blueData.recenter_uv_2(:,1), blueData.recenter_uv_2(:,2); yellowData.recenter_uv_2(:,1), yellowData.recenter_uv_2(:,2)}; % Store data pairs
    for i = 1:4
        [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
        plot(ellipse_translated(1, :), ellipse_translated(2, :),'Color', colors{i}, 'LineWidth', 2);
        plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
    end
    hold off;
    xlabel('u''')
    ylabel('v''')
    axis equal
    ylim([.4 .52])
    xlim([.14 .26])
    title(['[',titles{mode},']',' ', 'Recentered Achromatic Responses'])
    legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})
    %fileName = fullfile(savepath, [titles{mode}, '_', 'recenterScatter']);
    %exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
    %savefig(gcf, [fileName,'.fig']);
    %exportgraphics(gcf, [fileName,'.pdf'],'ContentType','vector');

    %white lightness scatter
    color = {'r','g','b'};
    figure;hold on
    lightnessValues = {'L40', 'L55','L70'};
    for i = 1:length(lightnessValues)
        lightness = lightnessValues{i};
        % Extract the subset for the current lightness
        currentData = whiteData(whiteData.Lightness == lightness, :);
        x = currentData.uvY(:,1);
        y = currentData.uvY(:,2);

        s = scatter(x,y,50,'black','filled');
        alpha(s,0.1);
        scatter(illum_uvY(1,1),illum_uvY(1,2),60,'ks')

        [mu, ellipse_translated] = compute_2std_ellipse(x ,y);
        h(i) = plot(ellipse_translated(1, :), ellipse_translated(2, :), color{i}, 'LineWidth', 2);
        plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
    end
        xlabel('u''')
        ylabel('v''')
        axis square
        ylim([.43 .49])
        xlim([.17 .23])
        title(['[',titles{mode},']',' ','White Illuminant Achromatic Responses'])
        legend([h(1), h(2), h(3)],lightnessValues) 
end

%% together plot average scatter 

figure; hold on;
ri = scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k','LineWidth',1);
gi = scatter(illum_uvY(3,1),illum_uvY(3,2),60,'filled','gs','MarkerEdgeColor','k','LineWidth',1);
bi = scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k','LineWidth',1);
yi = scatter(illum_uvY(5,1),illum_uvY(5,2),60,'filled','ys','MarkerEdgeColor','k','LineWidth',1);
wi = scatter(illum_uvY(1,1),illum_uvY(1,2),60,'filled','ws','MarkerEdgeColor','k','LineWidth',1);

finalTable = allData{1}; %VR
%separate illums 
redData = finalTable(finalTable.Illuminant == 'r', :);
greenData = finalTable(finalTable.Illuminant == 'g', :);
blueData = finalTable(finalTable.Illuminant == 'b', :);
yellowData = finalTable(finalTable.Illuminant == 'y', :);
avg_R = groupsummary(redData,{'ParticipantID'},'mean','recenter_uv_2');
avg_G = groupsummary(greenData,{'ParticipantID'},'mean','recenter_uv_2');
avg_B = groupsummary(blueData,{'ParticipantID'},'mean','recenter_uv_2');
avg_Y = groupsummary(yellowData,{'ParticipantID'},'mean','recenter_uv_2');

r = scatter(avg_R.mean_recenter_uv_2(:,1),avg_R.mean_recenter_uv_2(:,2),50,'red','filled','o','MarkerEdgeColor','k');
alpha(r,0.1);
g = scatter(avg_G.mean_recenter_uv_2(:,1),avg_G.mean_recenter_uv_2(:,2),50,'green','filled','o','MarkerEdgeColor','k');
alpha(g,0.1);
b = scatter(avg_B.mean_recenter_uv_2(:,1),avg_B.mean_recenter_uv_2(:,2),50,'blue','filled','o','MarkerEdgeColor','k');
alpha(b,0.1);
y = scatter(avg_Y.mean_recenter_uv_2(:,1),avg_Y.mean_recenter_uv_2(:,2),50,'yellow','filled','o','MarkerEdgeColor','k');
alpha(y,0.1);

%plot ellipses
colors = {[.9 0 0], [0 .9 0], [0 0 .9], [.9 .9 0]}; % Colors for ellipses
datasets = {avg_R.mean_recenter_uv_2(:,1), avg_R.mean_recenter_uv_2(:,2); avg_G.mean_recenter_uv_2(:,1), avg_G.mean_recenter_uv_2(:,2);...
    avg_B.mean_recenter_uv_2(:,1), avg_B.mean_recenter_uv_2(:,2); avg_Y.mean_recenter_uv_2(:,1), avg_Y.mean_recenter_uv_2(:,2)}; % Store data pairs
for i = 1:4
    [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
    s = plot(ellipse_translated(1, :), ellipse_translated(2, :), 'Color',colors{i}, 'LineWidth', 2);
    m = plot(mu(1), mu(2), 'kx', 'MarkerSize', 10, 'LineWidth', 2); % Mean marker
end

finalTable = allData{2}; %Flat
%separate illums 
redData = finalTable(finalTable.Illuminant == 'r', :);
greenData = finalTable(finalTable.Illuminant == 'g', :);
blueData = finalTable(finalTable.Illuminant == 'b', :);
yellowData = finalTable(finalTable.Illuminant == 'y', :);
avg_R = groupsummary(redData,{'ParticipantID'},'mean','recenter_uv_2');
avg_G = groupsummary(greenData,{'ParticipantID'},'mean','recenter_uv_2');
avg_B = groupsummary(blueData,{'ParticipantID'},'mean','recenter_uv_2');
avg_Y = groupsummary(yellowData,{'ParticipantID'},'mean','recenter_uv_2');

%figure;
r1 = scatter(avg_R.mean_recenter_uv_2(:,1),avg_R.mean_recenter_uv_2(:,2),50,'red','filled','^','MarkerEdgeColor','k');
alpha(r1,0.1);
g1 = scatter(avg_G.mean_recenter_uv_2(:,1),avg_G.mean_recenter_uv_2(:,2),50,'green','filled','^','MarkerEdgeColor','k');
alpha(g1,0.1);
b1 = scatter(avg_B.mean_recenter_uv_2(:,1),avg_B.mean_recenter_uv_2(:,2),50,'blue','filled','^','MarkerEdgeColor','k');
alpha(b1,0.1);
y1 = scatter(avg_Y.mean_recenter_uv_2(:,1),avg_Y.mean_recenter_uv_2(:,2),50,'yellow','filled','^','MarkerEdgeColor','k');
alpha(y1,0.1);

%plot ellipses
colors = {[.9 0 0], [0 .9 0], [0 0 .9], [.9 .9 0]}; % Colors for ellipses
datasets = {avg_R.mean_recenter_uv_2(:,1), avg_R.mean_recenter_uv_2(:,2); avg_G.mean_recenter_uv_2(:,1), avg_G.mean_recenter_uv_2(:,2);...
    avg_B.mean_recenter_uv_2(:,1), avg_B.mean_recenter_uv_2(:,2); avg_Y.mean_recenter_uv_2(:,1), avg_Y.mean_recenter_uv_2(:,2)}; % Store data pairs
for i = 1:4
    [mu, ellipse_translated] = compute_2std_ellipse(datasets{i,1}, datasets{i,2});
    s1 = plot(ellipse_translated(1, :), ellipse_translated(2, :), 'Color',colors{i}, 'LineWidth', 2,'LineStyle','--');
    m1 = plot(mu(1), mu(2), 'k*', 'MarkerSize', 10, 'LineWidth', 1.5); % Mean marker
end

xlabel('u′')
ylabel('v′')
axis equal
xlim([.14 .26]);
ylim([.40 .52]);
title('Average Recentered Achromatic Responses')
%legend([wi,ri,gi,bi,yi],{'white illum','red illum','green illum','blue illum','yellow illum'})