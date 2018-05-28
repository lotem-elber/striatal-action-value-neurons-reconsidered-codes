%{
covariance based plasticity model of Fig 2 - figure supplement 1
this code run 500 simulated sessions of operant learning,in which decisions
are made by the result of a competition between two groups of 1000 neurons
each. 
Firing rates are updated according to the covariance of the noise in the
spiek count with the reward
After each session, action-values are estimated from behavior and the spike
counts of the model are regressed on these estimated action-values
%}
function [regTrial,AllQs_example]=covariance_based_plasticity_annotated()
%measure run time of the code, should take approx. 15 mins
tic;
%num of neurons
N=1000;
%diffusion parameter for the covariance model
eta=0.07;
%number of blocks
numBlocks=4;
%Terminate block after this amount of trials
MaxTrials=200;
%minimum number of trials in block
numStat=20;
%proportion of higher reward chosen needed to end block
prop=2/3;
%time of measurement - this is the length of recording of spike count from
%the firing rate
T=1;
%setup of possible blocks
setup=[0.5 0.5 0.1 0.9; 0.1 0.9 0.5 0.5];
%maximum firing rate
mFR=100;
%Threshold for mean firing rate. If mean firing rate is lower than this threshold in all blocks we will not include the neuron in the
%regression analysis
Thres=1;
%AllQs array to store data from sessions
AllQs=cell(1000,5);
%estAlphaRem and estBetaRem hold the estimates of Estimate_Q of these
%parameters, when creating estimated action-values from choices and rewards, they can be used later to see the histogram of estiamted
%parameters we get from the covariance based plasticity model
estAlphaRem=zeros(500,1);
estBetaRem=zeros(500,1);
%for consistency load seed
load('seedMemCov.mat')
rng(seedMemCov);

%errors - how many times the network was not able to learn
errors=0;
%initializing data about statistical tests -  here we will store t-values of regresion of  neurons from cov. based plasticity model on estimated action-values
regTrial={NaN(500000,1), NaN(500000,1) ; NaN(500000,1) , NaN(500000,1) };
%which stats in regression test
whichstats={'tstat','fstat'};

