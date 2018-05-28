close all
clear all
addpath(genpath(pwd));
[reg ,~,AllQs ]=Qlearning_action_value_and_RW_trial_design_for_fig_4_and_6();
f=figure('units','centimeters','Position',[1 -2 20 18]);
%fig 1A
X_begin=1;
X_end=20;
colorPalette=[0.4 0.1 0.2 ; 0 0.8 0.2 ;0.7 0.5 0 ; 0 0.6 0.8 ; 0 0 0 ; 0 0.498039215803146 0];
colorPalette=[0.89 0.384 0.384 ; 0.7 0.2 1 ;0.847 0.847 0.149 ; 0 0.6 0.6 ];
colorPalette = lines(4);
Patch_colorPalette=[0.988 0.914 0.906 ; 0.937 1 0.953 ; 1 0.965 0.878 ; 0.937 0.984 1];

session=78;
R=AllQs{session,5};
choice=AllQs{session,4};
Trial_order=AllQs{session,2}';
Qs=AllQs{session,6};
a=axes('Position',[0.1,0.56,0.43,0.14]);
mTextBox = text(- 0.2233,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
mSize=4.5;
hold on

action1Rewarded=find(R & choice);
action1NotRewarded=find(R==0 & choice);
action2Rewarded=find(R & choice==0);
action2NotRewarded=find(R==0 & choice==0);
y=find(1-R);
lengthLines=[0.12 0.06];
%probability of choice

patch1=patch([find(Trial_order(:,1)==0.9)'-0.5 ; find(Trial_order(:,1)==0.9)'+0.5 ; find(Trial_order(:,1)==0.9)'+0.5 ; find(Trial_order(:,1)==0.9)'-0.5 ],...
    [zeros(1,length(find(Trial_order(:,1)==0.9))) ; zeros(1,length(find(Trial_order(:,1)==0.9))) ; ones(1,length(find(Trial_order(:,1)==0.9))) ; ones(1,length(find(Trial_order(:,1)==0.9)))],...
    colorPalette(1,:),'EdgeColor','none');
patch2=patch([find(Trial_order(:,1)==0.1)'-0.5 ; find(Trial_order(:,1)==0.1)'+0.5 ; find(Trial_order(:,1)==0.1)'+0.5 ; find(Trial_order(:,1)==0.1)'-0.5 ],...
    [zeros(1,length(find(Trial_order(:,1)==0.1))) ; zeros(1,length(find(Trial_order(:,1)==0.1))) ; ones(1,length(find(Trial_order(:,1)==0.1))) ; ones(1,length(find(Trial_order(:,1)==0.1)))],...
    colorPalette(2,:),'EdgeColor','none');
patch3=patch([find(Trial_order(:,2)==0.9)'-0.5 ; find(Trial_order(:,2)==0.9)'+0.5 ; find(Trial_order(:,2)==0.9)'+0.5 ; find(Trial_order(:,2)==0.9)'-0.5 ],...
    [zeros(1,length(find(Trial_order(:,2)==0.9))) ; zeros(1,length(find(Trial_order(:,2)==0.9))) ; ones(1,length(find(Trial_order(:,2)==0.9))) ; ones(1,length(find(Trial_order(:,2)==0.9)))],...
    colorPalette(3,:),'EdgeColor','none');
patch4=patch([find(Trial_order(:,2)==0.1)'-0.5 ; find(Trial_order(:,2)==0.1)'+0.5 ; find(Trial_order(:,2)==0.1)'+0.5 ; find(Trial_order(:,2)==0.1)'-0.5 ],...
    [zeros(1,length(find(Trial_order(:,2)==0.1))) ; zeros(1,length(find(Trial_order(:,2)==0.1))) ; ones(1,length(find(Trial_order(:,2)==0.1))) ; ones(1,length(find(Trial_order(:,2)==0.1)))],...
    colorPalette(4,:),'EdgeColor','none');

p21=plot(find(Trial_order(:,1)==0.9),Qs(Trial_order(:,1)==0.9,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',mSize);
p22=plot(find(Trial_order(:,1)==0.1),Qs(Trial_order(:,1)==0.1,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',mSize);
p23=plot(find(Trial_order(:,2)==0.9),Qs(Trial_order(:,2)==0.9,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',mSize);
p24=plot(find(Trial_order(:,2)==0.1),Qs(Trial_order(:,2)==0.1,1),'o','Color','k','MarkerFaceColor','k','MarkerSize',mSize);
%lines indicating choice and reward
p31=plot([action1Rewarded' ; action1Rewarded'],[ones(1,length(action1Rewarded)) ; 1-lengthLines(1)*ones(1,length(action1Rewarded))],'color','k','linewidth',2);
p32=plot([action1NotRewarded' ;  action1NotRewarded'],[ones(1,length(action1NotRewarded)) ; 1-lengthLines(2)*ones(1,length(action1NotRewarded))],'color','k','linewidth',2);
p33=plot([action2Rewarded' ; action2Rewarded'],[zeros(1,length(action2Rewarded)) ; lengthLines(1)*ones(1,length(action2Rewarded))],'color','k','linewidth',2);
p34=plot([action2NotRewarded' ; action2NotRewarded'],[zeros(1,length(action2NotRewarded)) ; lengthLines(2)*ones(1,length(action2NotRewarded))],'color','k','linewidth',2);

l=legend([patch1(1) patch2(1) patch3(1) patch4(1) ],...
    '0.9,0.5','0.1,0.5','0.5,0.9','0.5,0.1');
legend boxoff;
set(l,'Position',[0.54 0.58 0.1 0.1]);
set(l,'FontSize',12);
axis([X_begin-0.5 X_end+0.5 0 1]);
ylabel({'\itQ_1'},'FontSize',12);
set(gca,'Box','Off');
set(gca,'XTick',[0.5 10 20]);
set(gca,'XTickLabel',[0 10 20]);
x_label=xlabel({'trials'},'FontSize',12,'Position',[10 -0.21 0.0]);
set(gca,'fontsize',12);


a=axes('Position',[0.1,0.34,0.2,0.14]);
hold on

patch1=patch([0.5 length(Qs(Trial_order(X_begin:X_end,1)==0.9))+0.5 length(Qs(Trial_order(X_begin:X_end,1)==0.9))+0.5 0.5],...
    [0 0 1 1], colorPalette(1,:),'EdgeColor','none');
p21=plot(1:length(Qs(Trial_order(X_begin:X_end,1)==0.9)),Qs(Trial_order(X_begin:X_end,1)==0.9,1),...
    '-o','Color','k','MarkerFaceColor','k','MarkerSize',mSize,'lineWidth',1.5);
R_block1=R(Trial_order(X_begin:X_end,1)==0.9);
choice_block1=choice(Trial_order(X_begin:X_end,1)==0.9);
action1Rewarded=find(R_block1 & choice_block1 );
action1NotRewarded=find(R_block1==0 & choice_block1);
action2Rewarded=find(R_block1 & choice_block1==0);
action2NotRewarded=find(R_block1==0 & choice_block1==0);
y=find(1-R);
p31=plot([action1Rewarded' ; action1Rewarded'],...
    [ones(1,length(action1Rewarded)) ; 1-lengthLines(1)*ones(1,length(action1Rewarded))],'color','k','linewidth',2);
p32=plot([action1NotRewarded' ;  action1NotRewarded'],...
    [ones(1,length(action1NotRewarded)) ; 1-lengthLines(2)*ones(1,length(action1NotRewarded))],'color','k','linewidth',2);
p33=plot([action2Rewarded' ; action2Rewarded'],...
    [zeros(1,length(action2Rewarded)) ; lengthLines(1)*ones(1,length(action2Rewarded))],'color','k','linewidth',2);
p34=plot([action2NotRewarded' ; action2NotRewarded'],...
    [zeros(1,length(action2NotRewarded)) ; lengthLines(2)*ones(1,length(action2NotRewarded))],'color','k','linewidth',2);
axis([1 length(Qs(Trial_order(X_begin:X_end,1)==0.9)) 0 1]);
ylabel({'\itQ_1'},'FontSize',12);
xlabel('trials','FontSize',12);
set(gca,'Box','Off');
set(gca,'XTick',[1 2 3 4 5]);
axis([0.5 length(Qs(Trial_order(X_begin:X_end,1)==0.9))+0.5 0 1]);
set(gca,'XTickLabel',find(Trial_order(X_begin:X_end,1)==0.9));

set(gca,'YTick',[0 0.5 1]);
set(gca,'fontsize',12);
 mTextBox = text(0.33 ,1.17,['(0.9,0.5)'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);


a=axes('Position',[0.33,0.34,0.2,0.14]);
hold on
patch2=patch([0.5 length(Qs(Trial_order(X_begin:X_end,1)==0.1))+0.5 length(Qs(Trial_order(X_begin:X_end,1)==0.1))+0.5 0.5],...
    [0 0 1 1], colorPalette(2,:),'EdgeColor','none');
p21=plot(1:length(Qs(Trial_order(X_begin:X_end,1)==0.1)),Qs(Trial_order(X_begin:X_end,1)==0.1,1),...
    'o-','Color','k','MarkerFaceColor','k','MarkerSize',mSize,'lineWidth',1.5);
R_block1=R(Trial_order(X_begin:X_end,1)==0.1);
choice_block1=choice(Trial_order(X_begin:X_end,1)==0.1);
action1Rewarded=find(R_block1 & choice_block1 );
action1NotRewarded=find(R_block1==0 & choice_block1);
action2Rewarded=find(R_block1 & choice_block1==0);
action2NotRewarded=find(R_block1==0 & choice_block1==0);
y=find(1-R);
p31=plot([action1Rewarded' ; action1Rewarded'],...
    [ones(1,length(action1Rewarded)) ; 1-lengthLines(1)*ones(1,length(action1Rewarded))],'color','k','linewidth',1.5);
p32=plot([action1NotRewarded' ;  action1NotRewarded'],...
    [ones(1,length(action1NotRewarded)) ; 1-lengthLines(2)*ones(1,length(action1NotRewarded))],'color','k','linewidth',1.5);
p33=plot([action2Rewarded' ; action2Rewarded'],...
    [zeros(1,length(action2Rewarded)) ; lengthLines(1)*ones(1,length(action2Rewarded))],'color','k','linewidth',1.5);
p34=plot([action2NotRewarded' ; action2NotRewarded'],...
    [zeros(1,length(action2NotRewarded)) ; lengthLines(2)*ones(1,length(action2NotRewarded))],'color','k','linewidth',1.5);
axis([1 length(Qs(Trial_order(X_begin:X_end,1)==0.1)) 0 1])

xlabel('trials','FontSize',12);
set(gca,'Box','Off');
set(gca,'XTick',[1 2 3 4 5]);
set(gca,'XTickLabel',find(Trial_order(X_begin:X_end,1)==0.1));
set(gca,'YTick',[]);
set(gca,'fontsize',12);
mTextBox = text(0.33 ,1.17,['(0.1,0.5)'],'interpreter','tex',...
    'Units','Normalized','FontSize',12);
axis([0.5 length(Qs(Trial_order(X_begin:X_end,1)==0.1))+0.5 0 1]);


figure('units','centimeters','position',[3 1 20 18/24*20]);
samVec=[round(linspace(1,19998,500))];
alpha=2;
mSize=2.5;
sample_size=1000;

Draw_scatter_plot([reg.action_value(samVec,1:2) ; 100 8],alpha,mSize,[ 0.1    0.6300    0.24    0.32],'action-value neurons');
mTextBox = text(-0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%plot bar chart - action-value
Draw_four_bar_plots(reg.action_value(:,1:2),alpha,1000,[ 0.37    0.63    0.16    0.32],0,[-0.01 0 0.03 0.02]);
mTextBox = text(-0.12,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%RW
Draw_scatter_plot([reg.random_walk(samVec,1:2) ; 100 8],alpha,mSize,[ 0.1    0.1700    0.24    0.32],'random-walk neurons');
mTextBox = text(-0.4,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%plot bar chart - random-walk
Draw_four_bar_plots(reg.random_walk(:,1:2),alpha,1000,[ 0.37   0.17    0.16    0.32],0,[-0.01 -0.01 -0.22 0.03]);
mTextBox = text(-0.12,1.1,'E','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
