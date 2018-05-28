%generate fig 2
close all
clear all
%add all subfolders to path
addpath(genpath(pwd));
load('seedMem_for_figs_1_and_2.mat');
[~, regTrial,~,AllQs]=Qlearning_action_value_and_RW(seedMem);
session=343;
estQ=AllQs{session,1};
RChoose=AllQs{session,2};
trialsPerBlock=AllQs{session,3};
choice=AllQs{session,4};
R=AllQs{session,5};
Q=AllQs{session,6};
PrForFig1A=AllQs{session,11};
whichstats={'tstat','fstat'};
spikeCounts=AllQs{session,9};
firingRates=AllQs{session,10};
figure('units','centimeters','position',[3 -3 20 18]);
figPosition=[0.1    0.62    0.43    0.14 ; 0.1    0.44   0.43    0.14 ];  
ex1=17;
ex2=7;
RChoose=AllQs{session,2};
locationTextBoxX=0.05;
locationTextBoxY=[0.9 0.8];
a=axes('position',figPosition(1,:));
i=ex1;
hold on
  
        set(gca,'fontsize',12);
        limitsPlot=([0 trialsPerBlock(4) min(spikeCounts(:,i))-0.2 max(spikeCounts(:,i))+0.2]);
        xlim(limitsPlot(1:2));
        ylim(limitsPlot(3:4));
        plot( [0 0],limitsPlot(3:4),'k--',[trialsPerBlock(1) trialsPerBlock(1)],limitsPlot(3:4),'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],limitsPlot(3:4),'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],limitsPlot(3:4),'k--',...
    'LineWidth',1);
        p1=plot(1: trialsPerBlock(4),estQ(:,1)*(limitsPlot(4)-limitsPlot(3))+limitsPlot(3),'Color',[0.9 0.4 0.4],'LineWidth',2);
        p2=plot(1: trialsPerBlock(4),firingRates(:,i),'color',[0.4 0.4 0.4],'LineWidth',2.5);...
        p3=plot(1:trialsPerBlock(4),spikeCounts(:,i),'o','color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2);
        
    bars=[];
        barsSE=[];
         for blocks=1:4
             bars=[bars mean(spikeCounts(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),i))];
             barsSE=[barsSE std(spikeCounts(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),i))/sqrt(19)];   
        end 
        p6=plot([trialsPerBlock(1)-19 trialsPerBlock(1)],[bars(1) bars(1)],... 
                [trialsPerBlock(2)-19 trialsPerBlock(2)], [bars(2) bars(2)],... 
                [trialsPerBlock(3)-19 trialsPerBlock(3)],[bars(3) bars(3)],...
                [trialsPerBlock(4)-19 trialsPerBlock(4)],[bars(4) bars(4)] , 'Color','k','LineWidth',1.5);
       
        p7=errorbar(trialsPerBlock-10,bars,barsSE,'Color','k','LineWidth',2,'LineStyle','none');
        [AX,H1,H2]=plotyy(1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)),1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)));
        set(AX,{'ycolor'},{[0.149 0.149 0.149];[0.149 0.149 0.149]});
        set(AX(1),{'ylim'},{limitsPlot(3:4)});
        set(AX(1),{'yTick'},{[limitsPlot(3) mean(limitsPlot(3:4)) limitsPlot(4)]});
        set(AX(1),'yTickLabel',{[0 0.5 1]});
        ylabel(AX(1),'value','fontsize',12);
        
        set(AX(1),{'xlim'},{limitsPlot(1:2)});
        set(AX(1),{'xTick'},{[]});
        
        set(AX(2),{'ylim'},{limitsPlot(3:4)});
        set(AX(2),{'yTick'},{[0 4 8 ]});
        ylabel(AX(2),'spike count','fontsize',12);
        
        set(AX(2),{'FontSize'},{12});
        set(AX(1),{'FontSize'},{12});
        box(AX(1),'off');
        set(H1,'color','none');
        set(H2,'color','none');
        set(gca,'fontsize',12);
        set(gca,'fontsize',12);
       rStats=regstats(spikeCounts(:,i), estQ,'linear',whichstats);
       t1RW=rStats.tstat;
        pValueQ1=ranksum(spikeCounts(trialsPerBlock(1)-19:trialsPerBlock(1),i),spikeCounts(trialsPerBlock(2)-19:trialsPerBlock(2),i));
 pValueQ2=ranksum(spikeCounts(trialsPerBlock(3)-19:trialsPerBlock(3),i),spikeCounts(trialsPerBlock(4)-19:trialsPerBlock(4),i));
   
 mTextBox = text(1.2,0.1,['P Q_1',num2str(pValueQ1)],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
       
        mTextBox = text(1.2,0.5,['P Q_2',num2str(pValueQ2)],'interpreter','tex',...
        'Units','Normalized','FontSize',12);

locLinesX=((trialsPerBlock)-10)/trialsPerBlock(4)*figPosition(1,3)+figPosition(1,1);
locLinesY=[figPosition(1,4)*3/4+figPosition(1,2)+0.01 figPosition(1,4)*3/4+figPosition(1,2)-0.01 ];
locText=[mean(trialsPerBlock(1:2)-10)/trialsPerBlock(4)-0.03 0.88 ;...
   mean(trialsPerBlock(3:4)-10)/trialsPerBlock(4)-0.03 0.93];

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


% Create lines
annotation('line',[locLinesX(1:2)],...
    [locLinesY(1) locLinesY(1)],'LineWidth',1.2);
annotation('line',[locLinesX(1) locLinesX(1)],...
    [locLinesY(1:2)],'LineWidth',1.2);

annotation('line',[locLinesX(2) locLinesX(2)],...
    [locLinesY(1:2)],'LineWidth',1.2);
annotation('line',[locLinesX(3:4)],...
    [locLinesY(1) locLinesY(1)],'LineWidth',1.2);
annotation('line',[locLinesX(3) locLinesX(3)],...
    [locLinesY(1:2)],'LineWidth',1.2);
annotation('line',[locLinesX(4) locLinesX(4)],...
    [locLinesY(1:2)],'LineWidth',1.2);


locationTextBoxX=[trialsPerBlock(1)/2 , trialsPerBlock(1)+(trialsPerBlock(2)-trialsPerBlock(1))/2 ,...
     trialsPerBlock(2)+(trialsPerBlock(3)-trialsPerBlock(2))/2 ,...
      trialsPerBlock(3)+(trialsPerBlock(4)-trialsPerBlock(3))/2]/trialsPerBlock(4)-0.09;
locationTextBoxY=1.15; 
  mTextBox = text(locationTextBoxX(1) ,locationTextBoxY,['(',num2str(RChoose(1,1)),',',num2str(RChoose(2,1)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
       
        mTextBox = text(locationTextBoxX(2)  ,locationTextBoxY,['(',num2str(RChoose(1,2)),',',num2str(RChoose(2,2)),')'],'interpreter','tex',...
        'Units','Normalized','FontSize',12);
    
     mTextBox = text(locationTextBoxX(3) ,locationTextBoxY,['(',num2str(RChoose(1,3)),',',num2str(RChoose(2,3)),')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
       
     mTextBox = text(locationTextBoxX(4) ,locationTextBoxY,['(',num2str(RChoose(1,4)),',',num2str(RChoose(2,4)),')'],'interpreter','tex',...
        'Units','Normalized','FontSize',12);
 mTextBox = text(-0.2233,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');   
 i=ex2;   
a=axes('position',figPosition(2,:));
hold on

        set(gca,'fontsize',12);
        limitsPlot=([0 trialsPerBlock(4) min(spikeCounts(:,i))-0.2 max(spikeCounts(:,i))+0.2]);
        xlim(limitsPlot(1:2));
        ylim(limitsPlot(3:4));
        plot( [0 0],limitsPlot(3:4),'k--',[trialsPerBlock(1) trialsPerBlock(1)],limitsPlot(3:4),'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],limitsPlot(3:4),'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],limitsPlot(3:4),'k--',...
      'LineWidth',1);
       p1=plot(1: trialsPerBlock(4),estQ(:,2)*(limitsPlot(4)-limitsPlot(3))+limitsPlot(3),'Color',[0.3 0.3 0.8],'LineWidth',2);
        p2=plot(1: trialsPerBlock(4),firingRates(:,i),'color',[0.4 0.4 0.4],'LineWidth',2.5);
        p3=plot(1:trialsPerBlock(4),spikeCounts(:,i),'o','color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2);
         [AX,H1,H2]=plotyy(1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)),1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)));
        set(AX,{'ycolor'},{[0.149 0.149 0.149];[0.149 0.149 0.149]});
        set(AX(1),{'ylim'},{limitsPlot(3:4)});
        set(AX(1),{'yTick'},{[limitsPlot(3) mean(limitsPlot(3:4)) limitsPlot(4)]});
        set(AX(1),'yTickLabel',{[0 0.5 1]});
        ylabel(AX(1),'value','fontsize',12);
        
        set(AX(1),{'xlim'},{limitsPlot(1:2)});
        
        set(AX(2),{'ylim'},{limitsPlot(3:4)});
        set(AX(2),{'yTick'},{[0 4 8 ]});
        ylabel(AX(2),'spike count','fontsize',12);
        
        set(AX(2),{'FontSize'},{12});
        set(AX(1),{'FontSize'},{12});
        box(AX(1),'off');
        set(H1,'color','none');
        set(H2,'color','none');
        xlabel('trials','FontSize',12);
        set(gca,'fontsize',12);

        
       rStats=regstats(spikeCounts(:,i), estQ,'linear',whichstats);
       t2RW=rStats.tstat;

   bars=[];
   barsSE=[];
for blocks=1:4
    bars=[bars mean(spikeCounts(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),i))];
    barsSE=[barsSE std(spikeCounts(trialsPerBlock(blocks)-19:trialsPerBlock(blocks),i))/sqrt(19)];   
end 

p6=plot([trialsPerBlock(1)-19 trialsPerBlock(1)],[bars(1) bars(1)],... 
                [trialsPerBlock(2)-19 trialsPerBlock(2)], [bars(2) bars(2)],... 
                [trialsPerBlock(3)-19 trialsPerBlock(3)],[bars(3) bars(3)],...
                [trialsPerBlock(4)-19 trialsPerBlock(4)],[bars(4) bars(4)] , 'Color','k','LineWidth',1.5);
       
        p7=errorbar(trialsPerBlock-10,bars,barsSE,'Color','k','LineWidth',2,'LineStyle','none');
    
 pValueQ1=ranksum(spikeCounts(trialsPerBlock(1)-19:trialsPerBlock(1),i),spikeCounts(trialsPerBlock(2)-19:trialsPerBlock(2),i));
 pValueQ2=ranksum(spikeCounts(trialsPerBlock(3)-19:trialsPerBlock(3),i),spikeCounts(trialsPerBlock(4)-19:trialsPerBlock(4),i));
    
 mTextBox = text(1.2,0.1,['P Q_1',num2str(pValueQ1)],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
       
        mTextBox = text(1.2,0.5,['P Q_2',num2str(pValueQ2)],'interpreter','tex',...
        'Units','Normalized','FontSize',12);

locLinesX=((trialsPerBlock)-10)/trialsPerBlock(4)*figPosition(2,3)+figPosition(2,1);
locLinesY=[figPosition(2,4)*3/4+figPosition(2,2)+0.01 figPosition(2,4)*3/4+figPosition(2,2)-0.03 ];
locText=[mean(trialsPerBlock(1:2)-10)/trialsPerBlock(4)-0.03 0.94 ;...
   mean(trialsPerBlock(3:4)-10)/trialsPerBlock(4)-0.03 0.89];

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


% Create lines
annotation('line',locLinesX(1:2),...
   [locLinesY(1) locLinesY(1)],'LineWidth',1.2);
annotation('line',[locLinesX(1) locLinesX(1)],...
    [locLinesY(1:2)],'LineWidth',1.2);

annotation('line',[locLinesX(2) locLinesX(2)],...
    [locLinesY(1:2)],'LineWidth',1.2);
annotation('line',[locLinesX(3:4)],...
    [locLinesY(1) locLinesY(1)],'LineWidth',1.2);
annotation('line',[locLinesX(3) locLinesX(3)],...
    [locLinesY(1:2)],'LineWidth',1.2);
annotation('line',[locLinesX(4) locLinesX(4)],...
    [locLinesY(1:2)],'LineWidth',1.2);

%%
%random walk scatter plot
 figure('units','centimeters','position',[3 1 20 18/24*20]);

i=7;
numEx1=find(t1RW.t(2)==regTrial.random_walk(:,1));
numEx2=find(t2RW.t(2)==regTrial.random_walk(:,1));
samVec=[round(linspace(i,length(regTrial.random_walk)-(length(regTrial.random_walk)/1000)+i,498)) numEx1 numEx2 ];
numtvaluesForPlot=[499 500 ];

Draw_scatter_plot(regTrial.random_walk(samVec,:),2,2.5,[ 0.1    0.550    0.24    0.32],0,numtvaluesForPlot);
mTextBox = text(-0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%RW neurons bar plot

Draw_four_bar_plots(regTrial.random_walk,2,1000,[ 0.37    0.550     0.16    0.32]);
mTextBox = text(-0.2233,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%%
%plot vectors with eta, value neurons and autocorrelation
%plot eta vs value neurons
%calculate std
load('regTrialDiffSigmas_120418.mat')
a3=axes('position',[ 0.1    0.2300    0.43    0.20]);
VecSigma=[0 0.02 0.04 0.06 0.08 0.09 0.1 0.11 0.12 0.14 0.16 0.18 0.2];

arraySize=19900;
numSamples=1000;
VecSigmaStd=[];
VecSigmaMean=[];
for sigmaPlace=1:size(regTrialDiffSigmas,3)
    sampleMeans=[];
    regTrialSamplesAbs=abs([regTrialDiffSigmas{1,2,sigmaPlace} regTrialDiffSigmas{2,2,sigmaPlace}] )>2;
    sampleMeans=[sampleMeans ; mean((regTrialSamplesAbs(:,1)+regTrialSamplesAbs(:,2))==1)...
        mean((regTrialSamplesAbs(:,1)+regTrialSamplesAbs(:,2))==2) mean((regTrialSamplesAbs(:,1)+regTrialSamplesAbs(:,2))==0)];
    
    
    VecSigmaMean=[VecSigmaMean ; sampleMeans];
    VecSigmaStd=[VecSigmaStd ; sqrt((sampleMeans).*(1-sampleMeans)/999)];
end


hold on
plot([0 0.1],[VecSigmaMean(VecSigma==0.1,1) VecSigmaMean(VecSigma==0.1,1)],'--k',...
    [0 0.1],[VecSigmaMean(VecSigma==0.1,2) VecSigmaMean(VecSigma==0.1,2)],'--k',...
    [0.1 0.1],[0 VecSigmaMean(VecSigma==0.1,1)],'--k','LineWidth',1);

patch([VecSigma fliplr(VecSigma)],[VecSigmaMean(:,2)+VecSigmaStd(:,2) ; flipud([VecSigmaMean(:,2)-VecSigmaStd(:,2)])],[0.737 0.859 0.796],'EdgeColor','none')
p2=plot(VecSigma,VecSigmaMean(:,2),'Color',[0 0.398 0],'LineWidth',1);
patch([VecSigma fliplr(VecSigma)],[VecSigmaMean(:,1)+VecSigmaStd(:,1) ; flipud([VecSigmaMean(:,1)-VecSigmaStd(:,1)])],[1 0.6 0.6],'EdgeColor','none')
p1=plot(VecSigma,VecSigmaMean(:,1),'Color',[0.4 0 0],'LineWidth',1);

l=legend([p1 p2],'( \itQ_1 , Q_2 )','(\it \SigmaQ , \DeltaQ )');
set(l,'fontsize',12,'EdgeColor','none','color','none','Position',[0.25 0.3779 0.1246 0.0632],'orientation','horizontal');
set(gca,'FontSize',12);
xlabel('\sigma','fontsize',18);
ylabel('fraction','fontsize',12);

ylim([0 0.67]);
mTextBox = text(-0.2233,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');