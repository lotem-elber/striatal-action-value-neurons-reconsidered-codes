function [reg, regTrial, regTrialDetrend,AllQs]=Qlearning_action_value_and_RW(seedMem,numBlocks,maxModulation,beta)
%{
This function simulates 1000 sessions according to the experimental settings described in the paper for figs. 1,2
The learning algorithm, according to which choices are made in each trial, is Q-learning (equations 1 and 2 in the paper)
For each session it simulates 20 random-walk neurons and 20 action-value
neurons according to the description in Materials and Methods
For each session it also estimates the action-values from the behavior (by
calling the function Estimate_Q)
Finally, it regresses the spike counts of the neurons on the estimated
action-values. Neurons are classified as action-value neurons if exactly
one of the two t-values from the regression (the t-value of the intercept is excluded) was larger in absolute value than 2
The analyses of these neurons appear in Figs. 1,2
%}
%number of blocks
if ~exist('numBlocks','var')
    numBlocks=4;
end
if ~exist('maxModulation','var')
    maxModulation=2.35;
end

%alpha & beta are parameters in the Qlearning algorithm of value
alpha=0.1;
if ~exist('beta','var')
    beta=2.5;
end
%the maximum number of trials after which a trial is considered to end in
%error. This is only relevant for the case where beta=1, in the 12 blocks
%simulations
maxTrials=500;
%num of random-walk neurons
N=20;
%number of sessions
numExperiments=1000;
%magnitude of fluctuation in raandom-walk neurons
sigma=0.1;
%number of Trial to use in statistical tests with reward probability -
%stationary phase
numStat=20;
%proportion of higher reward chosen needed to end block
prop=2/3;
%time of measurement - translates firing rates into spike counts
T=1;
%setup of possible blocks
setup=[ 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9;...
    0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5 0.1 0.9 0.5 0.5];%variables for estimated alpha and beta
estAlphaRem=[];
estBetaRem=[];
%Mean firing rate below which we will not include the neuron in the
%calculations
Thres=1;


%which stats in regression test
whichstats={'tstat','fstat'};
%initialize data sets that will be filled with regression results
% reg - regression on final values, regTrail - regresion according
%to Qlearning trial by trial

reg=struct('action_value',nan(N*numExperiments,3),'random_walk',nan(N*numExperiments,3));
regTrial=struct('action_value',nan(N*numExperiments,2),'random_walk',nan(N*numExperiments,2));
regTrialDetrend=struct('action_value',nan(N*numExperiments,2),'random_walk',nan(N*numExperiments,2));
%variables for estimated alpha and beta
estAlphaRem=nan(numExperiments,1);
estBetaRem=nan(numExperiments,1);
%here all the information about the sessions will be stored -
%action-values, choice, reward, etc.
AllQs={};
%define seed, so that the simulated neurons will remain the same
%between different runs
rng(seedMem);

