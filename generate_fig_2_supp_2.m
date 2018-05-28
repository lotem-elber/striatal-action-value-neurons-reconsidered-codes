%create Fig. 2 - Fig. supplement 2, analyses on recorded data
%create figures - motor cortex Data
close all
clear all
%add all subfolders to path
addpath(genpath(pwd));

load('seedMem_for_figs_1_and_2.mat');
[~,~, ~,AllQs]=Qlearning_action_value_and_RW(seedMem);
load('motor_cortex_spike_data.mat');
figure('units','centimeters','position',[3 0 20 18/24*20]);
figPosition=[0.1    0.55    0.430   0.14*24/20; ...
    0.1    0.15    0.43    0.14*24/20 ];

experiment=9;
column=78;
Q=AllQs{column+experiment*20,1};
RChoose=AllQs{column+experiment*20,2};
trialsPerBlock=AllQs{column+experiment*20,3};
choice=AllQs{column+experiment*20,4};
R=AllQs{column+experiment*20,5};

a=axes('position',figPosition(1,:));

mTextBox = text(-0.2233,1.2,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
hold on
OriginalOrder=[0.1 0.9 0.5 0.5 ; 0.5 0.5 0.9 0.1 ; ];
newOrder=[find(0.1==RChoose(1,:)) find(0.9==RChoose(1,:)) find(0.9==RChoose(2,:)) find(0.1==RChoose(2,:))];
bars=[];
barsSE=[];
for blocks=1:4
    bars=[bars mean(motor_cortex_spike_data(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),column))];
    barsSE=[barsSE std(motor_cortex_spike_data(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),column))/sqrt(19)];
end
pValueQ1=ranksum(motor_cortex_spike_data(trialsPerBlock(newOrder(1))-19:trialsPerBlock(newOrder(1)),column),motor_cortex_spike_data(trialsPerBlock(newOrder(2))-19:trialsPerBlock(newOrder(2)),column));
pValueQ2=ranksum(motor_cortex_spike_data(trialsPerBlock(newOrder(3))-19:trialsPerBlock(newOrder(3)),column),motor_cortex_spike_data(trialsPerBlock(newOrder(4))-19:trialsPerBlock(newOrder(4)),column));

locLinesX=(trialsPerBlock-10)/trialsPerBlock(4)*figPosition(2,3)+figPosition(2,1);
locText=[mean(trialsPerBlock([newOrder(1) newOrder(2)])-10)/trialsPerBlock(4)-0.03 0.86 ;...
    mean(trialsPerBlock([newOrder(3) newOrder(4)])-10)/trialsPerBlock(4)-0.03 0.85];

locLinesY=[figPosition(1,4)*3/4+figPosition(1,2)+0.012 , figPosition(1,4)*3/4+figPosition(1,2)-0.02 ,...
    figPosition(1,4)*3/4+figPosition(1,2)+0.0 , figPosition(1,4)*3/4+figPosition(1,2)-0.03];



if pValueQ1>0.05
    text1='n.s.';
elseif pValueQ1>0.01
    text1='*';
else
    text1='**';
end
if pValueQ2>0.05
    text2='n.s.';
elseif pValueQ2>0.01
    text2='*';
else
    text2='**';
end
mTextBox = text(locText(1,1),locText(1,2),text1,'interpreter','tex',...
    'Units','Normalized','FontSize',18);
mTextBox = text(locText(2,1),locText(2,2),text2,'interpreter','tex',...
    'Units','Normalized','FontSize',14);
mTextBox = text(1.2,0.1,['P Q_1',num2str(pValueQ1)],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
mTextBox = text(1.2,0.5,['P Q_2',num2str(pValueQ2)],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

% Create lines
annotation('line',[locLinesX([newOrder(1) newOrder(2)])],...
    [locLinesY(1) locLinesY(1)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(1)) locLinesX(newOrder(1))],...
    [locLinesY(1:2)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(2)) locLinesX(newOrder(2))],...
    [locLinesY(1:2)],'LineWidth',1.2);

