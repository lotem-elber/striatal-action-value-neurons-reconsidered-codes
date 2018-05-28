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

f=figure('units','centimeters','Position',[1 -3 20 18]);
%fig 1A
a=axes('position',[0.1,0.815,0.43,0.14]);
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
p2=plot(1:length(PrForFig1A),PrForFig1A,'k','LineWidth',2);
%lines indicating choice and reward
p31=plot([action1Rewarded ; action1Rewarded],[ones(1,length(action1Rewarded)) ; 1-lengthLines(1)*ones(1,length(action1Rewarded))],'color',[0.9 0.4 0.4],'linewidth',1.5);
p32=plot([action1NotRewarded ; action1NotRewarded],[ones(1,length(action1NotRewarded)) ; 1-lengthLines(2)*ones(1,length(action1NotRewarded))],'color',[0.9 0.4 0.4],'linewidth',1.5);
p33=plot([action2Rewarded ; action2Rewarded],[zeros(1,length(action2Rewarded)) ; lengthLines(1)*ones(1,length(action2Rewarded))],'color',[0.3 0.3 0.8],'linewidth',1.5);
p34=plot([action2NotRewarded ; action2NotRewarded],[zeros(1,length(action2NotRewarded)) ; lengthLines(2)*ones(1,length(action2NotRewarded))],'color',[0.3 0.3 0.8],'linewidth',1.5);

l=legend([p31(1) p32(1) p33(1) p34(1)],'chose L, large reward','chose L, small reward','chose R, large reward','chose R, small reward');
set(l,'Position',[0.6 0.8 0.2 0.1]);
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
mTextBox = text(-0.2233,1.2,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
axis([0 trialsPerBlock(4) 0 1]);
ylabel({'pr.(choice=1)'},'FontSize',12);
set(gca,'Box','Off');
set(gca,'XTick',[]);
set(gca,'fontsize',12);

%fig 1C
a=axes('position',[0.1,0.265,0.43,0.14]);
hold on

plot( [trialsPerBlock(1) trialsPerBlock(1)],[0 5],'k--'...
    ,[trialsPerBlock(2) trialsPerBlock(2)],[0 5],'k--',...
    [trialsPerBlock(3) trialsPerBlock(3)],[0 5],'k--',...
 'LineWidth',1);
p1=plot((1:length(Q)),Q(:,1),'Color',[0.9 0.4 0.4],'LineWidth',1.5);
p2=plot(1:length(Q),estQ(:,1)','Color',[0.9 0.4 0.4],'LineWidth',0.5);
p3=plot(1:length(Q),Q(:,2),'Color',[0.3 0.3 0.8],'LineWidth',1.5);
p4=plot(1:length(Q),estQ(:,2),'Color',[0.3 0.3 0.8],'LineWidth',0.5);

set(gca,'yTick',[0.1 0.5 0.9]);
ylim([0 1]);
ylabel('value','FontSize',12);
xlim([0 trialsPerBlock(4)]);
xlabel('trials','FontSize',12);
mTextBox = text(-0.2233,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
set(gca,'Box','Off');
set(gca,'fontsize',12);

%subplot fig1B
ex1=1;
ex2=2;
num=343;
hold on
a=axes('Position',[0.1    0.62   0.43    0.14]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
mTextBox = text(-0.2233,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_single_neurons_examples(AllQs,num,ex1,ex2);


%call create plots for different figures
%Value Neuron

i=2;
num=343;
samVec=[round(linspace(i,4000,498)) 4*(num-1)+ex1 4*(num-1)+ex2];
sigmaPlace=1;
regForPlot=[ regTrial.action_value(samVec,:)];
numtvaluesForPlot=[499 500];

Draw_scatter_plot(regForPlot,2,2.5,0,0,numtvaluesForPlot);
mTextBox = text(-0.4,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');


%value neurons bar plot
regForPlot=regTrial.action_value;

Draw_four_bar_plots(regForPlot,2,1000,0);
mTextBox = text(-0.2233,1.1,'E','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

