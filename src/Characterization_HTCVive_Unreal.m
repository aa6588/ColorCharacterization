clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Calibration new data setup Unreal
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('Calibration_UnrealStandard_Vive_6_11_2024.mat');
 save_filename = 'dE_Calibration_D65_Vive_07_9_2024.mat';
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\src\color_transformations\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))

%% Comment or uncomment accordingly (HTC 5:255)
x = (0:5:255)./255;

primaries(1, :) = [Red];
primaries(2, :) = [Green];
primaries(3, :) = [Blue];
primaries(4, :) = [Gray];

white = [White]; 


%figure
plotChrom();hold on
cols = {'r', 'g', 'b', 'k'};
rgb = zeros(16,3,4);
for i=1:size(primaries, 1)
    
    for j=1:size(primaries, 2)
        aux0 = [primaries(i, j).color.xyY];
        aux1 = [primaries(i, j).color.XYZ];
        rgb(j,:,i) = XYZ2RGB(aux1);
        Ys(j, i) = aux0(3) ;
        xs(j, i) = aux0(1) ;
        ys(j, i) = aux0(2) ;
        Xs(j, i) = aux1(1) ;
        Zs(j, i) = aux1(3) ;
        SPECTRA((i-1)*size(primaries, 2) + j,:) = ...
            primaries(i, j).radiance.value;
    end
    scatter(xs(:, i), ys(:, i), 60, rgb(:,:,i),'filled','MarkerEdgeColor','k');
end

primary = [0.64, .33; .3, .6; .15, .06; .64, .33];
k1 = plot(primary(:,1),primary(:,2),'--k'); %gamut
legend(k1,'sRGB Gamut')
title('Primary Ramp Chromaticity')

yticks([0 0.2 0.4 0.6 0.8])
xticks([0 0.2 0.4 0.6 0.8])

set(gca,  'FontSize', 12, 'fontname','Times New Roman', 'Color', 'none');

figure;
scatter(x,Ys(:,1),40,"red",'filled')
xlabel('Reflectance RGBs')
ylabel('Luminance (cd/m^2)')
title('Red Ramp')

figure;
scatter(x,Ys(:,2),40,"green",'filled')
xlabel('Reflectance RGBs')
ylabel('Luminance (cd/m^2)')
title('Green Ramp')

figure;
scatter(x,Ys(:,3),40,"blue",'filled')
xlabel('Reflectance RGBs')
ylabel('Luminance (cd/m^2)')
title('Blue Ramp')

figure;
scatter(x,Ys(:,4),40,cols{4},'filled')
xlabel('Reflectance RGBs')
ylabel('Luminance (cd/m^2)')
title('Gray Ramp')
%% spectra
figure
for i=1:size(primaries, 1)
    subplot(1, 4, i)
    
    for j=1:size(primaries, 2)
        
        plot(380:780,primaries(i, j).radiance.value, cols{i}); hold on
        
    end
    set(gca,  'FontSize', 30, 'fontname','TeXGyreTermes');
    grid on
    set(gcf,'renderer','Painters');
end

figure
plot(380:780,primaries(1, end).radiance.value, [cols{1}, '-.'],...
    'LineWidth',2); hold on
plot(380:780,primaries(2, end).radiance.value , [cols{2}, '-'],...
    'LineWidth',2); 
plot(380:780,primaries(3, end).radiance.value, [cols{3}, '--'],...
    'LineWidth',2); 
set(gca,  'FontSize', 15, 'fontname','Times New Roman');
set(gcf,'renderer','Painters');
legend('Red primary','Green primary','Blue primary', ...
    'Interpreter','latex','Location','northeast','FontSize',12);
legend('boxoff')
xlabel('Wavelength (nm)', 'Interpreter','latex');
ylabel('Radiance (W/m^2-sr)');
xlim([380 780])
xticks([400 500 600 700])


figure
plot(380:780,primaries(1, end).radiance.value ./ ...
    max(primaries(1, end).radiance.value), [cols{1}, '-.'],...
    'LineWidth',2); hold on
plot(380:780,primaries(2, end).radiance.value./ ...
    max(primaries(2, end).radiance.value) , [cols{2}, '-'],...
    'LineWidth',2); 
