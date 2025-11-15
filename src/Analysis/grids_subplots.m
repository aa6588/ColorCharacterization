% uv grids

lightness = 'L55';
figure;
green = [0 0.6 0.2];
yellow = [0.85, 0.75, 0.1];
t = tiledlayout(2,2, 'TileSpacing', 'compact', 'Padding', 'compact'); 
title(t, 'Illuminant Adjustment Grids');
nexttile;
hold on;
scatter(uv_aims.r.(lightness)(:,1),uv_aims.r.(lightness)(:,2),50,'ro')
scatter(illum_uvY(2,1),illum_uvY(2,2),60,'filled','rs','MarkerEdgeColor','k','LineWidth',1);
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'filled','ws','MarkerEdgeColor','k','LineWidth',1);
xlabel('u''')
ylabel('v''')
    ylim([.4 .48])
    xlim([.16 .26])
    axis equal
title('Red Illuminant Grid')

nexttile;
hold on
scatter(uv_aims.g.(lightness)(:,1),uv_aims.g.(lightness)(:,2),50,green,'o')
scatter(illum_uvY(3,1),illum_uvY(3,2),60,green,'filled','s','MarkerEdgeColor','k','LineWidth',1);
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'filled','ws','MarkerEdgeColor','k','LineWidth',1);
hold off
xlabel('u''')
ylabel('v''')
    ylim([.44 .5])
    xlim([.14 .22])
    axis equal
title('Green Illuminant Grid')

nexttile;
hold on
scatter(uv_aims.b.(lightness)(:,1),uv_aims.b.(lightness)(:,2),50,'bo')
scatter(illum_uvY(4,1),illum_uvY(4,2),60,'filled','bs','MarkerEdgeColor','k','LineWidth',1);
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'filled','ws','MarkerEdgeColor','k','LineWidth',1);
xlabel('u''')
ylabel('v''')
    ylim([.4 .48])
    xlim([.14 .24])
    axis equal
title('Blue Illuminant Grid')

nexttile;
hold on
scatter(uv_aims.y.(lightness)(:,1),uv_aims.y.(lightness)(:,2),50,yellow,'o')
scatter(illum_uvY(5,1),illum_uvY(5,2),60,yellow,'filled','s','MarkerEdgeColor','k','LineWidth',1);
scatter(illum_uvY(1,1),illum_uvY(1,2),60,'filled','ws','MarkerEdgeColor','k','LineWidth',1);
xlabel('u''')
ylabel('v''')
    ylim([.44 .52])
    xlim([.18 .24])
    axis equal
title('Yellow Illuminant Grid')

savepath = 'C:\Users\Andrea\Documents\GitHub\ColorCharacterization\Figs\Methods\';
    fileName = fullfile(savepath,'adjGrids');
    exportgraphics(gcf, [fileName,'.tiff'], 'Resolution', 300);
    savefig(gcf, [fileName,'.fig']);