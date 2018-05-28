function [] = Draw_scatter_plot_on_policy_and_state(varargin)
regForPlot=varargin{1};

%if 100 added to regForPlot other value determines axis
if regForPlot(end,1)==100
    axSize=regForPlot(end,2);
    regForPlot(end,:)=[];
else
  axSize=ceil(max(abs(regForPlot)));
end

alpha=varargin{2};
mSize=varargin{3};

if varargin{4}==0
    figure('units','centimeters','position',[3 1 24 18]);
    a=axes('position',[ 0.1    0.1300    0.24    0.32]);
else
    a=axes('position',varargin{4});
end
if ~isnumeric(varargin{5})
    t.Units='normalized';
    t.Position=[1.1 1.03 0.1];
    t=title(varargin{5},'FontSize',14);    
end
if length(varargin)>5
    t_values_for_exmaples=varargin{6};
end

colorPalette=[0.635 0.0784 0.184 ; 0 0 0.8 ;0.8 0.5 0 ; 0 0.749 0.749 ; 0 0 0 ; 0 0.498039215803146 0];
regForPlotNotSig=regForPlot(((abs(regForPlot(:,1))<alpha)+ (abs(regForPlot(:,2))<alpha))==2,1:2);
regForPlotSigmaQ=regForPlot(((abs(regForPlot(:,1))>alpha)+ (abs(regForPlot(:,2))<alpha))==2,1:2);
regForPlotDeltaQ=regForPlot(((abs(regForPlot(:,1))<alpha)+ (abs(regForPlot(:,2))>alpha))==2,1:2);
regForPlotBothSig=regForPlot(((abs(regForPlot(:,1))>alpha)+ (abs(regForPlot(:,2))>alpha))==2,1:2);
regForPlotQ2=regForPlotBothSig(sign(regForPlotBothSig(:,1))~=sign(regForPlotBothSig(:,2)),1:2);
regForPlotQ1=regForPlotBothSig(sign(regForPlotBothSig(:,1))==sign(regForPlotBothSig(:,2)),1:2);
hold on
plot(-axSize:axSize,ones(axSize*2+1,1)*-alpha,'k--',-axSize:axSize,ones(axSize*2+1,1)*alpha,'k--',ones(axSize*2+1,1)*-alpha,...
    -axSize:axSize,'k--',ones(axSize*2+1,1)*alpha,-axSize:axSize,'k--', 'LineWidth',1);
plot(regForPlotQ1(:,1),regForPlotQ1(:,2),'o','Color',colorPalette(1,:),'MarkerFaceColor',colorPalette(1,:),'MarkerSize',mSize);
plot(regForPlotQ2(:,1),regForPlotQ2(:,2),'o','Color',colorPalette(2,:),'MarkerFaceColor',colorPalette(2,:),'MarkerSize',mSize);
plot([regForPlotDeltaQ(:,1) ; 100],[regForPlotDeltaQ(:,2)  ; 100],'o','Color',colorPalette(3,:),'MarkerFaceColor',colorPalette(3,:),'MarkerSize',mSize);
plot(regForPlotSigmaQ(:,1),regForPlotSigmaQ(:,2),'o','Color',colorPalette(4,:),'MarkerFaceColor',colorPalette(4,:),'MarkerSize',mSize);
plot(regForPlotNotSig(:,1),regForPlotNotSig(:,2),'o','Color',colorPalette(5,:),'MarkerFaceColor',colorPalette(5,:),'MarkerSize',mSize);

if length(varargin)>6
    plot(regForPlot(t_values_for_exmaples,1),regForPlot(t_values_for_exmaples,2),'s','Color',colorPalette(5,:),'MarkerSize',mSize+6,'LineWidth',2,'MarkerFaceColor','w');
    plot(regForPlot(t_values_for_exmaples(1),1),regForPlot(t_values_for_exmaples(1),2),'o','Color',colorPalette(1,:),'MarkerFaceColor',colorPalette(1,:),'MarkerSize',mSize);
    plot(regForPlot(t_values_for_exmaples(2),1),regForPlot(t_values_for_exmaples(2),2),'o','Color',colorPalette(2,:),'MarkerFaceColor',colorPalette(2,:),'MarkerSize',mSize);
end
  xlabel('t-values for \it\SigmaQ','FontSize',12);
 ylabel('t-values for \it\DeltaQ','FontSize',12);

axis([-axSize axSize -axSize axSize]);
if axSize>5
    set(gca,'YTick',[-10 -5 -2 0 2 5 10]);
    set(gca,'XTick',[-10 -5 -2 0 2 5 10]);
else
    set(gca,'YTick',[-4 -2 0  2 4])
    set(gca,'XTick',[-4 -2  0 2 4])
end
sizeTextBox=[0.07 0.05];

locationTextBoxX=[0.03 0.45 0.82];
locationTextBoxY=[0.08 0.49 0.92];

mTextBox = text(locationTextBoxX(1),locationTextBoxY(2),'\it-\SigmaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(4,:));
mTextBox = text(locationTextBoxX(3),locationTextBoxY(2),'\it+\SigmaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(4,:));
mTextBox = text(locationTextBoxX(2),locationTextBoxY(1),'\it\DeltaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(3,:));
mTextBox = text(locationTextBoxX(2),locationTextBoxY(3),'\it\DeltaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(3,:));
mTextBox = text(locationTextBoxX(3),locationTextBoxY(1),'\it+Q_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));
mTextBox = text(locationTextBoxX(1),locationTextBoxY(3),'\it-Q_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));
mTextBox = text(locationTextBoxX(1),locationTextBoxY(1),'\it-Q_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));
mTextBox = text(locationTextBoxX(3),locationTextBoxY(3),'\it+Q_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));
set(gca,'FontSize',12)
end