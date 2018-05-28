%%
%Autoregressive_coefficients create plot
%create plots for Autoregressive_coefficients  analysis - random walk
close all
clear all
%add all subfolder of current path (generate_all_figs) to path
addpath(genpath(pwd));
[tvaluesQlearningAutoregressive_coefficients_RW , tvaluesQlearningAutoregressive_coefficients_motor_cortex...
    tvaluesQlearningAutoregressive_coefficients_auditory_cortex , tvaluesQlearningAutoregressive_coefficients_basal_ganglia...
    ]=analyses_regs_with_autoregressive_coefficients();

figure('units','centimeters','position',[3 1 20 18/24*20]);
regForPlot=tvaluesQlearningAutoregressive_coefficients_RW(1:500,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
alpha=2.3;
mSize=2.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.1    0.6300    0.24    0.32],'random walk');
mTextBox = text(-0.4,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - RW
sample_size=1000;
alpha=2.3;
regForPlot=tvaluesQlearningAutoregressive_coefficients_RW;
Draw_single_bar_plot(regForPlot,alpha,sample_size,[ 0.35    0.63    0.08    0.32]);


%create plots for Autoregressive_coefficients analysis - motor_cortex data
i=2;
regForPlot=tvaluesQlearningAutoregressive_coefficients_motor_cortex(89*(i-1)+1:89*i,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
alpha=2.3;
mSize=3.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.6    0.6300    0.24    0.32],'motor cortex');
mTextBox = text(- 0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - motor_cortex Data
sample_size=89;
alpha=2.3;
regForPlot=tvaluesQlearningAutoregressive_coefficients_motor_cortex;
Draw_single_bar_plot(regForPlot,alpha,sample_size,[ 0.85    0.63    0.08    0.32]);

%create plots for Autoregressive_coefficients analysis - auditory_cortex data

i=2;
regForPlot=tvaluesQlearningAutoregressive_coefficients_auditory_cortex(125*(i-1)+1:125*i,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
alpha=2.3;
mSize=3.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.1    0.1300    0.24    0.32],'auditory cortex');
mTextBox = text(- 0.4,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
%plot bar chart - auditory_cortex data
regForPlot=tvaluesQlearningAutoregressive_coefficients_auditory_cortex;
regForPlot(isnan(regForPlot(:,1)),:)=[];
sample_size=floor(size(regForPlot,1)/40);
alpha=2.3;

Draw_single_bar_plot(regForPlot,alpha,sample_size,[ 0.35    0.13    0.08    0.32]);

%create plots for Autoregressive_coefficients  analysis - basal_ganglia data
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
else
i=1;
regForPlot=tvaluesQlearningAutoregressive_coefficients_basal_ganglia(642*(i-1)+1:642*i,:);
regForPlot(isnan(regForPlot(:,1)),:)=[];
alpha=2.3;
mSize=2.5;
Draw_scatter_plot(regForPlot,alpha,mSize,[ 0.6    0.1300    0.24    0.32],'basal ganglia');
mTextBox = text(- 0.4,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');

%plot bar chart - basal_ganglia data
regForPlot=tvaluesQlearningAutoregressive_coefficients_basal_ganglia;
regForPlot(isnan(regForPlot(:,1)),:)=[];
sample_size=floor(size(regForPlot,1)/40);
alpha=2.3;
hold on
Draw_single_bar_plot(regForPlot,alpha,sample_size,[ 0.85    0.13    0.08    0.32]);
end
    