experiments=0;
errors=0;
while experiments<numExperiments
    
    
    %initializing Qlearning
    Q=[0.5 ; 0.5];
    %This line is only meant to keep a new version synchronized with
    %the seed in older versions
    NeurInput=randn(1,N);
    %these are the random-walk neurons
    random_walk_firing_rate=ones(1,N)*2.5;
    %save random_walk_firing_rate for the example
    if experiments==342 & numBlocks==4
        random_walk_firing_rate_example=random_walk_firing_rate;
        Pr_choose_1=0.5;
    end
    % training sessions%%
    
    %random_walk_spike_count - arrays for the spike counts of the random
    %walk neurons
    random_walk_spike_count=ones(500,N,numBlocks)*-1;
    
    % choosing order of blocks by randomly permuting order of blocks based on setup previously chosen
    %when we have more than 4 blocks, the 4 blocks are repeated, each time
    %in random permutation
    rPerm=[];
    for countBlocksForPerm=1:round(numBlocks/4)
        rPerm=[rPerm (countBlocksForPerm-1)*4+randperm(4)];
    end
    %these are the reward probabilities for the blocks in the current
    %session
    RChoose = setup(:,rPerm);
    %spike count in 1s is distributed poisson around firing rate
    random_walk_spike_count(1,:,1)=poissrnd(random_walk_firing_rate*T);
    
    
    %choice is softmax on Q(1),Q(2), 1-choose 1 0-choose 2
    %and reward (R) for action is stochastic according to reward schedule
    choice=rand<(1/(1+exp(-beta*(Q(1)-Q(2)))));
    R=(rand<RChoose(1,1))*(choice(end)==1)+(rand<RChoose(2,1))*(choice(end)==0);
    
    for k=1:numBlocks
        
        %i marks trial number within each block - for first block we
        %already have the first trial, otherwise i=0
        if k==1
            i=1;
        else
            i=0;
        end
        
        %Current block continues until the action with the larger reward is chosen
        %some proportion of time. Number of trials must be
        %larger than is required to calculate proportion
        while ((i<numStat) || sum(choice(max(length(choice)-i+1,length(choice)-numStat+1):end)==(RChoose(1,k)>RChoose(2,k)))<=ceil(numStat*prop)) && (i<maxTrials+1)
            %updating value for Qlearning Q1 and Q2 represent the values for the
            %actions. Pr1Qlearning is the probability of choosing 1 according to
            %Qlearning
            if choice(end)
                Q=[Q [(1-alpha)*Q(1,end)+alpha*R(end) ; Q(2,end)]];
            else
                Q=[Q [Q(1,end) ; (1-alpha)*Q(2,end)+alpha*R(end)]];
            end
            
            %add step to random walk: firing rate in new trial, the new firing rate cannot be smaller than 0
            random_walk_firing_rate=max(random_walk_firing_rate+randn(1,N)*sigma,zeros(1,N));
            if experiments==342 & numBlocks==4
                random_walk_firing_rate_example=[random_walk_firing_rate_example ; random_walk_firing_rate];
                Pr_choose_1=[Pr_choose_1 ; (1/(1+exp(-beta*(Q(1,end)-Q(2,end)))))];
            end
            %another trial has passed
             i=i+1;
            %the activity of the random-walk neurons is distributed
            %poisson around the firing rate
            random_walk_spike_count(i,:,k)=poissrnd(random_walk_firing_rate*T);
            %update choice, reward and trial number
            choice=[choice rand<(1/(1+exp(-beta*(Q(1,end)-Q(2,end)))))];
            R=[R (rand<RChoose(1,k))*(choice(end)==1)+(rand<RChoose(2,k))*(choice(end)==0)];

            
        end
        
    end
    %check to see if this experiment terminated successfully - the
    %model learned to prefer the better option within maxTrials in all
    %blocks. If not, do not analyze
    if sum(random_walk_spike_count(maxTrials,1,:)>-1)>0
        errors=errors+1;
    else

        %this is another successful session
        experiments=experiments+1;
        %session is over - now analyses
        % stats
        
        %estimate Q with ML from behavior
        [estQ,estAlphaRem(experiments),estBetaRem(experiments)]=Estimate_Q(choice,R,[],[]);
        %update AllQs array: {session,1} - estimated action-values, {session,2} - the
        %order of blocks given in reward probabilities, {session,3} -
        %number of trials at the end of each block, {session, 4} - choice
        %in each trial, {session,5} - reward given at each trial
        S=size(AllQs,1);
        AllQs{S+1,1}= estQ';
        AllQs{S+1,2}=RChoose;
        trialsPerBlock=find(random_walk_spike_count(:,1,1)>-1,1,'last');
        for j=2:numBlocks
            trialsPerBlock=[trialsPerBlock trialsPerBlock(end)+find(random_walk_spike_count(:,1,j)>-1,1,'last')];
        end
        AllQs{S+1,3}=trialsPerBlock;
        AllQs{S+1,4}=choice;
        AllQs{S+1,5}=R;
        
        %decide on modulation for Q-values
        modulation=rand*maxModulation;
        
        
        
        %initialize random_walk for regressions
        random_walkForTrialReg=[];
        random_walkForRegFinal=[];
        
        %organize data for statistical analysis
        
        for k=1:numBlocks
            random_walkForTrialReg=[random_walkForTrialReg ; random_walk_spike_count(1:find(random_walk_spike_count(:,1,k)>-1,1,'last'),:,k)];
            random_walkForRegFinal=[random_walkForRegFinal ; random_walkForTrialReg(end-19:end,:)];
        end
        
        %deleting neurons with a below threshold mean firing rate in all
        %blocks
        
        random_walk_spike_count(random_walk_spike_count==-1)=NaN;
        BelowThres=nanmean(random_walk_spike_count,1);
        BelowThres=sum(BelowThres>Thres,3)<1;
        random_walkForTrialReg(:,BelowThres)=[];
        random_walkForRegFinal(:,BelowThres)=[];
        
        
        %create action-value neurons, by adding poisson noise to Q-values
        QForTrialReg=[2.5-modulation/2+Q*modulation ; 2.5+modulation/2-Q*modulation ];
        QForTrialReg=poissrnd(QForTrialReg);
        QForStatReg=[];
        %spike counts for stationary phase - regression on reward
        %probability
        for trial=trialsPerBlock
            QForStatReg=[QForStatReg QForTrialReg(:,trial-19:trial)];
        end
        
        %more for AllQs: {session,6} - are the actual action-values,
        %{session,7} - are the action-value neurons, {session,8} - is the modulation of the neurons in this session, {session,9} - are the random-walk neurons
        S=size(AllQs,1);
        AllQs{S,6}=Q';
        AllQs{S,7}=QForTrialReg';
        AllQs{S,8}=modulation;
        AllQs{S,9}=random_walkForTrialReg;
        if experiments==343 & numBlocks==4
            load('action_value_neurons_examples.mat')
            AllQs{S,7}(:,1:2)=action_value_neurons_examples;
            QForTrialReg(1:2,:)=action_value_neurons_examples';
                    QForStatReg=[];
             %spike counts for stationary phase - regression on reward
              %probability
          for trial=trialsPerBlock
                QForStatReg=[QForStatReg QForTrialReg(:,trial-19:trial)];
          end
            AllQs{S,10}=random_walk_firing_rate_example ;
            AllQs{S,11}=Pr_choose_1;
 
        end
        
                        %regressing neural activity on probability setup values and on Q values
        %group1

        regressor=[reshape(ones(numStat,1)*RChoose(1,:),numStat*numBlocks,1) , reshape(ones(numStat,1)*RChoose(2,:),numStat*numBlocks,1)];
        %regression on firing rates at stationary stage on
        %setup probabilities (e.g, 0.5, 0.9) at these
        %stages
        %for action-value
        for i=1:4
            rStats=regstats(QForStatReg(i,:), regressor,'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            reg.action_value((experiments-1)*4+i,:)=[ tvalue(2) , tvalue(3) , f.pval];

        end
        %for random-walk
        for i=1:size(random_walkForRegFinal,2)
            rStats=regstats(random_walkForRegFinal(:,i), regressor,'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
           reg.random_walk((experiments-1)*N+i,:)=[ tvalue(2) , tvalue(3) , f.pval];

        end
        %regression on estimated action-values
        %for action-value neurons
        for i=1:4
            rStats=regstats(QForTrialReg(i,:), estQ','linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            regTrial.action_value((experiments-1)*4+i,:)=[ tvalue(2) , tvalue(3) ];

        end
        %for random-walk
        for i=1:size(random_walkForTrialReg,2)
            rStats=regstats(random_walkForTrialReg(:,i), estQ','linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            regTrial.random_walk((experiments-1)*N+i,:)=[ tvalue(2) , tvalue(3) ];

        end
                %regression for detrending analysis
        for i=1:4
            rStats=regstats(QForTrialReg(i,2:end), [estQ(:,2:end)' (1:length(Q(:,2:end)))' choice(1:end-1)' choice(2:end)'...
                R(1:end-1)' R(2:end)'],'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            regTrialDetrend.action_value((experiments-1)*4+i,:)=[ tvalue(2) , tvalue(3) ];

        end
        %Here for random-walk
        for i=1:size(random_walkForTrialReg,2)
             rStats=regstats(random_walkForTrialReg(2:end,i), [estQ(:,2:end)' (1:length(Q(:,2:end)))' choice(1:end-1)' choice(2:end)'...
                 R(1:end-1)' R(2:end)' ],'linear',whichstats);
            
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            regTrialDetrend.random_walk((experiments-1)*N+i,:)=[ tvalue(2) , tvalue(3) ];
        end
        
        %end of experiments
    end
end
    %we simulated only 4 action-value neurons, this will simulate 16 more
    %in each session, to compare their number with the random-walk number
    load('seedRem16000Neurons.mat')
    rng(seedRem16000Neurons_21_4);
    for num=1:size(AllQs,1)
        estQ=AllQs{num,1};
        RChoose=AllQs{num,2};
        trialsPerBlock=AllQs{num,3};
        choice=AllQs{num,4};
        R=AllQs{num,5};
        Q=AllQs{num,6};
        modulation=AllQs{num,8};
        
        QFiringRate=[2.5-modulation/2+Q*modulation  2.5+modulation/2-Q*modulation ];
        
        for repeatsAnalysis=1:4
            QForTrialReg=poissrnd(QFiringRate');
            QForTrialReg=QForTrialReg';
            AllQs{num,7}=[AllQs{num,7}  QForTrialReg];
            for i=1:4
                %regression on estimated Q
                rStats=regstats(QForTrialReg(:,i), estQ,'linear',whichstats);
                t=rStats.tstat;
                f=rStats.fstat;
                tvalue=t.t;
                 regTrial.action_value(4000+(num-1)*16+(repeatsAnalysis-1)*4+i,:)=[ tvalue(2) , tvalue(3) ];

            end
        end
    end

  reg.action_value(isnan(reg.action_value(:,1)),:)=[];    
  regTrial.action_value(isnan(regTrial.action_value(:,1)),:)=[];  
  regTrialDetrend.action_value(isnan(regTrialDetrend.action_value(:,1)),:)=[];
   reg.random_walk(isnan(reg.random_walk(:,1)),:)=[];    
  regTrial.random_walk(isnan(regTrial.random_walk(:,1)),:)=[];  
  regTrialDetrend.random_walk(isnan(regTrialDetrend.random_walk(:,1)),:)=[];
end

    
    
    
    
    
    
    
    