%experiments=number of trials terminated successfully - preferance (>14/20) towards higher
%choice within maxTrials in every block
experiments=0;
while experiments<500
    %population mean here is determined according to what was
    %done for random walk
    NeurActivityPopMean=ones(2,N)*2.5;
    %storing the entire history of firing rates for the plot in the example
    if experiments==54
    NeurActivityPopMeanForPlot=[NeurActivityPopMean(1,:) NeurActivityPopMean(2,:)];
    end
    % training sessions%%
    
    %NeurActivityForStats - arrays for the activities of
    %neurons for statistical tests    
     NeurActivityForStats={ones(MaxTrials,N,numBlocks)*-1 , ones(MaxTrials,N,numBlocks)*-1};
    % choosing order of blocks, randomly permuting order of blocks based on setup previously chosen
    rPerm=randperm(4);
    %these are the reward probabilities according to the permutation
    RChoose = setup(:,rPerm);
    %NeurActivity is the actual spike count, it is distributed poissonian around the firing rate NeurActivityPopMean, a 100 spikes per
    %second (mFR)is the ceiling for the firing rate
    NeurActivity=min(ones(2,N)*mFR*T,poissrnd(NeurActivityPopMean));
                %NeurActivityForStats stores the spike counts, it will be
                %used later in the regression
                for Group=1:2
                    NeurActivityForStats{Group}(1,:,1)=NeurActivity(Group,:);
                end
                %Noise is needed for learning rule - spike count minus the
                %firing rate
                Noise=NeurActivity-NeurActivityPopMean;
                %choice depends on mean(NeurActivity(1,:)) > mean(NeurActivity(2,:)), and reward (R) for
                %action is stochastic
                choice= mean(NeurActivity(1,:)) > mean(NeurActivity(2,:));
                R=(rand<RChoose(1,1))*(choice(end)==1)+(rand<RChoose(2,1))*(choice(end)==0);
               %after initializing first session we run the loops of all
               %trials in the session
                for k=1:numBlocks
                    %i marks trial number within each block
                    if k==1
                        i=1;
                    else
                        i=0;
                    end
                    %learning continues as until the action with the larger reward is chosen
                    %some proportion of time. Number of trials must be between numStat and MaxTrials
                    while (i<numStat) || sum(choice(max(length(choice)-i+1,length(choice)-numStat+1):end)==(RChoose(1,k)>RChoose(2,k)))<=ceil(numStat*prop) && i<MaxTrials+1;

                        %learning rule - covariance based learning,learning happens
                        %on  the neruons' firing rate
                        NeurActivityPopMean=max(NeurActivityPopMean+eta*R(end).*Noise,zeros(size(NeurActivityPopMean)));
                        %in case this is the example store activity
                        if experiments==54
                        NeurActivityPopMeanForPlot=[NeurActivityPopMeanForPlot ; NeurActivityPopMean(1,:) NeurActivityPopMean(2,:)];
                        end
                        %repeat updating choice, reward and neural activity
                        NeurActivity=min(ones(2,N)*mFR*T,poissrnd(NeurActivityPopMean));
                        Noise=NeurActivity-NeurActivityPopMean;
                        choice=[choice mean(NeurActivity(1,:))>mean(NeurActivity(2,:))];
                        R=[R (rand<RChoose(1,k))*(choice(end)==1)+(rand<RChoose(2,k))*(choice(end)==0)];
                        i=i+1;
                        for Group=1:2
                            NeurActivityForStats{Group}(i,:,k)=NeurActivity(Group,:);
                        end
                    end  
                end
                %---- stats ----%
                %if block terminated without learning in 200 trials exclude day from data
                if sum(NeurActivityForStats{1}(MaxTrials,1,:)>-1)>0
                    errors=errors+1;
                else
        
        %this is another successful session
        experiments=experiments+1;  
        if mod(experiments,50)==0
            disp(['experiment num: ',num2str(experiments)]);
        end

        %call function to estimate action-values from behavior
        [estQ,estAlphaRem(experiments),estBetaRem(experiments)]=Estimate_Q(choice,R,[],[]);
        %store info in AllQs arraw
        AllQs{experiments,1}= estQ;
        AllQs{experiments,2}=RChoose;
        %calculate how many trials until this block
            trialsPerBlock=find(NeurActivityForStats{1}(:,1,1)>-1,1,'last');
                   for j=2:4
                    trialsPerBlock=[trialsPerBlock trialsPerBlock(end)+find(NeurActivityForStats{1}(:,1,j)>-1,1,'last')];
                   end
        AllQs{experiments,3}=trialsPerBlock;
        AllQs{experiments,4}=choice;
        AllQs{experiments,5}=R;
        %this is the example plotted in the paper 
        if experiments==55
            %calculate probability of choosing 1 by running 1000
            %tests for each firing rate in trial
            countForprobChoose=zeros(size(NeurActivityPopMeanForPlot,1),1);
            for timesTest=1:1000
                %randomly draw the spike counts from the firing rates in
                %all trials
                spikesTest=min(ones(size(NeurActivityPopMeanForPlot))*mFR*T,poissrnd(NeurActivityPopMeanForPlot));
                %store the choice for these spike counts
                countForprobChoose(:,timesTest)=sum(spikesTest(:,1:1000),2)>sum(spikesTest(:,1001:2000),2);
            end
            %prob. of choice in each trial depends on the firing rates, and
            %is estimated by the average over the 1000 random draws of
            %spike counts
            probChoose1=mean(countForprobChoose,2);
        end

        %organize data for statistical analysis
        %regression on estimated action-values, extract spike counts from
        %different blocks to one vector of trials in session
        NeurActivityForTrialReg=cell(2);
        
         for group=1:2
                        for k=1:numBlocks
                            NeurActivityForTrialReg{group}=[NeurActivityForTrialReg{group} ; NeurActivityForStats{group}(1:find(NeurActivityForStats{group}(:,1,k)>-1,1,'last'),:,k)];

                        end
         end
                    %store spike counts for example
        if experiments==55
            firingRateForFigCov=NeurActivityPopMeanForPlot;
            spikeCountsForFigCov=[NeurActivityForTrialReg{1} NeurActivityForTrialReg{2}];
        end
  
        %deleting neurons with a below threshold mean firing rate (see
        %Materials and Methods)
        for Group=1:2
            NeurActivityForStats{Group}(NeurActivityForStats{Group}==-1)=NaN;
            BelowThres=nanmean(NeurActivityForStats{Group},1);
            BelowThres=sum(BelowThres>Thres,3)<1;
            NeurActivityForTrialReg{Group}(:,BelowThres)=[];
            
        end

        for Group=1:2

            %regression on Q values learned in Q learning
            for i=1:size(NeurActivityForTrialReg{Group},2)
                rStats=regstats(NeurActivityForTrialReg{Group}(:,i), estQ','linear',whichstats);
                t=rStats.tstat;
                tvalue=t.t;
                regTrial{1,Group}((experiments-1)*N+i)= tvalue(2);
                regTrial{2,Group}((experiments-1)*N+i)= tvalue(3);
            end  
        end  
    end
end

for Group=1:2
    %delete cases where neurons are not used
    regTrial{1,Group}(isnan(regTrial{1,Group}))=[];    
    regTrial{2,Group}(isnan(regTrial{2,Group}))=[];

    
    %trial regression tests
    absRegTrial{1,Group}=abs(regTrial{1,Group})>2;
    absRegTrial{2,Group}=abs(regTrial{2,Group})>2;
    
    absRegTrialValue{1,Group}=((absRegTrial{1,Group}-absRegTrial{2,Group})==1);
    absRegTrialValue{2,Group}=((absRegTrial{2,Group}-absRegTrial{1,Group})==1);
    absRegTrialValue{3,Group}=((absRegTrial{1,Group}+absRegTrial{2,Group})==2);
    
end

%stats Tables

RegTrialStatsTable=zeros(5,2);
for Group=1:2
   %1 - significant regression on estimated action-value 1, 2 - significant regression on estimated action-value 2
   %3 - significant regression on estimated action-value 1 only
   %4 -  significant regression on estimated action-value 2 only
   %5 - significant regression on both estimated action-values 
    RegTrialStatsTable(1,Group)=mean(absRegTrial{1,Group});
    RegTrialStatsTable(2,Group)=mean(absRegTrial{2,Group});
    RegTrialStatsTable(3,Group)=mean(absRegTrialValue{1,Group});
    RegTrialStatsTable(4,Group)=mean(absRegTrialValue{2,Group});
    RegTrialStatsTable(5,Group)=mean(absRegTrialValue{3,Group});
end

%regression by trial

cov_run_finish=toc;
AllQs_example=AllQs(55,:);
AllQs_example{1,6}=spikeCountsForFigCov;
AllQs_example{1,7}=firingRateForFigCov;
AllQs_example{1,8}=probChoose1;








