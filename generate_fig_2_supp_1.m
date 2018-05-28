close all
clear all
%add all subfolders to path
addpath(genpath(pwd));
%call function that runs covariance based plasticity model
[regTrial,AllQs_example]=covariance_based_plasticity_annotated();
% create behavior plot
f=figure('units','centimeters','Position',[1 -2 20 18]);
estQ=AllQs_example{1,1};
RChoose=AllQs_example{1,2};
trialsPerBlock=AllQs_example{1,3};
choice=AllQs_example{1,4};
R=AllQs_example{1,5};
spikeCounts=AllQs_example{1,6};
firingRate=AllQs_example{1,7};
probChoose1=AllQs_example{1,8};

a=axes('Position',[0.1,0.82,0.43,0.12]);
mTextBox = text(-0.2233,1.3,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
hold on
plot( [0 0],[0 1],'k',[trialsPerBlock(1) trialsPerBlock(1)],[0 1],'k--',...
    [trialsPerBlock(2) trialsPerBlock(2)],[0 1],'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],[0 1],'k--',...
    'LineWidth',1);
action1Rewarded=find(R & choice);
action1NotRewarded=find(R==0 & choice);
action2Rewarded=find(R & choice==0);
action2NotRewarded=find(R==0 & choice==0);
y=find(1-R);
lengthLines=[0.12 0.06];
p2=plot(1:length(probChoose1),probChoose1,'k','LineWidth',2);
p3=plot([action1Rewarded ; action1Rewarded],[ones(1,length(action1Rewarded)) ; 1-lengthLines(1)*ones(1,length(action1Rewarded))],...
    'color',[0.9 0.4 0.4],'linewidth',1.5);
p3=plot([action1NotRewarded ; action1NotRewarded],[ones(1,length(action1NotRewarded)) ; 1-lengthLines(2)*ones(1,length(action1NotRewarded))],...
    'color',[0.9 0.4 0.4],'linewidth',1.5);
p3=plot([action2Rewarded ; action2Rewarded],[zeros(1,length(action2Rewarded)) ; lengthLines(1)*ones(1,length(action2Rewarded))],...
    'color',[0.3 0.3 0.8],'linewidth',1.5);
p3=plot([action2NotRewarded ; action2NotRewarded],[zeros(1,length(action2NotRewarded)) ; lengthLines(2)*ones(1,length(action2NotRewarded))],...
    'color',[0.3 0.3 0.8],'linewidth',1.5);


locationTextBoxX=[trialsPerBlock(1)/2 , trialsPerBlock(1)+(trialsPerBlock(2)-trialsPerBlock(1))/2 ,...
     trialsPerBlock(2)+(trialsPerBlock(3)-trialsPerBlock(2))/2 ,...
      trialsPerBlock(3)+(trialsPerBlock(4)-trialsPerBlock(3))/2]/trialsPerBlock(4)-0.09;
locationTextBoxY=1.15; 

 mTextBox = text(locationTextBoxX(1) ,locationTextBoxY,['(0.1,0.5)'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
       
        mTextBox = text(locationTextBoxX(2)  ,locationTextBoxY,['(0.9,0.5)'],'interpreter','tex',...
        'Units','Normalized','FontSize',12);
    
     mTextBox = text(locationTextBoxX(3) ,locationTextBoxY,['(0.5,0.9)'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
       
     mTextBox = text(locationTextBoxX(4) ,locationTextBoxY,['(0.5,0.1)'],'interpreter','tex',...
        'Units','Normalized','FontSize',12);  

axis([0 trialsPerBlock(4) 0 1]);
ylabel({'pr.(choice=1)'},'FontSize',12);
set(gca,'Box','Off');
set(gca,'XTick',[]);
set(gca,'fontsize',12);

%%
%plot examples of single neurons
whichstats={'tstat','fstat'};
figPosition=[0.1    0.63    0.43    0.12 ; 0.1    0.48   0.43    0.12 ];  
RChoose=RChoose;
locationTextBoxX=0.05;
locationTextBoxY=[0.9 0.8];

hold on
a=axes('Position',figPosition(1,:));
mTextBox = text(- 0.2233,1.2,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
i=1861;
hold on
  
        set(gca,'fontsize',12);
        limitsPlot=([0 trialsPerBlock(4) min(spikeCounts(:,i))-0.2 max(spikeCounts(:,i))+0.2]);
        xlim(limitsPlot(1:2));
        ylim(limitsPlot(3:4));
        plot( [trialsPerBlock(1) trialsPerBlock(1)],limitsPlot(3:4),'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],limitsPlot(3:4),'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],limitsPlot(3:4),'k--',...
    'LineWidth',1);
        p1=plot(1: trialsPerBlock(4),estQ(1,:)'*(limitsPlot(4)-limitsPlot(3))+limitsPlot(3),'Color',[0.9 0.4 0.4],'LineWidth',2);
        p2=plot(1: trialsPerBlock(4),firingRate(:,i),'color',[0.4 0.4 0.4],'LineWidth',2.5);
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
        set(gca,'position',figPosition(1,:));
        set(gca,'fontsize',12);
       rStats=regstats(spikeCounts(:,i), estQ','linear',whichstats);
       t1=rStats.tstat;
        pValueQ2=ranksum(spikeCounts(trialsPerBlock(1)-19:trialsPerBlock(1),i),spikeCounts(trialsPerBlock(2)-19:trialsPerBlock(2),i));
 pValueQ1=ranksum(spikeCounts(trialsPerBlock(3)-19:trialsPerBlock(3),i),spikeCounts(trialsPerBlock(4)-19:trialsPerBlock(4),i));
   
locLinesX=((trialsPerBlock)-10)/trialsPerBlock(4)*figPosition(1,3)+figPosition(1,1);
locLinesY=[figPosition(1,4)*3/4+figPosition(1,2)+0.01 figPosition(1,4)*3/4+figPosition(1,2)-0.01 ];
locText=[mean(trialsPerBlock(1:2)-10)/trialsPerBlock(4)-0.03 0.88 ;...
   mean(trialsPerBlock(3:4)-10)/trialsPerBlock(4)-0.03 0.96];

if pValueQ2>0.05
    text1='n.s.';
elseif pValueQ2>0.01
    text1='*';
else
    text1='**';
end
if pValueQ1>0.05
    text2='n.s.';
elseif pValueQ1>0.01
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

  
 i=138;   
a=axes('Position',figPosition(2,:));
set(gca,'position',figPosition(2,:));
hold on
        set(gca,'fontsize',12);
        limitsPlot=([0 trialsPerBlock(4) min(spikeCounts(:,i))-0.2 max(spikeCounts(:,i))+0.2]);
        xlim(limitsPlot(1:2));
        ylim(limitsPlot(3:4));
        plot( [trialsPerBlock(1) trialsPerBlock(1)],limitsPlot(3:4),'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],limitsPlot(3:4),'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],limitsPlot(3:4),'k--',...
      'LineWidth',1);
       p1=plot(1: trialsPerBlock(4),estQ(2,:)'*(limitsPlot(4)-limitsPlot(3))+limitsPlot(3),'Color',[0.3 0.3 0.8],'LineWidth',2);
        p2=plot(1: trialsPerBlock(4),firingRate(:,i),'color',[0.4 0.4 0.4],'LineWidth',2.5);
        p3=plot(1:trialsPerBlock(4),spikeCounts(:,i),'o','color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4],'MarkerSize',2);
         [AX,H1,H2]=plotyy(1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)),1: trialsPerBlock(4),linspace(0,1,trialsPerBlock(4)));
        set(AX,{'ycolor'},{[0.149 0.149 0.149];[0.149 0.149 0.149]});
        set(AX(1),{'ylim'},{limitsPlot(3:4)});
        set(AX(1),{'yTick'},{[limitsPlot(3) mean(limitsPlot(3:4)) limitsPlot(4)]});
        set(AX(1),'yTickLabel',{[0 0.5 1]});
        ylabel(AX(1),'value','fontsize',12); 
        set(AX(1),{'xlim'},{limitsPlot(1:2)});
        xlabel('trials','fontsize',12);
        set(AX(2),{'ylim'},{limitsPlot(3:4)});
        set(AX(2),{'yTick'},{[0 4 8 ]});
        ylabel(AX(2),'spike count','fontsize',12);
        set(AX(2),{'FontSize'},{12});
        set(AX(1),{'FontSize'},{12});
        box(AX(1),'off');
        set(H1,'color','none');
        set(H2,'color','none');
        set(gca,'fontsize',12);

        
       rStats=regstats(spikeCounts(:,i), estQ','linear',whichstats);
       t2=rStats.tstat;

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
    
 pValueQ2=ranksum(spikeCounts(trialsPerBlock(1)-19:trialsPerBlock(1),i),spikeCounts(trialsPerBlock(2)-19:trialsPerBlock(2),i));
 pValueQ1=ranksum(spikeCounts(trialsPerBlock(3)-19:trialsPerBlock(3),i),spikeCounts(trialsPerBlock(4)-19:trialsPerBlock(4),i));
 locLinesX=((trialsPerBlock)-10)/trialsPerBlock(4)*figPosition(2,3)+figPosition(2,1);
locLinesY=[figPosition(2,4)*3/4+figPosition(2,2)-0.01 figPosition(2,4)*3/4+figPosition(2,2)-0.025 ];
locText=[mean(trialsPerBlock(1:2)-10)/trialsPerBlock(4)-0.02 0.8 ;...
   mean(trialsPerBlock(3:4)-10)/trialsPerBlock(4)-0.03 0.75];

if pValueQ2>0.05
    text1='n.s.';
elseif pValueQ2>0.01
    text1='*';
else
    text1='**';
end
if pValueQ1>0.05
    text2='n.s.';
elseif pValueQ1>0.01
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
%population analysis
regForPlot=[regTrial{1,1} regTrial{2,1} ; regTrial{1,2} regTrial{2,2}];
i=1;
samVec=round(linspace(i,min(length(regForPlot),length(regForPlot))-2000+i,498));
regForPlot=[regForPlot(samVec,:) ; regForPlot([54133 554714],:)];
Draw_scatter_plot(regForPlot,2,2.5,[ 0.1    0.100    0.24    0.32/24*20],0,[500 499]);
mTextBox = text(- 0.4,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
regForPlot=[regTrial{1,1} regTrial{2,1} ; regTrial{1,2} regTrial{2,2}];
Draw_four_bar_plots(regForPlot,2,89,[ 0.37    0.100     0.16    0.32/24*20]);
mTextBox = text(- 0.12,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');