plot(380:780,primaries(3, end).radiance.value ./ ...
    max(primaries(3, end).radiance.value), [cols{3}, '--'],...
    'LineWidth',2); 
set(gca,  'FontSize', 15, 'fontname','Times New Roman');
set(gcf,'renderer','Painters');
legend('Red primary','Green primary','Blue primary', ...
    'Interpreter','latex','Location','northeast','FontSize',12);
legend('boxoff')
xlabel('Wavelength (nm)', 'Interpreter','latex');
ylabel('Normalized power', 'Interpreter','latex');
axis([380 780 0 1])
xticks([400 500 600 700])

for i=1:size(Xs, 1)
    additiviy_diff(i,1)= ((Xs(i, 4) - ...
        (Xs(i, 1) + Xs(i, 2) + Xs(i, 3))')./(Xs(i, 4)'));
    additiviy_diff(i,2)= ((Ys(i, 4) - ...
        (Ys(i, 1) + Ys(i, 2) + Ys(i, 3))')./(Ys(i, 4)'));
    additiviy_diff(i,3)= ((Zs(i, 4) - ...
        (Zs(i, 1) + Zs(i, 2) + Zs(i, 3))')./(Zs(i, 4)'));
end
disp('Additivity: ')
disp(num2str(sum(abs(additiviy_diff(~any( isnan( additiviy_diff ) | ...
    isinf( additiviy_diff ), 2 ), :)))))

additiviy_difff= 100*((Xs(end, 4) - ...
    (Xs(end, 1) + Xs(end, 2) + Xs(end, 3)))/Xs(end, 4));
disp(['Additiviy (only white)', num2str(additiviy_difff)])

%% Estimated gamma curves for each channel

%changed PM so it actually makes sense now
for ch=1:3
    PM(:,ch) = [Xs(end, ch) Ys(end, ch) Zs(end, ch)];
end

%x = (0:5:255)./255;
N = length(x);

