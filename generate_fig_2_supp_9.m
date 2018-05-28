clear all
close all
%add all subfolders to path
addpath(genpath(pwd));
whichstats={'tstat','fstat'};
load('seedMem_for_figs_1_and_2.mat');
[~,~,~,AllQs]=Qlearning_action_value_and_RW(seedMem);
rng(seedMem);
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
    BG_data_exist=0;
else
   BG_data_exist=1;
   load('basal_ganglia_data.mat');
   basal_ganglia_neurons=spike_data_basal_ganglia_all_phases;
end


load('motor_cortex_spike_data.mat');
motor_cortex_neurons=motor_cortex_spike_data;
load('auditory_cortex_spike_data.mat');
auditory_cortex_neurons=spikeDataRes;


reg_results=[];
reg_motor_cortex_results=[];
reg_auditory_cortex_results=[];
reg_basal_ganglia_results=[];
other_sessions=zeros(1000,1);
estQs=cell(1000);
for session=1:1000
    estQ=zeros(length(AllQs{session,1}),2);
    other_session=randi([1 1000]);
    %I added | other_session==session below, to prevent cases where the
    %same session is chosen twice for the intermingled session
    while length(AllQs{other_session,1})<(length(AllQs{session,1})/2+1)  | other_session==session
        other_session=randi([1 1000]);
    end
    other_sessions(session)=other_session;
    indices=randperm(length(AllQs{session,1}));
    mid=round(length(indices)/2);
    estQ(sort(indices(1:mid)),:)=AllQs{session,1}(1:mid,:);
    estQ(sort(indices(mid+1:end)),:)=AllQs{other_session,1}(1:(length(indices)-mid),:);
    %for random walk just use the random walk neurons from the original
    %session with the same number of trials
    for neuron=1:size(AllQs{session,9},2)
        rStats=regstats(AllQs{session,9}(:,neuron), estQ,'linear',whichstats);
        t=rStats.tstat;
        f=rStats.fstat;
        tvalue=t.t;
        reg_results=[reg_results ; tvalue(2) tvalue(3)];
    end
    if session<=889
        first_inx=mod(session,20);
        if first_inx==0
            first_inx=20;
        end
        for neuron=first_inx:20:89
            rStats=regstats(motor_cortex_neurons(1:length(estQ),neuron), estQ,'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            reg_motor_cortex_results=[reg_motor_cortex_results ; tvalue(2) tvalue(3)];
        end
    end
    %this is the only session with more than 370 trials (the number of trials in the auditory cortex data)
    %so just skip it
    if session~=446
        first_inx=mod(session,20);
        if first_inx==0
            first_inx=20;
        end
        for neuron=first_inx:20:125
            trialsPerBlock=[0 AllQs{session,3}];
            goodSpikeCount=0;
            for i=1:length(trialsPerBlock)-1
                if (mean(auditory_cortex_neurons(trialsPerBlock(i)+1:trialsPerBlock(i+1),neuron))>1)
                    goodSpikeCount=1;
                    
                end
            end
            if goodSpikeCount
                rStats=regstats(auditory_cortex_neurons(1:length(estQ),neuron), estQ,'linear',whichstats);
                t=rStats.tstat;
                f=rStats.fstat;
                tvalue=t.t;
                reg_auditory_cortex_results=[reg_auditory_cortex_results ; tvalue(2) tvalue(3)];
            end
        end
    end
    if BG_data_exist
    %basal_ganglia_neurons
    first_inx=mod(session,25);
    if first_inx==0
        first_inx=25;
    end
    for neuron=first_inx:25:642
        trialsPerBlock=[0 AllQs{session,3}];
        if length(basal_ganglia_neurons{neuron})>=length(estQ)
            goodSpikeCount=0;
            for i=1:length(trialsPerBlock)-1
                if (mean(basal_ganglia_neurons{neuron}(trialsPerBlock(i)+1:trialsPerBlock(i+1)))>1)
                    goodSpikeCount=1;
                    
                end
            end
            if goodSpikeCount
                rStats=regstats(basal_ganglia_neurons{neuron}(1:length(estQ)), estQ,'linear',whichstats);
                t=rStats.tstat;
                f=rStats.fstat;
                tvalue=t.t;
                reg_basal_ganglia_results=[reg_basal_ganglia_results ; tvalue(2) tvalue(3)];
            end
        end
    end
    end
    estQs{session}=estQ;
end
close all
figure('units','centimeters','position',[3 1 20 18/24*20]);
samVec=round(linspace(1,length(reg_results),500));
regForPlot=reg_results(samVec,:);
Draw_scatter_plot(regForPlot,2,2.5,[ 0.1    0.6300    0.24    0.32],'random walk');
mTextBox = text(-0.4,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_four_bar_plots(reg_results,2,1000,[ 0.35    0.63    0.14    0.32],0,[-0.1 0 0.2 0.2]);

samVec=round(linspace(10,length(reg_motor_cortex_results),89));
regForPlot=reg_motor_cortex_results(samVec,:);
Draw_scatter_plot(regForPlot,2,3.5,[ 0.6    0.6300    0.24    0.32],'motor cortex');
mTextBox = text(-0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_four_bar_plots(reg_motor_cortex_results,2,1000,[ 0.85    0.63    0.14    0.32],0,[-0.1 0 0.2 0.13]);

samVec=round(linspace(1,length(reg_auditory_cortex_results),81));
regForPlot=reg_auditory_cortex_results(samVec,:);
Draw_scatter_plot(regForPlot,2,3.5,[ 0.1    0.1300    0.24    0.32],'auditory cortex');
mTextBox = text(-0.4,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_four_bar_plots(reg_auditory_cortex_results,2,1000,[ 0.35    0.13    0.14    0.32],0);
if BG_data_exist
samVec=round(linspace(1,length(reg_basal_ganglia_results),500));
regForPlot=reg_basal_ganglia_results(samVec,:);
Draw_scatter_plot(regForPlot,2,2.5,[ 0.6    0.1300    0.24    0.32],'basal ganglia');
mTextBox = text(-0.4,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_four_bar_plots(reg_basal_ganglia_results,2,1000,[ 0.85    0.13    0.14    0.32],0,[-0.1 0 0.2 0.13]);
end
