function [] = Draw_scatter_plot_Wang(varargin)
regForPlotWang=varargin{1};
alphaWang=varargin{2};
mSize=varargin{3};
if varargin{4}==0
    figure('units','centimeters','position',[3 1 20 18/24*20]);
    a=axes('position',[ 0.1    0.1300    0.24    0.32]);
else
    a=axes('position',varargin{4});
end
if ~isnumeric(varargin{5})
    t.Units='normalized';
    t.Position=[0.5 1.03 0.1];
    t=title(varargin{5},'FontSize',14);    
end
    if length(varargin)>5
        t_values_for_exmaples=varargin{6};
    end

colorPalette=[0.635 0.0784 0.184 ; 0 0 0.8 ;0.8 0.5 0 ; 0 0.749 0.749 ; 0 0 0 ; 0.3 0.3 0.3];
etaPlace=1;

axSize=ceil(max(max(abs(regForPlotWang))));
regForPlotWang(:,3)=regForPlotWang(:,3)<alphaWang;
regForPlotWang=[regForPlotWang atan2(regForPlotWang(:,2),regForPlotWang(:,1)) regForPlotWang(:,2).^2+regForPlotWang(:,1).^2];
regForPlotWangNotSig=regForPlotWang(regForPlotWang(:,3)==0,1:2);
regForPlotWangQ1=regForPlotWang(regForPlotWang(:,3)==1 & (regForPlotWang(:,4)>(7*pi/8) | regForPlotWang(:,4)<(-7*pi/8) | (regForPlotWang(:,4)>(-pi/8) & regForPlotWang(:,4)<(pi/8))),1:2);
regForPlotWangQ2=regForPlotWang(regForPlotWang(:,3)==1 & abs(regForPlotWang(:,4))>(3*pi/8) & abs(regForPlotWang(:,4))<(5*pi/8) ,1:2);
regForPlotWangDeltaQ=regForPlotWang(regForPlotWang(:,3)==1 & ((regForPlotWang(:,4)>(-3*pi/8) & regForPlotWang(:,4)<(-pi/8))|(regForPlotWang(:,4)>(5*pi/8) & regForPlotWang(:,4)<(7*pi/8))),1:2);
regForPlotWangState=regForPlotWang(regForPlotWang(:,3)==1 & ((regForPlotWang(:,4)>(pi/8) & regForPlotWang(:,4)<(3*pi/8))|(regForPlotWang(:,4)>(-7*pi/8) & regForPlotWang(:,4)<(-5*pi/8))),1:2);
%plot circle, r=line where f becomes significant
r=sqrt(mean([max(regForPlotWang(regForPlotWang(:,3)==0,5)) min(regForPlotWang(regForPlotWang(:,3)==1,5))]));
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
hold on
plot(regForPlotWangQ1(:,1),regForPlotWangQ1(:,2),'o','Color',colorPalette(1,:),'MarkerFaceColor',colorPalette(1,:),'MarkerSize',mSize);
plot(regForPlotWangQ2(:,1),regForPlotWangQ2(:,2),'o','Color',colorPalette(2,:),'MarkerFaceColor',colorPalette(2,:),'MarkerSize',mSize);
plot(regForPlotWangDeltaQ(:,1),regForPlotWangDeltaQ(:,2),'o','Color',colorPalette(3,:),'MarkerFaceColor',colorPalette(3,:),'MarkerSize',mSize);
plot(regForPlotWangState(:,1),regForPlotWangState(:,2),'o','Color',colorPalette(4,:),'MarkerFaceColor',colorPalette(4,:),'MarkerSize',mSize);

plot(regForPlotWangNotSig(:,1),regForPlotWangNotSig(:,2),'o','Color',colorPalette(5,:),'MarkerFaceColor',colorPalette(5,:),'MarkerSize',mSize);
plot(r*cos(-3*pi/8):1:20,(r*cos(-3*pi/8):1:20)*tan(-3*pi/8),'k--',r*cos(-pi/8):1:20,(r*cos(-pi/8):1:20)*tan(-pi/8),'k--',...
    r*cos(pi/8):1:20,(r*cos(pi/8):1:20)*tan(pi/8),'k--',r*cos(3*pi/8):1:20,(r*cos(3*pi/8):1:20)*tan(3*pi/8),'k--','LineWidth',1);
plot(r*cos(5*pi/8):-1:-20,(r*cos(5*pi/8):-1:-20)*tan(5*pi/8),'k--',r*cos(7*pi/8):-1:-20,(r*cos(7*pi/8):-1:-20)*tan(7*pi/8),'k--',...
    r*cos(-7*pi/8):-1:-20,(r*cos(-7*pi/8):-1:-20)*tan(-7*pi/8),'k--',r*cos(-5*pi/8):-1:-20,(r*cos(-5*pi/8):-1:-20)*tan(-5*pi/8),'k--','LineWidth',1);
plot(xp,yp,'k','LineWidth',1);

xlabel('t-values for \itQ_1','FontSize',12);
ylabel('t-values for \itQ_2','FontSize',12);
axis([-axSize axSize -axSize axSize]);
set(gca,'YTick',[-10 -5  0  5 10]);
set(gca,'XTick',[-10 -5 0  5 10]);
axis([-axSize axSize -axSize axSize]);
sizeTextBox=[0.07 0.05];
locationTextBoxX=[0.03 0.45 0.85];
locationTextBoxY=[0.07 0.49 0.91];


mTextBox = text(locationTextBoxX(1),locationTextBoxY(2),'\it-Q_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));

mTextBox = text(locationTextBoxX(3),locationTextBoxY(2),'\it+Q_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));

mTextBox = text(locationTextBoxX(2),locationTextBoxY(1),'\it-Q_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));

mTextBox = text(locationTextBoxX(2),locationTextBoxY(3),'\it+Q_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));

mTextBox = text(locationTextBoxX(3),locationTextBoxY(1),'\it\DeltaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(3,:));

mTextBox = text(locationTextBoxX(1),locationTextBoxY(3),'\it\DeltaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(3,:));

mTextBox = text(locationTextBoxX(1),locationTextBoxY(1),'\it-\SigmaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(4,:));

mTextBox = text(locationTextBoxX(3),locationTextBoxY(3),'\it+\SigmaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(4,:));
set(gca,'FontSize',12);
    

end