annotation('line',[locLinesX([newOrder(3) newOrder(4)])],...
    [locLinesY(3) locLinesY(3)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(3)) locLinesX(newOrder(3))],...
    [locLinesY(3:4)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(4)) locLinesX(newOrder(4))],...
    [locLinesY(3:4)],'LineWidth',1.2);


hold on


set(gca,'fontsize',12);
limitsPlot=[0 trialsPerBlock(4)...
    min(motor_cortex_spike_data(1:trialsPerBlock(4),column))-0.2 max(motor_cortex_spike_data(1:trialsPerBlock(4),column))+0.2];
xlim(limitsPlot(1:2));
ylim(limitsPlot(3:4));

plot( [limitsPlot(1) limitsPlot(1)],[limitsPlot(3:4)],'k--',[trialsPerBlock(1) trialsPerBlock(1)],[limitsPlot(3:4)],'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],[limitsPlot(3:4)],'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],[limitsPlot(3:4)],'k--',...
    [trialsPerBlock(4) trialsPerBlock(4)],[limitsPlot(3:4)],'k--','LineWidth',1);
p4=plot(1:trialsPerBlock(4),Q(:,1)*(limitsPlot(4)-limitsPlot(3))+limitsPlot(3),'Color',[0.9 0.4 0.4 ],'LineWidth',2);

p3=plot(1:trialsPerBlock(4),motor_cortex_spike_data(1:trialsPerBlock(4),column),'o','color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2);...
    p6=plot([trialsPerBlock(1)-19 trialsPerBlock(1)],[bars(1) bars(1)],...
    [trialsPerBlock(2)-19 trialsPerBlock(2)], [bars(2) bars(2)],...
    [trialsPerBlock(3)-19 trialsPerBlock(3)],[bars(3) bars(3)],...
    [trialsPerBlock(4)-19 trialsPerBlock(4)],[bars(4) bars(4)],...
    'Color','k','LineWidth',1.5);
p7=errorbar(trialsPerBlock-10,bars,barsSE,'Color','k','LineWidth',1.5,'LineStyle','none');

[AX,H1,H2]=plotyy(1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)),1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)));
set(AX,{'ycolor'},{[0.149 0.149 0.149];[0.149 0.149 0.149]});
set(AX(1),{'ylim'},{limitsPlot(3:4)});
set(AX(1),{'yTick'},{[min(motor_cortex_spike_data(1:trialsPerBlock(4),column)), ...
    max(motor_cortex_spike_data(1:trialsPerBlock(4),column))/2 max(motor_cortex_spike_data(1:trialsPerBlock(4),column))]});
set(AX(1),'yTickLabel',{[0 0.5 1]});
ylabel(AX(1),'value','fontsize',12);
xlabel(AX(1),'trials','fontsize',12);
set(AX(1),{'xlim'},{[0 trialsPerBlock(4)]});
set(AX(1),{'xTick'},{[50 100 150 200]});

set(AX(2),{'ylim'},{limitsPlot(3:4)});
set(AX(2),{'yTick'},{[ 10 20 30 50]});
ylabel(AX(2),'spike count','fontsize',12);

set(AX(2),{'FontSize'},{12});
set(AX(1),{'FontSize'},{12});
box(AX(1),'off');
set(H1,'color','none');
set(H2,'color','none');
set(gca,'fontsize',12);

locationTextBoxX=[trialsPerBlock(1)/2 , trialsPerBlock(1)+(trialsPerBlock(2)-trialsPerBlock(1))/2,...
    trialsPerBlock(2)+(trialsPerBlock(3)-trialsPerBlock(2))/2 ,...
    trialsPerBlock(3)+(trialsPerBlock(4)-trialsPerBlock(3))/2]/trialsPerBlock(4)-0.1;