radiometric = (PM \ [Xs(:, 4) Ys(:, 4) Zs(:, 4)]')';

figure;
scatter(x,radiometric,40,"filled");
xlabel('Unreal RGB Reflectance');ylabel('RGB radiometric scalar');title('EOTF');

%% Perform the validation using the calibration matrix and gamma values
% LOOK AT TEST COLORS RGB
load PredefinedRGB.mat

RGBStest = [rgb;rgbs]; 
aux  = Validation_rand; 

for ch = 1:3

    RGBStestLinear(:, ch) = interp1(x, radiometric(:, ch), ...
        RGBStest(:, ch));
    RGBSwhite(:, ch) = interp1(x, radiometric(:, ch), 1);
    
end

XYZ = (PM * RGBStestLinear')';
xyY = XYZToxyY(XYZ')';
XYZwhite = (PM * RGBSwhite')';

for i=1:length(aux)
    XYZmeas(i, :) = aux(i).color.XYZ;
end

xyYmeas = XYZToxyY(XYZmeas')';

%% Plot the results
plotChrom();hold on
plot(xyY(:, 1),xyY(:, 2),'bo','MarkerSize',10,'LineWidth',2);
plot(xyYmeas(:,1),xyYmeas(:,2),'kx','markersize',12,'linewidth',2)
set(gca,'FontSize',15,'LineWidth',2)
box off
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
title('Chromaticity Error')


%% Compute deltae2000
lab_meas = xyz2lab(XYZmeas, 'whitepoint', white.color.XYZ');
lab_est  = xyz2lab(XYZ,     'whitepoint', XYZwhite);
lab_nocalib  = rgb2lab(RGBStest, 'whitepoint', [1 1 1], ...
    'ColorSpace','linear-rgb');

dE = deltaE00(lab_meas', lab_est');
dE_nocalib = deltaE00(lab_meas', lab_nocalib');


figure;
msize = 20;
for i=1:length(dE)
    plot(i, dE(i), 'o', 'color', RGBStest(i, :), ...
        'markerfacecolor', RGBStest(i, :), 'markersize', msize);hold on
end
plot(1:length(dE), ones(1, length(dE)), 'k--');

%ylim([0 5])
set(gca, 'FontSize', 22)
xlabel('Colours','FontSize',40)
ylabel('DeltaE00','FontSize',40)


msize=15;
figure;
subplot 131;
for i = 2:size(lab_est, 1)
    plot(lab_est(i, 2), lab_est(i, 3), 'o', 'color', RGBStest(i, :), ...
        'markerfacecolor', RGBStest(i, :), 'markersize', msize);hold on
    
    plot(lab_meas(i, 2), lab_meas(i, 3), 'kx', 'markersize', msize);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
axis equal
axis([min([lab_est(:, 2); lab_meas(:, 2)]) max([lab_est(:, 2);...
    lab_meas(:, 2)]) min([lab_est(:, 3); lab_meas(:, 3)]) ...
    max([lab_meas(:, 3);lab_est(:, 3)])])

subplot 132;
for i = 2:size(lab_est, 1)
    plot(lab_est(i, 2), lab_est(i, 1), 'o', 'color', RGBStest(i, :), ...
        'markerfacecolor', RGBStest(i, :), 'markersize', msize);hold on
    
    plot(lab_meas(i, 2), lab_meas(i, 1), 'kx', 'markersize', msize);hold on
    xlabel('a*','FontSize',15)
    ylabel('L*','FontSize',15)
end
axis equal
axis([min([lab_est(:, 2); lab_meas(:, 2)]) max([lab_est(:, 2);...
    lab_meas(:, 2)]) min([lab_est(:, 1); lab_meas(:, 1)]) ...
    max([lab_meas(:, 1);lab_est(:, 1)])])

subplot 133;
for i = 2:size(lab_est, 1)
    plot(lab_est(i, 3), lab_est(i, 1), 'o', 'color', RGBStest(i, :), ...
        'markerfacecolor', RGBStest(i, :), 'markersize', msize);hold on
    
    plot(lab_meas(i, 3), lab_meas(i, 1), 'kx', 'markersize', msize);hold on
    xlabel('b*','FontSize',15)
    ylabel('L*','FontSize',15)
end
axis equal
axis([min([lab_est(:, 3); lab_meas(:, 3)]) max([lab_est(:, 3);...
    lab_meas(:, 3)]) min([lab_est(:, 1); lab_meas(:, 1)]) ...
    max([lab_meas(:, 1);lab_est(:, 1)])])

%% Perform the validation using the calibration matrix and gamma values
% LOOK AT TEST COLORS Labs
%NEED TO COMPARE TO ORIGININAL LABS
aux  = Validation_lab; 

clear XYZmeas
for i=1:length(aux)
    XYZmeas(i, :) = aux(i).color.XYZ;
end
XYZ = Lab2XYZ(lab_values,[95.04  100  108.88] );
xyY = XYZToxyY(XYZ')';
xyYmeas = XYZToxyY(XYZmeas')';

%% Plot the results
plotChrom();hold on
plot(xyY(:, 1),xyY(:, 2),'bo','MarkerSize',10,'LineWidth',2);
plot(xyYmeas(:,1),xyYmeas(:,2),'kx','markersize',12,'linewidth',2)
set(gca,'FontSize',15,'LineWidth',2)
box off
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
title('Chromaticity Error Labs')


%% Compute deltae2000
lab_meas = xyz2lab(XYZmeas, 'whitepoint', white.color.XYZ');
lab_est  = lab_values;

dE = deltaE00(lab_meas', lab_est');
viz = Lab2XYZ(lab_values,[95.04  100  108.88] );
rgb_viz = XYZ2RGB(viz);

figure;
msize = 20;
for i=1:length(dE)
    plot(i, dE(i), 'o', 'color', rgb_viz(i, :), ...
        'markerfacecolor', rgb_viz(i, :), 'markersize', msize);hold on
end
plot(1:length(dE), ones(1, length(dE)), 'k--');

%ylim([0 5])
set(gca, 'FontSize', 22)
xlabel('Colours','FontSize',40)
ylabel('DeltaE00','FontSize',40)


msize=15;
figure;
subplot 131;
for i = 2:size(lab_est, 1)
    plot(lab_est(i, 2), lab_est(i, 3), 'o', 'color', rgb_viz(i, :), ...
        'markerfacecolor', rgb_viz(i, :), 'markersize', msize);hold on
    
    plot(lab_meas(i, 2), lab_meas(i, 3), 'kx', 'markersize', msize);hold on
    xlabel('a*','FontSize',15)
    ylabel('b*','FontSize',15)
end
axis equal
axis([min([lab_est(:, 2); lab_meas(:, 2)]) max([lab_est(:, 2);...
    lab_meas(:, 2)]) min([lab_est(:, 3); lab_meas(:, 3)]) ...
    max([lab_meas(:, 3);lab_est(:, 3)])])

subplot 132;
for i = 2:size(lab_est, 1)
    plot(lab_est(i, 2), lab_est(i, 1), 'o', 'color', rgb_viz(i, :), ...
        'markerfacecolor', rgb_viz(i, :), 'markersize', msize);hold on
    
    plot(lab_meas(i, 2), lab_meas(i, 1), 'kx', 'markersize', msize);hold on
    xlabel('a*','FontSize',15)
    ylabel('L*','FontSize',15)
end
axis equal
axis([min([lab_est(:, 2); lab_meas(:, 2)]) max([lab_est(:, 2);...
    lab_meas(:, 2)]) min([lab_est(:, 1); lab_meas(:, 1)]) ...
    max([lab_meas(:, 1);lab_est(:, 1)])])

subplot 133;
for i = 2:size(lab_est, 1)
    plot(lab_est(i, 3), lab_est(i, 1), 'o', 'color', rgb_viz(i, :), ...
        'markerfacecolor', rgb_viz(i, :), 'markersize', msize);hold on
    
    plot(lab_meas(i, 3), lab_meas(i, 1), 'kx', 'markersize', msize);hold on
    xlabel('b*','FontSize',15)
    ylabel('L*','FontSize',15)
end
axis equal
axis([min([lab_est(:, 3); lab_meas(:, 3)]) max([lab_est(:, 3);...
    lab_meas(:, 3)]) min([lab_est(:, 1); lab_meas(:, 1)]) ...
    max([lab_meas(:, 1);lab_est(:, 1)])])
%% optional optimization
options = optimset('Display','iter');
PM = double(PM);

[PM_optim, fval] = fminsearch(@Day,PM,options,XYZmeas,RGBStest,x,Xs,Ys,Zs);

%rerun deltaE
radiometric_opitm = (PM_optim \ [Xs(:, 4) Ys(:, 4) Zs(:, 4)]')';
for ch = 1:3

    RGBStestLinear(:, ch) = interp1(x, radiometric_optim(:, ch), ...
        RGBStest(:, ch));
    RGBSwhite(:, ch) = interp1(x, radiometric_optim(:, ch), 1);
end

XYZ = (PM_optim * RGBStestLinear')';
xyY = XYZToxyY(XYZ')';
XYZwhite = (PM_optim * RGBSwhite')';

lab_meas = xyz2lab(XYZmeas, 'whitepoint', white.color.XYZ');
lab_est  = xyz2lab(XYZ,     'whitepoint', XYZwhite);
dE_optim = deltaE00(lab_meas', lab_est');

%chromaticity optim
plotChrom();hold on
plot(xyY(:, 1),xyY(:, 2),'bo','MarkerSize',10,'LineWidth',2);
plot(xyYmeas(:,1),xyYmeas(:,2),'kx','markersize',12,'linewidth',2)
set(gca,'FontSize',15,'LineWidth',2)
box off
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
title('Chromaticity Error Optimized')

%deltaE
figure;
msize = 20;
for i=1:length(dE_optim)
    plot(i, dE_optim(i), 'o', 'color', RGBStest(i, :), ...
        'markerfacecolor', RGBStest(i, :), 'markersize', msize);hold on
end
plot(1:length(dE_optim), ones(1, length(dE_optim)), 'k--');

%% Save characterization values and deltae errors
if ~isempty(save_filename)
    save(save_filename, 'PM','PM_optim', 'radiometric','radiometric_optim');
end

%% Display errors and estimated parameters
disp 'deltaE00 -> mean, median, std, min and max'
disp(num2str([mean(dE) median(dE) std(dE) min(dE) max(dE)]))
disp 'Optim deltaE00 -> mean, median, std, min and max'
disp(num2str([mean(dE_optim) median(dE_optim) std(dE_optim) min(dE_optim) max(dE_optim)]))

disp 'deltaE00 no calibration -> mean, median, std, min and max'
disp(num2str([mean(dE_nocalib) median(dE_nocalib) ...
    std(dE_nocalib) min(dE_nocalib) max(dE_nocalib)]))
