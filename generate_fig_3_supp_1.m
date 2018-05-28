close all
clear all
addpath(genpath(pwd)); 
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
else
%draw plots for the standard analysis on the original basal ganglia data (Ito and Doya 2009)
load('basal_ganglia_data.mat');
tvaluesTot=zeros(642,2);
tvaluesTotQlearning=zeros(642,2);
boundary=2.64;
[tvaluesTot(1:214,:), tvaluesTotQlearning(1:214,:)]=basal_ganglia_original_analyses(spike_data_basal_ganglia_all_phases(1:214),AllQs_basal_ganglia,boundary);
[tvaluesTot(215:428,:), tvaluesTotQlearning(215:428,:)]=basal_ganglia_original_analyses(spike_data_basal_ganglia_all_phases(215:428),AllQs_basal_ganglia,boundary);
[tvaluesTot(429:642,:), tvaluesTotQlearning(429:642,:)]=basal_ganglia_original_analyses(spike_data_basal_ganglia_all_phases(429:642),AllQs_basal_ganglia,boundary);
 figure('units','centimeters','position',[3 1 20 18/24*20]);

regForPlot=tvaluesTotQlearning;
regForPlot(isnan(regForPlot(:,1)),:)=[];

alpha=2.64;
mSize=2.5;
sample_size=52;
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.45    0.56    0.16    0.32],0,[-0.02 0.15 0.3 0.17]);
Draw_scatter_plot([regForPlot ; 100 14],alpha,mSize,[ 0.2    0.5600    0.24    0.32],{'basal ganglia','action-values from basal ganglia sessions','p<0.01'});
ax=gca;
ax.Title.Position=[3.5 14.5105 0];
ax.XTick=[-10 -2.64 10];
ax.YTick=[-10 -2.64 2.64 10];
alpha=2;
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.45    0.1    0.16    0.32],0,[-0.02 0.15 0.3 0.17]);
Draw_scatter_plot([regForPlot ; 100 14],alpha,mSize,[ 0.2    0.100    0.24    0.32],'p<0.05');
ax=gca;
ax.Title.Position=[3.5 14.5105 0];
ax.XTick=[-10 -5 -2 2 5 10];
ax.YTick=[-10 -5 -2 2 5 10];
mTextBox = text(- 0.6,2.7,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%%
%%%regression of random-walk neurons on estimated action-values from basal
%%%ganglia
clear all
load('basal_ganglia_data.mat');
tvaluesTot=[];
tvaluesTotQlearning=[];
load('seedMem_for_figs_1_and_2.mat');
rng(seedMem);
sigma=0.1;
numRepeats=50;
tvaluesTotQlearning=nan(642*numRepeats,2);
for repeats=1:numRepeats

RW=cell(1,642);
for i=1:642
    RW{i}=2.5;
    for trial=1:length(spike_data_basal_ganglia_all_phases{i})
    RW{i}=[RW{i} ; max(0,RW{i}(end)+randn*sigma)];
    end
    RW{i}=poissrnd(RW{i});
end


tvaluesQlearning=nan(642,2);
boundary=2.64;
[~, tvaluesQlearning(1:214,:)]=basal_ganglia_original_analyses(RW(1:214),AllQs_basal_ganglia,boundary);
[~, tvaluesQlearning(215:428,:)]=basal_ganglia_original_analyses(RW(215:428),AllQs_basal_ganglia,boundary);
[~, tvaluesQlearning(429:642,:)]=basal_ganglia_original_analyses(RW(429:642),AllQs_basal_ganglia,boundary);

tvaluesTotQlearning((repeats-1)*642+1:repeats*642,:)=tvaluesQlearning;
end

figure('units','centimeters','position',[3 1 20 18/24*20]);
regForPlot=tvaluesTotQlearning;
regForPlot(isnan(regForPlot(:,1)),:)=[];
alpha=2.64;
mSize=2.5;
sample_size=52;
samVec=round(linspace(1,length(regForPlot),500));
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.45    0.56    0.16    0.32],0,[-0.02 0.15 0.3 0.17]);
Draw_scatter_plot([regForPlot(samVec,:) ; 100 14],alpha,mSize,[ 0.2    0.5600    0.24    0.32],{'random-walk','action-values from basal ganglia sessions','p<0.01'});
ax=gca;
ax.Title.Position=[3.5 14.5105 0];
ax.XTick=[-10 -2.64 10];
ax.YTick=[-10 -2.64 2.64 10];
alpha=2;
Draw_four_bar_plots(regForPlot,alpha,sample_size,[ 0.45    0.1    0.16    0.32],0,[-0.02 0.15 0.3 0.17]);
Draw_scatter_plot([regForPlot(samVec,:) ; 100 14],alpha,mSize,[ 0.2   0.100    0.24    0.32],'p<0.05');
ax=gca;
ax.Title.Position=[3.5 14.5105 0];
ax.XTick=[-10 -5 -2 2 5 10];
ax.YTick=[-10 -5 -2 2 5 10];
mTextBox = text(- 0.6,2.7,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
end
