%%
%create Fig 2 - Fig. supplement 4 from loaded data 
clear all
close all
%add all subfolders to path
addpath(genpath(pwd));
load('kim_2009_permutation_analysis_all_datasets.mat');
tvalues_RW(isnan(tvalues_RW(:,1)),:)=[];
tvalues_auditory(isnan(tvalues_auditory(:,1)),:)=[];
tvalues_basal_ganglia(isnan(tvalues_basal_ganglia(:,1)),:)=[];
figure('units','centimeters','position',[3 1 20 18/24*20]);
Draw_plot_permutation_Kim([tvalues_RW tvaluesPerm_RW],2,2.5,[0.1 0.63 0.24 0.32],'random walk',500,1000);
mTextBox = text(-4.57,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_plot_permutation_Kim([tvalues_motor tvaluesPerm_motor],2,3.5,[0.6 0.63 0.24 0.32],'motor cortex',89,89);
mTextBox = text(-4.57,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_plot_permutation_Kim([tvalues_auditory tvaluesPerm_auditory],2,3.5,[0.1 0.13 0.24 0.32],'auditory cortex',82,82);
mTextBox = text(-4.57,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_plot_permutation_Kim([tvalues_basal_ganglia tvaluesPerm_basal_ganglia],2,2.5,[0.6 0.13 0.24 0.32],'basal ganglia',500,642);
mTextBox = text(-4.57,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');




