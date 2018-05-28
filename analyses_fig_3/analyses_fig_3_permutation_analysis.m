
%test possible solution - permutation analysis
%test on Q-values
close all
clear all
%if script is run from its folder 'analyses_fig_3' add main folder and all its subfolders to path
 [folder_path folder]=fileparts(pwd);
 if isequal(folder,'analyses_fig_3')
      addpath(genpath(folder_path));
 else
    disp('current path not in "analyses_fig_3" folder');
 end
%run permutation analysis for fig 3
 load('seedMem_for_figs_1_and_2.mat')
[~,~,~,AllQs]=Qlearning_action_value_and_RW(seedMem);
whichstats={'tstat','fstat'};
tvaluesRealQ=[];
pValues=[];
minLength=170;
num_neurons=20;


AllQs_long=AllQs;
for i=size(AllQs_long,1):-1:1
    if length(AllQs_long{i,1})<minLength
        AllQs_long(i,:)=[];
    end
end

tvaluesRealQ=NaN(size(AllQs_long,1)*num_neurons,2);
pValues=NaN(size(AllQs_long,1)*num_neurons,2);
for i=1:size(AllQs_long,1)
    i
    %
         spikeCount=AllQs_long{i,7};
         estQ=AllQs_long{i,1};

    for ValNum=1:num_neurons
        
        rStats=regstats(spikeCount(1:minLength,ValNum), estQ(1:minLength,:),'linear',whichstats);
        
        t=rStats.tstat;
        tvalue=t.t;
        
        tvaluesRealQ((i-1)*num_neurons+ValNum,:)=[ tvalue(2) tvalue(3)];
        tvaluesPermutations=NaN(size(AllQs_long,1)*2,1);
        for permutations=1:size(AllQs_long,1)
            estQForPermute=AllQs_long{permutations,1};
            
            rStats=regstats(spikeCount(1:minLength,ValNum), estQForPermute(1:minLength,:),'linear',whichstats);
            
            t=rStats.tstat;
            tvalue=t.t;
            
            tvaluesPermutations([permutations*2-1 , permutations*2] )=[tvalue(2) ; tvalue(3)];
            
        end
        tvaluesPermutations=sort(abs(tvaluesPermutations),1,'descend');
        %to prevent a case where the two t-values from the original
        %session compete for the high rank in the sorting, each is
        %compared to the list of t-values without the other
        tvaluesPermutationsForQ1=tvaluesPermutations;
        tvaluesPermutationsForQ1(tvaluesPermutationsForQ1==abs(tvaluesRealQ((i-1)*num_neurons+ValNum,2)))=[];
        tvaluesPermutationsForQ2=tvaluesPermutations;
        tvaluesPermutationsForQ2(tvaluesPermutationsForQ2==abs(tvaluesRealQ((i-1)*num_neurons+ValNum,1)))=[];
        %find the rank of the real t-values in the t-values list
        t1Loc=find(abs(tvaluesRealQ((i-1)*num_neurons+ValNum,1))==tvaluesPermutationsForQ1);
        t2Loc=find(abs(tvaluesRealQ((i-1)*num_neurons+ValNum,2))==tvaluesPermutationsForQ2);

        
        pValues((i-1)*num_neurons+ValNum,:)=[ t1Loc/size(tvaluesPermutations,1),...
           t2Loc/size(tvaluesPermutations,1)];
    end
end
mean(pValues<0.05)
ValueNeuronsValue=[mean(pValues(:,1)<0.05 & pValues(:,2)>0.05)...
    mean(pValues(:,1)>0.05 & pValues(:,2)<0.05)...
    mean(pValues(:,1)<0.05 & pValues(:,2)<0.05 & sign(tvaluesRealQ(:,1))==sign(tvaluesRealQ(:,2)))...
    mean(pValues(:,1)<0.05 & pValues(:,2)<0.05 & sign(tvaluesRealQ(:,1))~=sign(tvaluesRealQ(:,2)))...
    mean(pValues(:,1)>0.05 & pValues(:,2)>0.05)]
tvaluesPerm=tinv(pValues/2,149).*sign(tvaluesRealQ);
%%
%test permutation of value on random walk
whichstats={'tstat','fstat'};
pValues=[];
tvaluesRealQ=[];
minLength=170;

