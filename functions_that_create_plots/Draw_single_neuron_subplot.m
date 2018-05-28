function [] = Draw_single_neuron_subplot(QForTrialReg,ColorQForTrialReg,trialsPerBlock,modulation,Q,ColorQ,estQ,Locs_Fonts)
whichstats={'tstat','fstat'};

hold on
figPosition=Locs_Fonts{1};
locationTextBoxX=Locs_Fonts{2}(1);
locationTextBoxY=Locs_Fonts{2}(2:3);
locLinesX=Locs_Fonts{3};
locLinesY=Locs_Fonts{4};
locText=Locs_Fonts{5};
Fonts=Locs_Fonts{6};
        limitsPlot=[0 trialsPerBlock(4) min(QForTrialReg)-0.2 max(QForTrialReg)+0.2];
        set(gca,'fontsize',12);
        xlim(limitsPlot(1:2));
        ylim(limitsPlot(3:4));
        plot([trialsPerBlock(1) trialsPerBlock(1)],[limitsPlot(3:4)],'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],[limitsPlot(3:4)],'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],[limitsPlot(3:4)],'k--',...
    'LineWidth',1);
        p1=plot(1:trialsPerBlock(4),[Q*modulation+2.5-modulation/2],'color',ColorQForTrialReg,'LineWidth',2);
        p3=plot(1:trialsPerBlock(4),QForTrialReg,'o','MarkerFaceColor',ColorQForTrialReg,'color',ColorQForTrialReg,'MarkerSize',2);
        bars=[];
        barsSE=[];
         for blocks=1:4
             bars=[bars mean(QForTrialReg(trialsPerBlock(blocks)-19:trialsPerBlock(blocks)))];
             barsSE=[barsSE std(QForTrialReg(trialsPerBlock(blocks)-19:trialsPerBlock(blocks)))/sqrt(19)];   
        end 
        p6=plot([trialsPerBlock(1)-19 trialsPerBlock(1)],[bars(1) bars(1)],... 
                [trialsPerBlock(2)-19 trialsPerBlock(2)], [bars(2) bars(2)],... 
                [trialsPerBlock(3)-19 trialsPerBlock(3)],[bars(3) bars(3)],...
                [trialsPerBlock(4)-19 trialsPerBlock(4)],[bars(4) bars(4)] , 'Color','k','LineWidth',1.5);
       
       p7=errorbar(trialsPerBlock-10,bars,barsSE,'Color','k','LineWidth',2,'LineStyle','none');
        set(gca,'XTick',[]);

        set(gca,'YTick',[0  4 8 12]);
        ylabel('spike count','fontsize',12);
        set(gca,'fontsize',12);
       rStats=regstats(QForTrialReg, estQ,'linear',whichstats);
       t1=rStats.tstat;
         mTextBox = text(1.2,0.9,['t Q_1',num2str(t1.t(2))],'interpreter','tex',...
    'Units','Normalized','FontSize',12);     
        mTextBox = text(1.2,0.7,['t Q_2',num2str(t1.t(3))],'interpreter','tex',...
        'Units','Normalized','FontSize',12);
   
       pValueQ1=ranksum(QForTrialReg(trialsPerBlock(1)-19:trialsPerBlock(1)),QForTrialReg(trialsPerBlock(2)-19:trialsPerBlock(2)));
       pValueQ2=ranksum(QForTrialReg(trialsPerBlock(3)-19:trialsPerBlock(3)),QForTrialReg(trialsPerBlock(4)-19:trialsPerBlock(4)));
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

mTextBox = text(1.2,0.1,['P Q_1',num2str(pValueQ1)],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
       
        mTextBox = text(1.2,0.5,['P Q_2',num2str(pValueQ2)],'interpreter','tex',...
        'Units','Normalized','FontSize',12);


mTextBox = text(locText(1,1),locText(1,2),text1,'interpreter','tex',...
    'Units','Normalized','FontSize',Fonts(1));
mTextBox = text(locText(2,1),locText(2,2),text2,'interpreter','tex',...
    'Units','Normalized','FontSize',Fonts(2));


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