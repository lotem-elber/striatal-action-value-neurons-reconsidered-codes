close all
clear all
addpath(genpath(pwd));
%figure of correlation of choice with action-value
[reg_policy, regTrial_policy , regChoiceInReg_policy , AllQs]=direct_policy_policy_neurons();

QValues=[];
for session=1:1000
    QValues=[QValues ;  AllQs{session,1} AllQs{session,6}'  session*ones(length(AllQs{session,1}),1)];
end
%diff_Qs
figure('units','centimeters','position',[3 1 20 18]);
a=axes('position',[ 0.1    0.33    0.13   0.14]);
mTextBox = text(- 0.7385,1.2,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
pr=[];
pr_se=[];
l=[];
delta=0.01;
for i=-1:delta:(1-delta)
    loc=(QValues(:,2)-QValues(:,3))>=i & (QValues(:,2)-QValues(:,3))<i+delta;
  pr=[pr ; mean(QValues(loc,1))];
  pr_se=[pr_se ; std(QValues(loc,1))/sqrt(length(unique(QValues(loc,4)))-1)];
  l=[l length(unique(QValues(loc,4)))];
end
patch([-1:delta:(1-delta) fliplr(-1:delta:(1-delta))],[pr+pr_se ; flipud([pr-pr_se])],[0.7 0.7 0.7],'EdgeColor','none');
hold on
plot(-1:delta:(1-delta),pr,'Color','k','LineWidth',1);
xlabel('\it"Q_1 - \itQ_2"');
ylabel('pr.(choice=1)');
axis([-0.5 0.5 0.2 0.8]);
set(gca,'XTick',[-0.4   0.4]);
set(gca,'YTick',[0.2   0.8]);
set(gca,'FontSize',12);
%Q1
a=axes('position',[ 0.25    0.33    0.13    0.14]);

pr=[];
pr_se=[];
delta=0.01;
for i=0:delta:(1-delta)
    loc=(QValues(:,2))>=i & (QValues(:,2))<i+delta;
  pr=[pr ; mean(QValues(loc,1))];
  pr_se=[pr_se ; std(QValues(loc,1))/sqrt(length(unique(QValues(loc,4)))-1)];
end
patch([0:delta:(1-delta) fliplr(0:delta:(1-delta))],[pr+pr_se ; flipud([pr-pr_se])],[0.7 0.7 0.7],'EdgeColor','none');
hold on
plot(0:delta:(1-delta),pr,'Color','k','LineWidth',1);
xlabel('\it"Q_1"');
axis([0.1 0.9 0.2 0.8]);
set(gca,'XTick',[0.2  0.8]);
set(gca,'YTick',[]);
set(gca,'FontSize',12);

%Q2
a=axes('position',[ 0.4    0.33    0.13    0.14]);
pr=[];
pr_se=[];
delta=0.01;
for i=0:delta:(1-delta)
    loc=(QValues(:,3))>=i & (QValues(:,3))<i+delta;
  pr=[pr ; mean(QValues(loc,1))];
  pr_se=[pr_se ; std(QValues(loc,1))/sqrt(length(unique(QValues(loc,4)))-1)];
end
patch([0:delta:(1-delta) fliplr(0:delta:(1-delta))],[pr+pr_se ; flipud([pr-pr_se])],[0.737 0.859 0.796],'EdgeColor','none');
hold on
plot(0:delta:(1-delta),pr,'Color','k','LineWidth',1);
xlabel('\it"Q_2"');
axis([0.1 0.9 0.2 0.8]);
set(gca,'XTick',[0.2  0.8]);
set(gca,'YTick',[]);
set(gca,'FontSize',12);


%draw example probability choice neurons
session=98;
trialsPerBlock=AllQs{session,3};
R=AllQs{session,5};
choice=AllQs{session,4};
Pr=AllQs{session,1};
RChoose=AllQs{session,2};
estQ=AllQs{session,6};

a=axes('position',[ 0.1    0.8    0.43    0.14]);
mTextBox = text(-0.2233,1.2,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
hold on
plot( [trialsPerBlock(1) trialsPerBlock(1)],[0 1],'k--',...
    [trialsPerBlock(2) trialsPerBlock(2)],[0 1],'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],[0 1],'k--',...
    'LineWidth',1);
action1Rewarded=find(R & choice);
action1NotRewarded=find(R==0 & choice);
action2Rewarded=find(R & choice==0);
action2NotRewarded=find(R==0 & choice==0);
y=find(1-R);
lengthLines=[0.12 0.06];
%probability of choice
p2=plot(1:length(Pr),Pr,'k','LineWidth',2);
%lines indicating choice and reward
p31=plot([action1Rewarded ; action1Rewarded],[ones(1,length(action1Rewarded)) ; 1-lengthLines(1)*ones(1,length(action1Rewarded))],...
    'color',[0.9 0.4 0.4],'linewidth',1.5);
p32=plot([action1NotRewarded ; action1NotRewarded],[ones(1,length(action1NotRewarded)) ; 1-lengthLines(2)*ones(1,length(action1NotRewarded))],...
    'color',[0.9 0.4 0.4],'linewidth',1.5);
p33=plot([action2Rewarded ; action2Rewarded],[zeros(1,length(action2Rewarded)) ; lengthLines(1)*ones(1,length(action2Rewarded))],'color',[0.3 0.3 0.8],...
    'linewidth',1.5);
p34=plot([action2NotRewarded ; action2NotRewarded],[zeros(1,length(action2NotRewarded)) ; lengthLines(2)*ones(1,length(action2NotRewarded))],...
    'color',[0.3 0.3 0.8],'linewidth',1.5);

locationTextBoxX=[trialsPerBlock(1)/2 , trialsPerBlock(1)+(trialsPerBlock(2)-trialsPerBlock(1))/2 ,...
     trialsPerBlock(2)+(trialsPerBlock(3)-trialsPerBlock(2))/2 ,...
      trialsPerBlock(3)+(trialsPerBlock(4)-trialsPerBlock(3))/2]/trialsPerBlock(4)-0.09;
locationTextBoxY=1.15; 

 mTextBox = text(locationTextBoxX(1) ,locationTextBoxY,['(' num2str(RChoose(1,1)) ',' num2str(RChoose(2,1)) ')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);      
        mTextBox = text(locationTextBoxX(2)  ,locationTextBoxY,['(' num2str(RChoose(1,2)) ',' num2str(RChoose(2,2)) ')'],'interpreter','tex',...
        'Units','Normalized','FontSize',12);    
     mTextBox = text(locationTextBoxX(3) ,locationTextBoxY,['(' num2str(RChoose(1,3)) ',' num2str(RChoose(2,3)) ')'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);      
     mTextBox = text(locationTextBoxX(4) ,locationTextBoxY,['(' num2str(RChoose(1,4)) ',' num2str(RChoose(2,4)) ')'],'interpreter','tex',...
        'Units','Normalized','FontSize',12);  

axis([0 trialsPerBlock(4) 0 1]);
ylabel({'pr.(choice=1)'},'FontSize',12);
set(gca,'Box','Off');
set(gca,'XTick',[]);
set(gca,'fontsize',12);

%estimated action-values from choice model
figPosition=[0.1    0.6    0.43   0.14; ...
    0.1    0.14    0.43    0.14 ];
a=axes('position',figPosition(1,:));
mTextBox = text(-0.2233,1.2,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

hold on
Q=AllQs{session,6}';
set(gca,'fontsize',12);
xlim([0 trialsPerBlock(4)] );
ylim([0 1]);
limitsPlot=([xlim ylim]);
plot([trialsPerBlock(1) trialsPerBlock(1)],[limitsPlot(3:4)],'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],[limitsPlot(3:4)],'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],[limitsPlot(3:4)],'k--','LineWidth',1);

p4=plot(1:trialsPerBlock(4),Q(:,1),'Color',[0.9 0.4 0.4],'LineWidth',2);
p5=plot(1:trialsPerBlock(4),Q(:,2),'Color',[0.3 0.3 0.8],'LineWidth',2);
ylabel({'computed','action-values'});
xlabel('trials','Fontsize',12);

figPosition=[0.1    0.33    0.43   0.14; ...
    0.1    0.16    0.43    0.14 ];

figure('units','centimeters','position',[3 1 20 18/24*20]);
i=2;
session=98;
neuron2=5;
neuron1=2;
samVec=[round(linspace(i,20000,498)) 20*(session-1)+neuron1 20*(session-1)+neuron2];

Draw_scatter_plot(regTrial_policy(samVec,1:2),2,2.5,[0.1    0.1    0.24   0.32],0);
mTextBox = text(-0.4,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

Draw_four_bar_plots(regTrial_policy(:,1:2),2,1000,[0.37    0.1    0.16   0.32],0,[-0.1 -0.1 -0.15 -0.05] );
mTextBox = text(-0.12,1.1,'E','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

