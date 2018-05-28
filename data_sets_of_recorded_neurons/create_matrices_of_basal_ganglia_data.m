%%
%Analyses of basal ganglia data
%create file with events matching to units
names=what('Data');
names=names.mat;
organized_File_list=cell(0);
areaCode=[];
%area code - 1 for NA, 0 for VPs
%go through data, fit neural data to experimental setting and give area
%code
%we get [unit event area-code]
for i=1:length(names)
    name_for_now=names{i};
    if length(name_for_now)>15  && isequal(name_for_now(12:15),'Unit')
        organized_File_list{size(organized_File_list,1)+1,1}=name_for_now;
        organized_File_list{size(organized_File_list,1),2}=[name_for_now(1:11),'Event.mat'];
        if str2num(name_for_now(16:17))<17
            organized_File_list{size(organized_File_list,1),3}=1;
            areaCode=[areaCode 1];
        else
            organized_File_list{size(organized_File_list,1),3}=0;
            areaCode=[areaCode 0];
        end
    end
end
save('organized_File_list','organized_File_list')
%%
%create tables of spike data and Q-values for 214 neural recordings

load('organized_File_list.mat')
spike_data_basal_ganglia_phase1=cell(1,214);
spike_data_basal_ganglia_phase2=cell(1,214);
spike_data_basal_ganglia_phase3=cell(1,214);
AllQs_basal_ganglia=cell(0);

%AllQs_basal_ganglia(:,1) is estimated Q
%AllQs_basal_ganglia(:,2) is reward schedule - reward probability in each block
%AllQs_basal_ganglia(:,3) is number of trials at the end of each block
%estAlphaRem and estBetaRem - so we know the distribution of estimations
estAlphaRem=[];
estBetaRem=[];
for i=1:length(organized_File_list)
    %this command loads UnitTime from the neural information file
    load(organized_File_list{i,1});
    %this commant loads all the corresponding event data (BlockDesign
    %etc..)
    load(organized_File_list{i,2});
    %take reward schedule
    RChoose=BlockDesign.RewardRule(:,1:2)';
    
    %if last block was not finished do not use data from last block
    
    RChoose(:,BlockDesign.FinishedBlock==0)=[];
    BlockForTrial=Trial.Block;
    BlockForTrial(BlockForTrial>size(RChoose,2))=[];
    choice=Trial.Action(1:length(BlockForTrial));
    R=Trial.Reward(1:length(BlockForTrial));
    %delete B trials and error trials
    BlockForTrial(isnan(choice))=[];
    R(isnan(choice))=[];
    choice(isnan(choice))=[];
    %to use existing code change second choice to 0
    choice(choice==2)=0;
    %estimate Q-value according to maximum likelihood
    [estQ,estAlphaRem,estBetaRem] = Estimate_Q(choice,R,estAlphaRem,estBetaRem );
    
    %compute how many trials at the end of each block
    trialsPerBlock=sum(BlockForTrial==1);
    for countBlocks=2:size(RChoose,2)
        trialsPerBlock=[trialsPerBlock trialsPerBlock(end)+sum(BlockForTrial==countBlocks)];
    end
    %put all event data into cell array
    AllQs_basal_ganglia{size(AllQs_basal_ganglia,1)+1,1}=estQ;
    AllQs_basal_ganglia{size(AllQs_basal_ganglia,1),2}=RChoose;
    AllQs_basal_ganglia{size(AllQs_basal_ganglia,1),3}=trialsPerBlock;
    AllQs_basal_ganglia{size(AllQs_basal_ganglia,1),4}=choice;
    AllQs_basal_ganglia{size(AllQs_basal_ganglia,1),5}=R;
    %find spike counts
    %continue only for terminated blocks
    for trialCount=1:sum(Trial.Block<=size(RChoose,2))
        %only use non-error A trials
        if ~ isnan(Trial.Action(trialCount))
            %mark beginning of phase for this trial, phases last 1s
            TimeBeginPhase(1)=Trial.SpPokeCOnTime(trialCount)-1;
            TimeBeginPhase(2)=Trial.SpToneOnTime(trialCount);
            TimeBeginPhase(3)=Trial.SpPokeCOffTime(trialCount)-1;
            %sum of spikes in phase in this trial
            for countPhase=1:3
                countSpikes(countPhase)=sum(UnitTime>TimeBeginPhase(countPhase) & UnitTime<(TimeBeginPhase(countPhase)+1));
            end
            spike_data_basal_ganglia_phase1{i}=[spike_data_basal_ganglia_phase1{i} ;  countSpikes(1)];
            spike_data_basal_ganglia_phase2{i}=[spike_data_basal_ganglia_phase2{i} ;  countSpikes(2)];
            spike_data_basal_ganglia_phase3{i}=[spike_data_basal_ganglia_phase3{i} ;  countSpikes(3)];
        end
    end
end
spike_data_basal_ganglia_all_phases=cell(1,642);
spike_data_basal_ganglia_all_phases(1:214)=spike_data_basal_ganglia_phase1;
spike_data_basal_ganglia_all_phases(215:428)=spike_data_basal_ganglia_phase2;
spike_data_basal_ganglia_all_phases(429:642)=spike_data_basal_ganglia_phase3;
save('basal_ganglia_data','spike_data_basal_ganglia_all_phases','AllQs_basal_ganglia')

