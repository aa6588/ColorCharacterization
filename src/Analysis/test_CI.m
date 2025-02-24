%made up data to test CI equations
load models_info.mat
load FinalSceneIllums.mat illum_xy

%chrom2CI(adjXYZ_white(part,:),obsXYZ(part,:), D65XYZ,chrom_test_uv);
D65XYZ = whitepoint("d65").*model.w.wp(2);
chrom_test_uv = xyY2uvY(illum_xyY); 
chrom_test_uv = chrom_test_uv(2,:); %red

%got this from real data in L55 condition
adjXYZ_white = uvY2XYZ([.1997,.4656,11.22]);
%get cursor_infos by selecting points on plot, save mat

%get uv info from selected points
for i = 1:length(cursor_info)
rowIdx = find(ismember(uv_aims.r.L55(:,1:2), cursor_info(i).Position,'rows'));
uvs(i,:) = uv_aims.r.L55(rowIdx,:);
end
%convert uvY to XYZ
obsXYZ = uvY2XYZ(uvs);
%calculate CIs for points
for i = 1:length(obsXYZ)
[Cis(i), eq_uvs(i,:)] = chrom2CI(adjXYZ_white,obsXYZ(i,:), D65XYZ,chrom_test_uv);
end
%convert to string for plot
Cis = string(round(Cis',3));
%get plot from before with grid
hold on
scatter(uvs(:,1),uvs(:,2),50,'filled','go')
scatter(eq_uvs(:,1),eq_uvs(:,2),50,'bs')
for i = 1:length(uvs)
    text(uvs(i,1), uvs(i,2), Cis{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 12);
end