AllQs_long=AllQs;
for i=size(AllQs_long,1):-1:1
    if length(AllQs_long{i,1})<minLength
        AllQs_long(i,:)=[];
    end
end


for i=1:size(AllQs_long,1)
    i
    spikeCount=AllQs_long{i,9};
    estQ=AllQs_long{i,1};
    for ValNum=1:size(spikeCount,2)
        rStats=regstats(spikeCount(1:minLength,ValNum), estQ(1:minLength,:),'linear',whichstats);
        
        t=rStats.tstat;
        tvalue=t.t;
        
        tvaluesRealQ=[  tvaluesRealQ ; tvalue(2) tvalue(3)];
        tvaluesPermutations=[];
        for permutations=1:size(AllQs_long,1)
            estQPermutations=AllQs_long{permutations,1};
            
            rStats=regstats(spikeCount(1:minLength,ValNum), estQPermutations(1:minLength,:),'linear',whichstats);
            
            t=rStats.tstat;
            tvalue=t.t;
            
            tvaluesPermutations=[tvaluesPermutations ; tvalue(2) ; tvalue(3)];
            
        end
        tvaluesPermutations=sort(abs(tvaluesPermutations),1,'descend');
        
         %to prevent a case where the two t-values from the original
        %session compete for the high rank in the sorting, each is
        %compared to the list of t-values without the other
        tvaluesPermutationsForQ1=tvaluesPermutations;
        tvaluesPermutationsForQ1(tvaluesPermutationsForQ1==abs(tvaluesRealQ(end,2)))=[];
        tvaluesPermutationsForQ2=tvaluesPermutations;
        tvaluesPermutationsForQ2(tvaluesPermutationsForQ2==abs(tvaluesRealQ(end,1)))=[];
        %find the rank of the real t-values in the t-values list
        t1Loc=find(abs(tvaluesRealQ(end,1))==tvaluesPermutationsForQ1);
        t2Loc=find(abs(tvaluesRealQ(end,2))==tvaluesPermutationsForQ2);

        
        pValues=[pValues ; t1Loc/size(tvaluesPermutations,1),...
           t2Loc/size(tvaluesPermutations,1)];
    end
end
mean(pValues<0.05)
ValueNeuronsRW=[mean(pValues(:,1)<0.05 & pValues(:,2)>0.05)...
    mean(pValues(:,1)>0.05 & pValues(:,2)<0.05)...
    mean(pValues(:,1)<0.05 & pValues(:,2)<0.05 & sign(tvaluesRealQ(:,1))==sign(tvaluesRealQ(:,2)))...
    mean(pValues(:,1)<0.05 & pValues(:,2)<0.05 & sign(tvaluesRealQ(:,1))~=sign(tvaluesRealQ(:,2)))...
    mean(pValues(:,1)>0.05 & pValues(:,2)>0.05)]
tvaluesPermRW=tinv(pValues/2,147).*sign(tvaluesRealQ);

%%
%possible solutions on Motor cortex data
load('motor_cortex_spike_data.mat')
 [pValues] = permutation_analysis_motor_auditory_cortex(AllQs_long,motor_cortex_spike_data);
 ValueNeuronsMotor=[mean(pValues(:,1)<0.05 & pValues(:,2)>0.05)...
    mean(pValues(:,1)>0.05 & pValues(:,2)<0.05)...
    mean(pValues(:,1)<0.05 & pValues(:,2)<0.05)...
    mean(pValues(:,1)>0.05 & pValues(:,2)>0.05)]
 
%% 
%possible solutions on auditory cortex data 
load('auditory_cortex_spike_data.mat')
spikeDataRes(:,[117 118])=[];
[pValues] = permutation_analysis_motor_auditory_cortex(AllQs_long,spikeDataRes);
ValueNeuronsAuditory=[mean(pValues(:,1)<0.05 & pValues(:,2)>0.05)...
    mean(pValues(:,1)>0.05 & pValues(:,2)<0.05)...
    mean(pValues(:,1)<0.05 & pValues(:,2)<0.05)...
    mean(pValues(:,1)>0.05 & pValues(:,2)>0.05)]


