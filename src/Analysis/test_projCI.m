%made up data to test CI equations
%load models_info.mat
%load FinalSceneIllums.mat illum_xyY

%chrom2CI(adjXYZ_white(part,:),obsXYZ(part,:), D65XYZ,chrom_test_uv);
D65 = XYZ2uvY(whitepoint("d65").*model.w.wp(2));
chrom_test_uv = xyY2uvY(illum_xyY); 
chrom_test_uv = chrom_test_uv(2,:); %red

%calculate CIs for points
for i = 1:length(obsXYZ)
[Cis(i)] = computeCIproj(D65(1:2),chrom_test_uv(1:2), D65(1:2),uvs(i,1:2));
end
%convert to string for plot
Cis = string(round(Cis',3));
%get plot from before with grid

hold on
scatter(uvs(:,1),uvs(:,2),50,'filled','go')
%scatter(eq_uvs(:,1),eq_uvs(:,2),50,'bs')
for i = 1:length(uvs)
    text(uvs(i,1), uvs(i,2), Cis{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 12);
end