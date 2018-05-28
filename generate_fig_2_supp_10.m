%%
%create plots for sessions with 8 blocks, the four blocks are repeated
%twice, each time in random permutation, repetitions are allowed 
%create plots for 8blocks - random walk

clear all
close all
%add all subfolders to path
addpath(genpath(pwd));
load('seedMem8blocks.mat');
[~, regTrial,~,~]=Qlearning_action_value_and_RW(seedMem8blocks,8);
figure('units','centimeters','position',[3 1 20 18/24*20]);
samVec=[round(linspace(1,19998,500))];
alpha=2;
mSize=2.5;
Draw_scatter_plot(regTrial.random_walk(samVec,1:2),alpha,mSize,[ 0.1    0.6300    0.24    0.32],'random walk');
mTextBox = text(-0.4,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - RW
sample_size=1000;
alpha=2;
Draw_four_bar_plots(regTrial.random_walk,alpha,sample_size,[ 0.35    0.63    0.14    0.32],0,[-0.02 0.15 0.3 0.17]);


%create plots  - motor_cortex data
clear all
load('motor_cortex_spike_data.mat');
load('seedMem8blocks.mat');
[~, ~,~,AllQs]=Qlearning_action_value_and_RW(seedMem8blocks,8,1.5);
AllQs_motor_cortex=AllQs;
for i=size(AllQs_motor_cortex,1):-1:1
    if length(AllQs_motor_cortex{i,1})>600
        AllQs_motor_cortex(i,:)=[];
    end
end
[~, tvaluesTotQlearning,~]=regression_analyses_motor_auditory_cortex(motor_cortex_spike_data,AllQs_motor_cortex,20);
i=3;
regForPlot=tvaluesTotQlearning(89*(i-1)+1:89*i,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
alpha=2;
mSize=3.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.6    0.6300    0.24    0.32],'motor cortex');
mTextBox = text(-0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - motor_cortex Data
sample_size=89;
alpha=2;
regForPlot=tvaluesTotQlearning;
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.85    0.63    0.14    0.32],0,[-0.1 0 0.2 0.13]);

%create plots - auditory_cortex data
load('auditory_cortex_spike_data.mat');
AllQs_auditory_cortex=AllQs;
for i=size(AllQs_auditory_cortex,1):-1:1
    if length(AllQs_auditory_cortex{i,1})>370
        AllQs_auditory_cortex(i,:)=[];
    end
end
[~, tvaluesTotQlearning, ~]=regression_analyses_motor_auditory_cortex(spikeDataRes,AllQs_auditory_cortex,13);
i=2;
regForPlot=tvaluesTotQlearning(125*(i-1)+1:125*i,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
alpha=2;
mSize=3.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.1    0.1300    0.24    0.32],'auditory cortex');
mTextBox = text(-0.4,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%plot bar chart - auditory_cortex data
regForPlot=tvaluesTotQlearning;
regForPlot(isnan(regForPlot(:,1)),:)=[];
sample_size=floor(size(regForPlot,1)/40);
alpha=2;

Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.35    0.13    0.14    0.32],0,[-0.1 0 0.2 0.17]);