%%
%Create array of unique estimated Q-values so that Q-values will not be
%used twice for the permutation analyses
%vector of unique estimated Qs
load('basal_ganglia_data.mat');
whichstats={'tstat','fstat'};
AllQs_basal_ganglia_estQs_unique=cell(0);


for ii=1:size(AllQs_basal_ganglia,1)
    
    estQ_Vec=AllQs_basal_ganglia{ii,1};

    alreadyQ=0;
    for j=1:size(AllQs_basal_ganglia_estQs_unique,1)
        if isequal(estQ_Vec,AllQs_basal_ganglia_estQs_unique{j,1})
            alreadyQ=1;
            
        end
    end
    if alreadyQ==0
        AllQs_basal_ganglia_estQs_unique(size(AllQs_basal_ganglia_estQs_unique,1)+1,:)=AllQs_basal_ganglia(ii,:);
    end
end


%%

%possible solution - permutation analysis on estimated Q-values

%sesssions organized in the same order as spike data
AllQs_for_analysis=AllQs_basal_ganglia;
%for permutation to prevent estimated Qs used more than once, we use this
%array in which every session from recordings appears only once 
Data_for_permutation=AllQs_basal_ganglia_estQs_unique';
tvaluesRealQ=[];
pValues=[];
%this is the shortest session, to allow comparison between different
%estimated Qs, all data is shortened to this amount of trials
minLength=332;
neurons_per_epoch=214;

for epoch=1:3
    %spike data for 214 different neurons arranged in cell array, in each
    %epoch
  data_for_analysis=spike_data_basal_ganglia_all_phases(((epoch-1)*neurons_per_epoch+1):epoch*neurons_per_epoch);  
