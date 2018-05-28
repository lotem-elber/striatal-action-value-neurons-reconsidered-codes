%plot fig 2 - fig. supp. 3

clear all
close all
%add all subfolders to path
addpath(genpath(pwd));
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
else
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
[tvaluesTot tvaluesTotQlearning tvaluesTotQlearningDetrending]=basal_ganglia_analyses_for_supp(AllQs,spike_data_basal_ganglia_all_phases);

i=6;
samVec=((i-1)*642+1):i*642;
tvaluesQlearningClean=[tvaluesTotQlearning(samVec,:)];
tvaluesQlearningClean(isnan(tvaluesQlearningClean(:,1)),:)=[];
regForPlot=tvaluesQlearningClean(:,1:2);
Draw_scatter_plot(regForPlot,2,2.5,0,0);

 %bar plot
tvaluesQlearningClean=tvaluesTotQlearning;
tvaluesQlearningClean(isnan(tvaluesQlearningClean(:,1)),:)=[];
regForPlot=tvaluesQlearningClean(:,1:2);
Draw_four_bar_plots(regForPlot,2,round(length(regForPlot)/40),0);
end