locationTextBoxY=1.15;
mTextBox = text(locationTextBoxX(1) ,locationTextBoxY,['(',num2str(RChoose(1,1)),',',num2str(RChoose(2,1)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

mTextBox = text(locationTextBoxX(2)  ,locationTextBoxY,['(',num2str(RChoose(1,2)),',',num2str(RChoose(2,2)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

mTextBox = text(locationTextBoxX(3) ,locationTextBoxY,['(',num2str(RChoose(1,3)),',',num2str(RChoose(2,3)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

mTextBox = text(locationTextBoxX(4) ,locationTextBoxY,['(',num2str(RChoose(1,4)),',',num2str(RChoose(2,4)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

t=title('motor cortex','FontSize',14);
 t.Units='normalized';
 t.Position=[0.5 1.25 0.1];

 %%
 %population analysis motor cortex
[tvaluesTot, tvaluesTotQlearning,  tvaluesTotQlearningDetrending]=regression_analyses_motor_auditory_cortex(motor_cortex_spike_data,AllQs,20);
%motor cortex_data_create scatter plot

i=9;
tvaluesQlearningClean=tvaluesTotQlearning(((i-1)*89+1):i*89,:);
tvaluesForFig1A=tvaluesQlearningClean([78 63],1:2);
tvaluesQlearningClean(isnan(tvaluesQlearningClean(:,1)),:)=[];
regForPlot=tvaluesQlearningClean(:,1:2);

numtvaluesForPlot=[78];
mSize=3.5;
Draw_scatter_plot(regForPlot,2,3.5,[ 0.1    0.100    0.24    0.32],0,numtvaluesForPlot);
mTextBox = text(-0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%motor cortex neurons bar plot
regForPlot=tvaluesTotQlearning;
Draw_four_bar_plots(regForPlot,2,89,[ 0.37    0.100     0.16    0.32]);

%%
%create figures - auditory cortex Data
load('auditory_cortex_spike_data.mat');
AllQs_auditory=AllQs;
%data from auditory cortex has only 370 trials, delete all estimated Qs
%that are longer (in this case there is only one such estimated Q)
for i=size(AllQs_auditory,1):-1:1
    if length(AllQs_auditory{i,1})>370
        AllQs_auditory(i,:)=[];
    end
end
figure('units','centimeters','position',[3 0 20 18/24*20]);
figPosition=[0.1    0.41    0.43   0.14*24/20 ; ...
    0.1    0.55    0.43    0.14*24/20 ];

experiment=26;
column=96;
Q=AllQs_auditory{column+experiment*20,1};
RChoose=AllQs_auditory{column+experiment*20,2};
trialsPerBlock=AllQs_auditory{column+experiment*20,3};



%bar plot
a=axes('Position',figPosition(2,:));
mTextBox = text(-0.2233,1.2,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
hold on
OriginalOrder=[0.1 0.9 0.5 0.5 ; 0.5 0.5 0.9 0.1 ; ];
newOrder=[find(0.1==RChoose(1,:)) find(0.9==RChoose(1,:)) find(0.9==RChoose(2,:)) find(0.1==RChoose(2,:))];
bars=[];
barsSE=[];
for blocks=1:4
    bars=[bars mean(spikeDataRes(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),column))];
    barsSE=[barsSE std(spikeDataRes(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),column))/sqrt(19)];
end
pValueQ1=ranksum(spikeDataRes(trialsPerBlock(newOrder(1))-19:trialsPerBlock(newOrder(1)),column),spikeDataRes(trialsPerBlock(newOrder(2))-19:trialsPerBlock(newOrder(2)),column));
pValueQ2=ranksum(spikeDataRes(trialsPerBlock(newOrder(3))-19:trialsPerBlock(newOrder(3)),column),spikeDataRes(trialsPerBlock(newOrder(4))-19:trialsPerBlock(newOrder(4)),column));

locLinesX=(trialsPerBlock-10)/trialsPerBlock(4)*figPosition(1,3)+figPosition(1,1);
locText=[mean(trialsPerBlock([newOrder(1) newOrder(2)])-10)/trialsPerBlock(4)-0.05 0.88 ;...
    mean(trialsPerBlock([newOrder(3) newOrder(4)])-10)/trialsPerBlock(4)-0.02 0.88];

locLinesY=[figPosition(2,4)*3/4+figPosition(2,2)+0.00, figPosition(2,4)*3/4+figPosition(2,2)-0.015 ,...
    figPosition(2,4)*3/4+figPosition(2,2)+0.015 , figPosition(2,4)*3/4+figPosition(2,2)+0.005];


if pValueQ1>0.05
    text1='n.s.';
elseif pValueQ1>0.01
    text1='*';
else
    text1='**';
end
if pValueQ2>0.05
    text2='n.s.';
elseif pValueQ2>0.01
    text2='*';
else
    text2='**';
end
mTextBox = text(locText(1,1),locText(1,2),text1,'interpreter','tex',...
    'Units','Normalized','FontSize',14);
mTextBox = text(locText(2,1),locText(2,2),text2,'interpreter','tex',...
    'Units','Normalized','FontSize',18);
mTextBox = text(1.2,0.1,['P Q_1',num2str(pValueQ1)],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
mTextBox = text(1.2,0.5,['P Q_2',num2str(pValueQ2)],'interpreter','tex',...
    'Units','Normalized','FontSize',12);


% Create lines
annotation('line',[locLinesX([newOrder(1) newOrder(2)])],...
    [locLinesY(1) locLinesY(1)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(1)) locLinesX(newOrder(1))],...
    [locLinesY(1:2)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(2)) locLinesX(newOrder(2))],...
    [locLinesY(1:2)],'LineWidth',1.2);

annotation('line',[locLinesX([newOrder(3) newOrder(4)])],...
    [locLinesY(3) locLinesY(3)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(3)) locLinesX(newOrder(3))],...
    [locLinesY(3:4)],'LineWidth',1.2);
annotation('line',[locLinesX(newOrder(4)) locLinesX(newOrder(4))],...
    [locLinesY(3:4)],'LineWidth',1.2);


locationTextBoxX=[trialsPerBlock(1)/2 , trialsPerBlock(1)+(trialsPerBlock(2)-trialsPerBlock(1))/2 ,...
    trialsPerBlock(2)+(trialsPerBlock(3)-trialsPerBlock(2))/2 ,...
    trialsPerBlock(3)+(trialsPerBlock(4)-trialsPerBlock(3))/2]/trialsPerBlock(4)-0.08;
locationTextBoxY=1.15;

hold on

set(gca,'fontsize',12)
box off
limitsPlot=[0 trialsPerBlock(4)...
    min(spikeDataRes(1:trialsPerBlock(4),column))-0.2 max(spikeDataRes(1:trialsPerBlock(4),column))+0.2];
xlim(limitsPlot(1:2));
ylim(limitsPlot(3:4));

plot( [limitsPlot(1) limitsPlot(1)],[limitsPlot(3:4)],'k--',[trialsPerBlock(1) trialsPerBlock(1)],[limitsPlot(3:4)],'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],[limitsPlot(3:4)],'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],[limitsPlot(3:4)],'k--',...
    [trialsPerBlock(4) trialsPerBlock(4)],[limitsPlot(3:4)],'k--','LineWidth',1);
p5=plot(1:trialsPerBlock(4),Q(:,2)*(limitsPlot(4)-limitsPlot(3))+limitsPlot(3),'Color',[0.3 0.3 0.8],'LineWidth',2);

p3=plot(1:trialsPerBlock(4),spikeDataRes(1:trialsPerBlock(4),column),'o','Color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2);

p6=plot([trialsPerBlock(1)-19 trialsPerBlock(1)],[bars(1) bars(1)],...
    [trialsPerBlock(2)-19 trialsPerBlock(2)], [bars(2) bars(2)],...
    [trialsPerBlock(3)-19 trialsPerBlock(3)],[bars(3) bars(3)],...
    [trialsPerBlock(4)-19 trialsPerBlock(4)],[bars(4) bars(4)],...
    'Color','k','LineWidth',1.5);
p7=errorbar(trialsPerBlock-10,bars,barsSE,'Color','k','LineWidth',1.5,'LineStyle','none');
[AX,H1,H2]=plotyy(1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)),1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)));
set(AX,{'ycolor'},{[0.149 0.149 0.149];[0.149 0.149 0.149]});
set(AX(1),{'ylim'},{limitsPlot(3:4)});
set(AX(1),{'yTick'},{[limitsPlot(3) mean(limitsPlot(3:4)) limitsPlot(4)]});
set(AX(1),'yTickLabel',{[0 0.5 1]});
ylabel(AX(1),'value','fontsize',12);
xlabel('trials');
set(AX(1),{'xlim'},{[limitsPlot(1:2)]});
set(AX(1),{'xTick'},{[50 100 150 200]});
set(AX(2),{'ylim'},{limitsPlot(3:4)});
set(AX(2),{'yTick'},{[0  10 20 30]});
ylabel(AX(2),'spike count','fontsize',12);
set(AX(2),{'FontSize'},{12});
set(AX(1),{'FontSize'},{12});
box(AX(1),'off');
box(AX(2),'off');

set(AX(1),'box','off');
set(H1,'color','none');
set(H2,'color','none');
set(gca,'fontsize',12);


mTextBox = text(locationTextBoxX(1) ,locationTextBoxY,['(',num2str(RChoose(1,1)),',',num2str(RChoose(2,1)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

mTextBox = text(locationTextBoxX(2)  ,locationTextBoxY,['(',num2str(RChoose(1,2)),',',num2str(RChoose(2,2)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

mTextBox = text(locationTextBoxX(3) ,locationTextBoxY,['(',num2str(RChoose(1,3)),',',num2str(RChoose(2,3)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

mTextBox = text(locationTextBoxX(4) ,locationTextBoxY,['(',num2str(RChoose(1,4)),',',num2str(RChoose(2,4)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);

t=title('auditory cortex','FontSize',14);
 t.Units='normalized';
 t.Position=[0.5 1.25 0.1];
%%
%population analysis auditory cortex
[tvaluesTot, tvaluesTotQlearning,  tvaluesTotQlearningDetrending]=regression_analyses_motor_auditory_cortex(spikeDataRes,AllQs_auditory,20);


i=26;
tvaluesQlearningClean=tvaluesTotQlearning((i-1)*125+1:i*125,1:2);
tvaluesExamples=tvaluesQlearningClean([96],1);

tvaluesQlearningClean(isnan(tvaluesQlearningClean(:,1)),:)=[];
regForPlot=tvaluesQlearningClean;
if length(tvaluesExamples)==2
    numtvaluesForPlot=[find(regForPlot(:,1)==tvaluesExamples(1)) find(regForPlot(:,1)==tvaluesExamples(2))];
else
    numtvaluesForPlot=[find(regForPlot(:,1)==tvaluesExamples(1)) ];
end
Draw_scatter_plot(regForPlot,2,3.5,[ 0.1    0.100     0.24    0.32],0,numtvaluesForPlot);
mTextBox = text(-0.4,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%auditory cortex neurons bar plot
tvaluesQlearningClean=tvaluesTotQlearning;
tvaluesQlearningClean(isnan(tvaluesQlearningClean(:,1)),:)=[];
regForPlot=tvaluesQlearningClean;

Draw_four_bar_plots(regForPlot,2,round(length(regForPlot)/40),[ 0.37    0.100     0.16    0.32]);
set(gca,'FontSize',12);


