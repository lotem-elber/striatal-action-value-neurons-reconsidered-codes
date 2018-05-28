function []=Draw_plot_permutation_Kim(varargin)
colorPalette=[0.635 0.0784 0.184 ; 0 0 0.8 ;0.8 0.5 0 ; 0 0.749 0.749 ; 0 0 0 ; 0 0.498039215803146 0];
sample_scatter=varargin{6};
numSamples=varargin{7};
samVec=1:sample_scatter;
regForPlot=varargin{1}(samVec,:);
alpha=varargin{2};
mSize=varargin{3};
if varargin{4}==0
    figure('units','centimeters','position',[3 1 20 18/24*20]);
    a=axes('position',[ 0.1    0.1300    0.24    0.32]);
else
    a=axes('position',varargin{4});
end
if ~isnumeric(varargin{5})
    t.Units='normalized';
    t.Position=[1.1 1.03 0.1];
    t=title(varargin{5},'FontSize',14);    
end

regForPlotNotSig=regForPlot(((abs(regForPlot(:,1))<2)+ (abs(regForPlot(:,2))<2))==2,1:2);
regForPlotQ1=regForPlot(((abs(regForPlot(:,1))>2)+ (abs(regForPlot(:,2))<2))==2,1:2);
regForPlotQ2=regForPlot(((abs(regForPlot(:,1))<2)+ (abs(regForPlot(:,2))>2))==2,1:2);
regForPlotBothSig=regForPlot(((abs(regForPlot(:,1))>2)+ (abs(regForPlot(:,2))>2))==2,1:2);
regForPlotDeltaQ=regForPlotBothSig(sign(regForPlotBothSig(:,1))~=sign(regForPlotBothSig(:,2)),1:2);
regForPlotSigmaQ=regForPlotBothSig(sign(regForPlotBothSig(:,1))==sign(regForPlotBothSig(:,2)),1:2);
regForPlotPermutation=regForPlot(find(regForPlot(:,3)),1:2);

regForPlotNotSigPerm=regForPlotPermutation(((abs(regForPlotPermutation(:,1))<2)+ (abs(regForPlotPermutation(:,2))<2))==2,1:2);
regForPlotQ1Perm=regForPlotPermutation(((abs(regForPlotPermutation(:,1))>2)+ (abs(regForPlotPermutation(:,2))<2))==2,1:2);
regForPlotQ2Perm=regForPlotPermutation(((abs(regForPlotPermutation(:,1))<2)+ (abs(regForPlotPermutation(:,2))>2))==2,1:2);
regForPlotBothSigPerm=regForPlotPermutation(((abs(regForPlotPermutation(:,1))>2)+ (abs(regForPlotPermutation(:,2))>2))==2,1:2);
regForPlotDeltaQPerm=regForPlotBothSigPerm(sign(regForPlotBothSigPerm(:,1))~=sign(regForPlotBothSigPerm(:,2)),1:2);
regForPlotSigmaQPerm=regForPlotBothSigPerm(sign(regForPlotBothSigPerm(:,1))==sign(regForPlotBothSigPerm(:,2)),1:2);

axSize=ceil(max(max(abs(regForPlot))));

hold on
plot(-axSize:axSize,ones(axSize*2+1,1)*-2,'k--',-axSize:axSize,ones(axSize*2+1,1)*2,'k--',ones(axSize*2+1,1)*-2,...
    -axSize:axSize,'k--',ones(axSize*2+1,1)*2,-axSize:axSize,'k--','LineWidth',1);

plot(regForPlotQ1(:,1),regForPlotQ1(:,2),'o','Color',colorPalette(1,:),'MarkerFaceColor',colorPalette(1,:),'MarkerSize',mSize);
plot(regForPlotQ2(:,1),regForPlotQ2(:,2),'o','Color',colorPalette(2,:),'MarkerFaceColor',colorPalette(2,:),'MarkerSize',mSize);
plot([regForPlotDeltaQ(:,1) ; 100],[regForPlotDeltaQ(:,2)  ; 100],'o','Color',colorPalette(3,:),'MarkerFaceColor',colorPalette(3,:),'MarkerSize',mSize);
plot(regForPlotSigmaQ(:,1),regForPlotSigmaQ(:,2),'o','Color',colorPalette(4,:),'MarkerFaceColor',colorPalette(4,:),'MarkerSize',mSize);
plot(regForPlotNotSig(:,1),regForPlotNotSig(:,2),'o','Color',colorPalette(5,:),'MarkerFaceColor',colorPalette(5,:),'MarkerSize',mSize);

plot(regForPlotPermutation(:,1),regForPlotPermutation(:,2),'^','Color',colorPalette(6,:),'MarkerFaceColor',colorPalette(6,:),'MarkerSize',mSize+5);
plot(regForPlotQ1Perm(:,1),regForPlotQ1Perm(:,2),'o','Color',colorPalette(1,:),'MarkerFaceColor',colorPalette(1,:),'MarkerSize',mSize);
plot(regForPlotQ2Perm(:,1),regForPlotQ2Perm(:,2),'o','Color',colorPalette(2,:),'MarkerFaceColor',colorPalette(2,:),'MarkerSize',mSize);
plot([regForPlotDeltaQPerm(:,1) ; 100],[regForPlotDeltaQPerm(:,2)  ; 100],'o','Color',colorPalette(3,:),'MarkerFaceColor',colorPalette(3,:),'MarkerSize',mSize);
plot(regForPlotSigmaQPerm(:,1),regForPlotSigmaQPerm(:,2),'o','Color',colorPalette(4,:),'MarkerFaceColor',colorPalette(4,:),'MarkerSize',mSize);
plot(regForPlotNotSigPerm(:,1),regForPlotNotSigPerm(:,2),'o','Color',colorPalette(5,:),'MarkerFaceColor',colorPalette(5,:),'MarkerSize',mSize);

xlabel('t-values for \itQ_1','FontSize',12);
ylabel('t-values for \itQ_2','FontSize',12);
axis([-axSize axSize -axSize axSize]);

set(gca,'YTick',[-10 -5 -2  0 2 5 10]);
set(gca,'XTick',[-10 -5 -2 0 2 5 10]);
set(gca,'FontSize',12);
sizeTextBox=[0.07 0.05];
locationTextBoxX=[0.03 0.45 0.85];
locationTextBoxY=[0.08 0.49 0.92];


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

b=axes('position',[ varargin{4}(1)+0.27 varargin{4}(2)    0.08    0.32]);
hold on

PermValue=mean(varargin{1}(:,3));
PermValueSE=sqrt(PermValue*(1-PermValue)/(numSamples-1));
b1=bar(1,PermValue,0.2,'w','EdgeColor','k','LineWidth',2);
plot([0.7 1.3],[1-0.975^2 1-0.975^2],'k--','LineWidth',2);
errorbar(1,PermValue,PermValueSE,'k','LineWidth',1.5);
BarWidth=get(b1,'BarWidth');
error_bar_caps(1,PermValue,PermValueSE,BarWidth*1.5,1.5);

set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'fontsize',12);
axis([0.7 1.3 0 0.18]);
pValue=binocdf(round(PermValue*numSamples)-1,numSamples,0.05,'upper');

mTextBox = text(0.25,0.95,[num2str(round(PermValue*1000)/10),'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');
