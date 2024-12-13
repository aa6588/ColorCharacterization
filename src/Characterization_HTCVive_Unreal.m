clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Calibration new data setup Unreal
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('Calibration_UnrealStandard_Vive_6_11_2024.mat');
save_filename = 'dE_White_12_11_24.mat';
addpath(genpath('C:\Users\orange\Documents\GitHub\ColorCharacterization\src\color_transformations\'))
addpath(genpath('C:\Users\orange\Documents\GitHub\MCSL-Tools\Convert\'))

%% Comment or uncomment accordingly (HTC 5:255)
x = (0:17:255)./255;

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
display = [xs(end,1), ys(end,1);xs(end,2),ys(end,2);xs(end,3),ys(end,3);xs(end,1),ys(end,1)];
k1 = plot(primary(:,1),primary(:,2),'--k'); %gamut
k2 = plot(display(:,1),display(:,2),'-r'); %gamut
legend([k1 k2],{'sRGB Gamut','display gamut'})
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
xyY = XYZ2xyY(XYZ')';
XYZwhite = (PM * RGBSwhite')';

for i=1:length(aux)
    XYZmeas(i, :) = aux(i).color.XYZ;
end

xyYmeas = XYZ2xyY(XYZmeas')';

%% Plot the results
plotChrom();hold on
plot(xyY(:, 1),xyY(:, 2),'ro','MarkerSize',10,'LineWidth',2);
plot(xyYmeas(:,1),xyYmeas(:,2),'kx','markersize',12,'linewidth',2)
k1 = plot(primary(:,1),primary(:,2),'--k'); %gamut
k2 = plot(display(:,1),display(:,2),'-r'); %gamut
set(gca,'FontSize',15,'LineWidth',2)
box off
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
title('Chromaticity Error')


%% Compute deltae2000
lab_meas = XYZ2Lab(XYZmeas, White.color.XYZ');
lab_est  = XYZ2Lab(XYZ, XYZwhite);
%lab_nocalib  = rgb2lab(RGBStest, 'whitepoint', [1 1 1], ...
 %   'ColorSpace','linear-rgb');

dE = deltaE00(lab_meas', lab_est');
%dE_nocalib = deltaE00(lab_meas', lab_nocalib');


figure;
msize = 20;
for i=1:length(dE)
    plot(i, dE(i), 'o', 'color', RGBStest(i, :), ...
        'markerfacecolor', RGBStest(i, :), 'markersize', msize);hold on
end
plot(1:length(dE), ones(1, length(dE)), 'k--');

%ylim([0 5])
xlim([0 length(dE)])
set(gca, 'FontSize', 22)
xlabel('Verification Colors','FontSize',20)
ylabel('DeltaE00','FontSize',20)


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
load  lab_meas.mat
load whitepoints.mat
level = {'L40','L55','L70'};
illum = 'y';

XYZmeas = [rand_idx.(illum).(level{1}).XYZs;rand_idx.(illum).(level{2}).XYZs;rand_idx.(illum).(level{3}).XYZs];
lab_values = [rand_idx.(illum).(level{1}).Labs;rand_idx.(illum).(level{2}).Labs;rand_idx.(illum).(level{3}).Labs];
% XYZ = Lab2XYZ(lab_values,White.color.XYZ );
% xyY = XYZ2xyY(XYZ')';
% xyYmeas = XYZ2xyY(XYZmeas')';

%% Plot the results
% plotChrom();hold on
% plot(xyY(:, 1),xyY(:, 2),'ro','MarkerSize',10,'LineWidth',2);
% plot(xyYmeas(:,1),xyYmeas(:,2),'kx','markersize',12,'linewidth',2)
% k1 = plot(primary(:,1),primary(:,2),'--k'); %gamut
% k2 = plot(display(:,1),display(:,2),'-r'); %gamut
% set(gca,'FontSize',15,'LineWidth',2)
% box off
% xlabel('x','FontSize',15)
% ylabel('y','FontSize',15)
% title('Chromaticity Error Labs')


%% Compute deltae2000
lab_meas = XYZ2Lab(XYZmeas, wp_y);
lab_est = lab_values;
dE = deltaE00(lab_values',lab_meas');
dE_y = [mean(dE), min(dE), max(dE)];
viz = Lab2XYZ(lab_values,wp_y );
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
for i = 1:size(lab_est, 1)
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
for i = 1:size(lab_est, 1)
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
for i = 1:size(lab_est, 1)
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
radiometric_optim = (PM_optim \ [Xs(:, 4) Ys(:, 4) Zs(:, 4)]')';
for ch = 1:3

    RGBStestLinear(:, ch) = interp1(x, radiometric_optim(:, ch), ...
        RGBStest(:, ch));
    RGBSwhite(:, ch) = interp1(x, radiometric_optim(:, ch), 1);
end

XYZ = (PM_optim * RGBStestLinear')';
xyY = XYZ2xyY(XYZ')';
XYZwhite = (PM_optim * RGBSwhite')';

lab_meas = XYZ2Lab(XYZmeas, White.color.XYZ');
lab_est  = XYZ2Lab(XYZ, XYZwhite);
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
xlim([0 length(dE)])
set(gca, 'FontSize', 22)
xlabel('Verification Colors','FontSize',20)
ylabel('DeltaE00','FontSize',20)

%% Save characterization values and deltae errors
if ~isempty(save_filename)
    save(save_filename, 'PM','PM_optim', 'radiometric','radiometric_optim');
end

%% Display errors and estimated parameters
disp 'deltaE00 -> mean, median, std, min and max'
disp(num2str([mean(dE(126:end)) median(dE(126:end)) std(dE) min(dE(126:end)) max(dE(126:end))]))
disp 'Optim deltaE00 -> mean, median, std, min and max'
disp(num2str([mean(dE_optim(126:end)) median(dE_optim(126:end)) std(dE_optim) min(dE_optim(126:end)) max(dE_optim(126:end))]))

% disp 'deltaE00 no calibration -> mean, median, std, min and max'
% disp(num2str([mean(dE_nocalib) median(dE_nocalib) ...
%     std(dE_nocalib) min(dE_nocalib) max(dE_nocalib)]))

%dEtable = table([dE_w;dE_r;dE_g;dE_b;dE_y],[dE_w_optim;dE_r_optim;dE_g_optim;dE_b_optim;dE_y_optim],'VariableNames',{'deltaE00 (mean,min,max)','optim deltaE (mean,min,max)'},'RowNames',{'White','Red','Green','Blue','Yellow'})
dEtable_labs = table([dE_w;dE_r;dE_g;dE_b;dE_y],'VariableNames',{'Lab deltaE00 (mean,min,max)'},'RowNames',{'White','Red','Green','Blue','Yellow'})
