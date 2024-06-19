function FigC = plotChrom()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%REMEMBER TO ADD MCSL TOOLBOX TO PATH!!!!!
data = xlsread('StdObsFuncs.xls'); wl = data(:,1); cmf2 = data(:,2:4);
sl_xy(:,1) = cmf2(:,1)./(cmf2(:,1)+cmf2(:,2)+cmf2(:,3)); %computing x
sl_xy(:,2) = cmf2(:,2)./(cmf2(:,1)+cmf2(:,2)+cmf2(:,3)); %computing y
slRGB = xyz2rgb(cmf2);     
slRGB = min(max(slRGB,0),1);

FigC = figure;
hold on
box on
for i = 2:length(wl)
    plot(sl_xy([i-1 i],1),sl_xy([i-1 i],2),'Color',slRGB(i,:))
end
plot([0.175161;0.73469],[0.00525;0.26531],'Color',[0.4940 0.1840 0.5560])

title('Spectral Locus');xlabel('x');ylabel('y')
axis equal
axis([0 .8 0 .9])
grid on
%set(gca,'Color',[.9 .9 .9],'GridColor','w','GridAlpha',1)
set(gca,'TickDir','out')
set(gca,'FontSize',12)
