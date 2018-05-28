function [] = Draw_single_bar_plot(regForPlot,alpha,sample_size,position)
if position==0
figure('units','centimeters','position',[3 3 24 18]);
axes1=set(gca,'position',[ 0.1    0.1300    0.42    0.7]);
else
    axes1=axes('position',position);
end
hold on
PermValue=mean(((abs(regForPlot(:,2))>alpha)+(abs(regForPlot(:,1))>alpha))>0);
pValue=binocdf(floor(PermValue*sample_size)-1,sample_size,0.05,'upper');
PermValueSE=sqrt(PermValue*(1-PermValue)/(sample_size-1));
b1=bar(1,PermValue,0.2,'w','EdgeColor','k','LineWidth',2);
plot([0.7 1.3],[1-0.975^2 1-0.975^2],'k--','LineWidth',2);
e=errorbar(1,PermValue,PermValueSE,'k','LineWidth',1,'Parent',axes1);
BarWidth=get(b1,'BarWidth');
error_bar_caps(1,PermValue,PermValueSE,BarWidth*1.5,1.5);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'fontsize',12);
axis([0.7 1.3 0 0.19]);
mTextBox = text(0.25,0.95,[num2str(round(PermValue*1000)/10),'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');