for ii=1:length(data_for_analysis)
    
    %choose current spike data
    spikeCount=data_for_analysis{ii};
    %get its corresponding estimated Q
    estQ=AllQs_for_analysis{ii,1};
    
    
    %regression of spike count on its corresponding estimated Q
    rStats=regstats(spikeCount(1:minLength), estQ(:,1:minLength)','linear',whichstats);
    
    t=rStats.tstat;
    tvalue=t.t;
    
    tvaluesRealQ=[tvaluesRealQ ; tvalue(2) tvalue(3)];
    %rarely, because of low spike count at the begining of a session we
    %get a nan result here
    if ~isnan(tvaluesRealQ(end,1))
        tvaluesPermutations=[];
        for permutations=1:size(Data_for_permutation,2)
            %get estimated Q, each time from a different session (for one regression
            %the estimated Q will be the one corresponding to the spike count, and thus equal to estQ) 
            estQForPermute=Data_for_permutation{1,permutations};
            %regress spike count on this estimated Q (from a different
            %session)
            rStats=regstats(spikeCount(1:minLength)', estQForPermute(:,1:minLength)','linear',whichstats);
            
            t=rStats.tstat;
            tvalue=t.t;
            
            tvaluesPermutations=[tvaluesPermutations ; tvalue(2) ; tvalue(3)];
            
        end
        tvaluesPermutations=sort(abs(tvaluesPermutations),1,'descend');
        %to prevent a case where the two t-values from the original
        %session compete for the high rank in the sorting, each is
        %compared to the list of t-values without the other
        tvaluesPermutationsForQ1=tvaluesPermutations;
        tvaluesPermutationsForQ1(tvaluesPermutationsForQ1==abs(tvaluesRealQ(end,2)))=[];
        tvaluesPermutationsForQ2=tvaluesPermutations;
        tvaluesPermutationsForQ2(tvaluesPermutationsForQ2==abs(tvaluesRealQ(end,1)))=[];
        %find the rank of the real t-values in the t-values list
        t1Loc=find(abs(tvaluesRealQ(end,1))==tvaluesPermutationsForQ1);
        t2Loc=find(abs(tvaluesRealQ(end,2))==tvaluesPermutationsForQ2);
        
       % the p-value for each neron is its rank divided by number of
        %samples - what fraction of surrogate reward probabilities got
        %higher t-values
        pValues=[pValues ; (t1Loc)/size(tvaluesPermutationsForQ1,1),...
            (t2Loc)/size(tvaluesPermutationsForQ2,1)];
        
    end
end
end
tvaluesRealQ(isnan(tvaluesRealQ(:,1)),:)=[];
%calculate neuron types for the permutation analysis 
%                        - [value-left (only value-left passed significance test)...
%                              value-right (only value-right passed significance test)...
%                           both values passed significance test...
%                           non of the values passed significance test]
alpha=0.01;
mean(pValues<alpha)
ValueNeurons_basal_ganglia_PermutationAnalysis=[mean(pValues(:,1)<alpha & pValues(:,2)>alpha)...
    mean(pValues(:,1)>alpha & pValues(:,2)<alpha)...
    mean(pValues(:,1)<alpha & pValues(:,2)<alpha & sign(tvaluesRealQ(:,1))==sign(tvaluesRealQ(:,2))) ...    
    mean(pValues(:,1)<alpha & pValues(:,2)<alpha & sign(tvaluesRealQ(:,1))~=sign(tvaluesRealQ(:,2))) ...
    mean(pValues(:,1)>alpha & pValues(:,2)>alpha)]

% calculate neuron types for the regular analysis
%note that this regression employs only the first 332 so that we will be
%able to compare the different action-values, and therefore yields
%different results from Fig. 3 - Fig. supplement 1
 abstvalues=tvaluesRealQ;
    abstvalues=(abs(abstvalues))>2.64;
    tLeft=(abstvalues(:,1)-abstvalues(:,2))==1;
    tRight=(abstvalues(:,2)-abstvalues(:,1))==1;
    tBoth=(abstvalues(:,2)+abstvalues(:,1))==2;
    tNone=(abstvalues(:,2)+abstvalues(:,1))==0;
    ValueNeuronsEstimatedQs=[ nanmean(tLeft) nanmean(tRight) nanmean(tBoth) nanmean(tNone)]
%%

%possible solution - permutation analysis on reward probabilities

%sesssions organized in the same order as spike data
AllQs_for_analysis=AllQs_basal_ganglia;

tvaluesRealQ=[];
pValues=[];
%go over all neurons 
for epoch=1:3
  data_for_analysis=spike_data_basal_ganglia_all_phases(((epoch-1)*neurons_per_epoch+1):epoch*neurons_per_epoch);  
for ii=1:length(data_for_analysis)
 
    %
    spikeCount=data_for_analysis{ii};
    
    estQ=AllQs_for_analysis{ii,1};
    RChoose=AllQs_for_analysis{ii,2};
    trialsPerBlock=AllQs_for_analysis{ii,3};
    
    regressor1=[];
    regressor2=[];
    for columnRChoose=1:size(RChoose,2)
        regressor1=[regressor1 ; ones(20,1)*RChoose(1,columnRChoose)];
        regressor2=[regressor2 ; ones(20,1)*RChoose(2,columnRChoose)];
    end
    trialsForReg=[];
    for blocksCount=1:size(RChoose,2)
        trialsForReg=[trialsForReg trialsPerBlock(blocksCount)-19:trialsPerBlock(blocksCount)];
    end
    rStats=regstats(spikeCount(trialsForReg), [regressor1 regressor2],'linear',whichstats);
    t=rStats.tstat;
    tvalue=t.t;
    tvaluesRealQ=[tvaluesRealQ ; tvalue(2) tvalue(3)];
    %rarely, because of low spike count at the begining of a session we
    %get a nan result here
    if ~isnan(tvaluesRealQ(end,1))
        tvaluesPermutations=[];
       permutations=1;
       while permutations<500
           %permute original reward probabilities
            RChooseForPermute=RChoose(:,randperm(size(RChoose,2)));
            %get random trials to mark begining of stationary phase for
            %each block - random numbers from uniform distribution between
            %21 and (trials in session-1)
            trialsPerBlockForPermute=20+sort(ceil(rand(1,size(RChoose,2))*(trialsPerBlock(end)-21)));
            %if there are two numbers with less then 20 trials between
            %them, get new random numbers - so regression does not contain
            %the same trial twice
            %also, if we accidentally got the numbers from the actual
            %regression - do permutation again
            while sum((trialsPerBlockForPermute(2:end)-trialsPerBlockForPermute(1:end-1))<20)>1 ...
                | trialsPerBlockForPermute==trialsPerBlock
                Only_Blocks_to_Change=find((trialsPerBlockForPermute(2:end)-trialsPerBlockForPermute(1:end-1))<20);
                if trialsPerBlockForPermute==trialsPerBlock
                    Only_Blocks_to_Change=1:length(trialsPerBlockForPermute);
                end
                trialsPerBlockForPermute(Only_Blocks_to_Change)=20+ceil(rand(1,size(Only_Blocks_to_Change,2))*(trialsPerBlock(end)-21));
                trialsPerBlockForPermute=sort(trialsPerBlockForPermute);
                 
            end
            %build regressor for permutation regression
            regressor1=[];
            regressor2=[];
            for columnRChoose=1:size(RChooseForPermute,2)
                regressor1=[regressor1 ; ones(20,1)*RChooseForPermute(1,columnRChoose)];
                regressor2=[regressor2 ; ones(20,1)*RChooseForPermute(2,columnRChoose)];
            end
            trialsForReg=[];
            for blocksCount=1:size(trialsPerBlockForPermute,2)
                trialsForReg=[trialsForReg trialsPerBlockForPermute(blocksCount)-19:trialsPerBlockForPermute(blocksCount)];
            end
            %regression on surrogate reward probability
            rStats=regstats(spikeCount(trialsForReg), [regressor1 regressor2],'linear',whichstats);
            
            t=rStats.tstat;
            tvalue=t.t;
            %if result in a number add it to list, otherwise keep trying
            if ~isnan(tvalue(2)) 
             tvaluesPermutations=[tvaluesPermutations ; tvalue(2) ; tvalue(3)];
             permutations=permutations+1;
            end
       end
       %add real t-value to list to permuted t-values
        tvaluesPermutations=[tvaluesPermutations ; tvaluesRealQ(end,1) ; tvaluesRealQ(end,2)];
        tvaluesPermutations=sort(abs(tvaluesPermutations),1,'descend');
        %to prevent a case where the two t-values from the original
        %session compete for the high rank i? the sorting, each is
        %compared to the list of t-values without the other
        tvaluesPermutationsForQ1=tvaluesPermutations ;
        tvaluesPermutationsForQ1(tvaluesPermutationsForQ1==abs(tvaluesRealQ(end,2)))=[];
        tvaluesPermutationsForQ2=tvaluesPermutations;
        tvaluesPermutationsForQ2(tvaluesPermutationsForQ2==abs(tvaluesRealQ(end,1)))=[];
        %find the rank of the real t-values in the t-values list
        t1Loc=find(abs(tvaluesRealQ(end,1))==tvaluesPermutationsForQ1,1);
        t2Loc=find(abs(tvaluesRealQ(end,2))==tvaluesPermutationsForQ2,1);
        
        %the p-value for each neron is its rank divided by number of
        %samples - what fraction of surrogate reward probabilities got
        %higher t-values
        pValues=[pValues ; (t1Loc)/size(tvaluesPermutationsForQ1,1),...
            (t2Loc)/size(tvaluesPermutationsForQ2,1)];
        
    end
end
end
alpha=0.01;
%calculate neuron types for the permutation analysis 
%                        - [value-left (only value-left passed significance test)...
%                              value-right (only value-right passed significance test)...
%                           both values passed significance test...
%                           non of the values passed significance test]

mean(pValues<alpha)
ValueNeuron_basal_ganglia_sPermutationAnalysis_on_reward_probs=[mean(pValues(:,1)<alpha & pValues(:,2)>alpha)...
    mean(pValues(:,1)>alpha & pValues(:,2)<alpha)...
    mean(pValues(:,1)<alpha & pValues(:,2)<alpha)...
    mean(pValues(:,1)>alpha & pValues(:,2)>alpha)]

% calculate neuron types for the regular analysis
 abstvalues=tvaluesRealQ;
    abstvalues=(abs(abstvalues))>2.64;
    tLeft=(abstvalues(:,1)-abstvalues(:,2))==1;
    tRight=(abstvalues(:,2)-abstvalues(:,1))==1;
    tBoth=(abstvalues(:,2)+abstvalues(:,1))==2;
    tNone=(abstvalues(:,2)+abstvalues(:,1))==0;
    ValueNeurons=[ nanmean(tLeft) nanmean(tRight) nanmean(tBoth) nanmean(tNone)]
