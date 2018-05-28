close all
clear all
%add all subfolders to path
addpath(genpath(pwd));
%analyze random-walk data
load('seedMem_for_figs_1_and_2.mat');
[reg, regTrial,  regDetrend,AllQs]=Qlearning_action_value_and_RW(seedMem);
%analyze data from motor cortex
load('motor_cortex_spike_data.mat');
[reg_motor_cortex, regTrial_motor_cortex,  regDetrend_motor_cortex]=regression_analyses_motor_auditory_cortex(motor_cortex_spike_data,AllQs,20);
%analyze data from auditory cortex
load('auditory_cortex_spike_data.mat');
%data from auditory cortex has only 370 trials, delete all estimated Qs
%that are longer (in this case there is only one such estimated Q)
AllQs_auditory=AllQs;
for i=size(AllQs_auditory,1):-1:1
    if length(AllQs_auditory{i,1})>370
        AllQs_auditory(i,:)=[];
    end
end
[reg_auditory_cortex, regTrial_auditory_cortex,  regDetrend_auditory_cortex]=regression_analyses_motor_auditory_cortex(spikeDataRes,AllQs_auditory,20);
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
else
%analyze data from basal ganglia
load('seedMem12blocks.mat');
[~,~,~,AllQs]=Qlearning_action_value_and_RW(seedMem12blocks,12,1.5,1);
%804 is the maximum number of trials in a session in the basal ganglia
%data, use only estimated actio-values with 804 trials or more
for i=size(AllQs,1):-1:1
    if length(AllQs{i,1})<804
        AllQs(i,:)=[];
    end
end
load('basal_ganglia_data.mat');
[reg_basal_ganglia regTrial_basal_ganglia regDetrend_basal_ganglia]=basal_ganglia_analyses_for_supp(AllQs,spike_data_basal_ganglia_all_phases);
end
%%
%create Fig. 2 - Fig. supplement 7 - using a detrending variable in the
%regression
alpha=2.64;
figure('units','centimeters','position',[3 1 20 18/24*20]);
%random walk
i=1;
samVec=[round(linspace(i,length(regDetrend.random_walk)-(length(regDetrend.random_walk)/1000)+i,500))  ];
mSize=2.5;
Draw_scatter_plot(regDetrend.random_walk(samVec,:),alpha,mSize,[ 0.1    0.6300    0.24    0.32],'random walk');
mTextBox = text(-0.4,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');


%plot bar chart - RW
sample_size=1000;
Draw_four_bar_plots(regDetrend.random_walk,alpha,sample_size,[ 0.35    0.63    0.14    0.32],0, [0 -0.08 -0.2 0.2]);


% - motor_cortex data
i=1;
regForPlot=[regDetrend_motor_cortex(((i-1)*89+1):(i*89),:)];
mSize=3.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.6    0.6300    0.24    0.32],'motor cortex');
mTextBox = text(-0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - motor_cortex Data
sample_size=89;
regForPlot=regDetrend_motor_cortex;
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.85   0.63    0.14    0.32],0);

%auditory_cortex data
i=17;
regForPlot=regDetrend_auditory_cortex(125*(i-1)+1:125*i,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
mSize=3.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.1    0.1300    0.24    0.32],'auditory cortex');
mTextBox = text(-0.4,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - auditory_cortex data
regForPlot=regDetrend_auditory_cortex;
regForPlot(isnan(regForPlot(:,1)),:)=[];
sample_size=floor(size(regForPlot,1)/40);
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.35    0.13    0.14    0.32],0,[0 -0.08 -0.2 0.2]);

%basal_ganglia data
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
else
 i=8;
regForPlot=regDetrend_basal_ganglia(642*(i-1)+1:642*i,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
mSize=2.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.6    0.1300    0.24    0.32],'basal ganglia');
mTextBox = text(-0.4,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - basal_ganglia data
regForPlot=regDetrend_basal_ganglia;
regForPlot(isnan(regForPlot(:,1)),:)=[];
sample_size=floor(size(regForPlot,1)/40);
hold on
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.85    0.13    0.14    0.32],0,[-0.1 0 0.17 0.13]);
end