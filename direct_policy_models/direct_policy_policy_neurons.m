%{
This script simulates 1000 sessions according to the experimental settings described in the paper for fig. 5
The learning algorithm, according to which choices are made in each trial,
is REINFORCE(Williams, 1992). It is described in the section 'Policy without action-value representation' 
For each session the script simulates 20 policy neurons and 20 random-walk
neurons according to the description in Materials and Methods (the simulation of random-walk neurons is for historic reasons,
they are not analyzed in the paper)
For each session it also calculates the action-values from the behavior (by
calling the function Estimate_Q). Note that in this case there is no
representation of action-value in the learning algorithm.
Finally, it regresses the spike counts of the policy neurons on the
calculated action-values. Neurons are classified as action-value neurons if exactly
one of the two t-values from the regression (the t-value of the intercept is excluded) was larger in absolute value than 2
The analyses of these neurons appear in Fig. 5
%}

function [reg_policy, regTrial_policy , regChoiceInReg_policy , AllQs]=direct_policy_policy_neurons()
%num of policy neurons
N=20;
%paramer in the direct policy model
alpha=0.17;
%drift paramer for random-walk
sigma=0.1;
%maximum modulation
maxModulation=3;
%number of experimental sessions
numExperiments=1000;
%number of blocks
numBlocks=4;
%number of Trial to use in statistical tests with reward probability -
%stationary phase
numStat=20;
%proportion of higher reward chosen needed to end block
prop=2/3;
%time of measurement - translates firing rates into spike counts
T=1;
%setup of possible blocks
setup=[0.5 0.5 0.1 0.9; 0.1 0.9 0.5 0.5];

%Mean firing rate below which we will not include the neuron in the
%calculations
Thres=1;

%which stats in regression test
whichstats={'tstat','fstat'};
%initialize data sets that will be filled with regression results
%regression on estimated action-values
regTrial_policy=nan(N*numExperiments,3);
%regression on reward probabilities
reg_policy=nan(N*numExperiments,3);
%regressin on estimated action-values, including choice in the regression
regChoiceInReg_policy=nan(N*numExperiments,3);
%variables for estimated alpha and beta
estAlphaRem=[];
estBetaRem=[];
%here all the information about the sessions will be stored -
%action-values, choice, reward, etc.
AllQs={};
%load and define seed, so that the simulated neurons will remain the same
%between different runs
load('seedMem_for_figs_1_and_2.mat')
rng(seedMem);
%count number of trials in session
trials_in_session=[];
    experiments=0;
    while experiments<numExperiments

        experiments=experiments+1;
        %initializing variable in direct policy alrogithm
        W=0;
        %probability of choosing 1
        Pr1Direct_Policy=0.5;
        %This line is only meant to keep a new version synchronized with
        %the seed in older versions
        NeurInput=randn(1,N);
        %these are the random-walk neurons
        NeurActivityPopMean=ones(1,N)*2.5;


        % training sessions%%
       
        %NeurActivityForStats - arrays for the activities of
        %neurons for statistical tests
        NeurActivityForStats=ones(500,N,numBlocks)*-1;
        
        % choosing order of blocks, under normal conditions this
        % will mean randomly permuting order of blocks based on setup previously chosen
        rPerm=randperm(4);
        %these are the reward probabilities for the blocks in the current
        %session
        RChoose = setup(:,rPerm);
        %spike count in 1s is distributed poisson around firing rate
        NeurActivity=poissrnd(NeurActivityPopMean*T);
        NeurActivityForStats(1,:,1)=NeurActivity;
        
        %choice is softmax on Q(1),Q(2), 1-choose 1 0-choose 2
        %and reward (R) for action is stochastic according to reward schedule
        choice=rand<Pr1Direct_Policy;
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
            %larger than is required to calculate proprtion
            
            while (i<numStat) || sum(choice(max(length(choice)-i+1,length(choice)-numStat+1):end)==(RChoose(1,k)>RChoose(2,k)))<=ceil(numStat*prop)
                %updating variables in direct policy algorithm.
                %Pr1Direct_Policy is the probability of choosing 1, W is
                %another variable in this algorithm

               W=W+alpha*(R(end)*2-1)*(choice(end)-Pr1Direct_Policy(end));
               Pr1Direct_Policy=[Pr1Direct_Policy 1/(1+exp(-W))];

                              %add step to random walk
                NeurActivityPopMean=max(NeurActivityPopMean+randn(1,N)*sigma,zeros(1,N));
                NeurActivity=poissrnd(NeurActivityPopMean*T);
                %update choice, reward and trial number
                choice=[choice rand<Pr1Direct_Policy(end)];
                R=[R (rand<RChoose(1,k))*(choice(end)==1)+(rand<RChoose(2,k))*(choice(end)==0)];
                i=i+1;
                NeurActivityForStats(i,:,k)=NeurActivity;
            end
            
        end
        
        %session is over - now analyses
        % stats
        [estQ,estAlphaRem,estBetaRem]=Estimate_Q(choice,R,estAlphaRem,estBetaRem);
        %update AllQs array: {session,1} -Probability of choice according to direct policy algorithm, {session,2} - the
        %order of blocks given in reward probabilities, {session,3} -
        %number of trials at the end of each block, {session, 4} - choice
        %in each trial, {session,5} - reward given at each trial, {session,
        %6} - the action-values that were calculated from behavior
        %(although note that there is no action-value in the learning
        %algorithm)
        S=size(AllQs,1);
        AllQs{S+1,1}= Pr1Direct_Policy';
        AllQs{S+1,2}=RChoose;
        trialsPerBlock=find(NeurActivityForStats(:,1,1)>-1,1,'last');
        for j=2:4
            trialsPerBlock=[trialsPerBlock trialsPerBlock(end)+find(NeurActivityForStats(:,1,j)>-1,1,'last')];
        end
        AllQs{S+1,3}=trialsPerBlock;
        AllQs{S+1,4}=choice;
        AllQs{S+1,5}=R;
        AllQs{S+1,6}=estQ;
        trials_in_session=[trials_in_session trialsPerBlock(end)];
        
        
        %decide on modulation for policy neurons
        modulation=rand*maxModulation;

        %create policy neurons, by adding poisson noise to probability of
        %choice
        policyForTrialReg=repmat([2.5-modulation/2+Pr1Direct_Policy*modulation ; 2.5+modulation/2-Pr1Direct_Policy*modulation],10,1);
       
         %more for AllQs: {session,7} - are the firing rates of the policy
         %neurons, {session,8} - are the spike counts of the policy
         %neurons, {session, 9} -  is the modulation
        AllQs{S+1,7}=policyForTrialReg;
        policyForTrialReg=poissrnd(policyForTrialReg);
        AllQs{S+1,8}=policyForTrialReg;      
        AllQs{S+1,9}=modulation;

        %regression on firing rates at stationary stage on
        %setup probabilities (e.g, 0.5, 0.9) at these
        %stages 
         trials_for_reg_reward_prob=reshape(repmat(trialsPerBlock,numStat,1)-repmat((numStat-1:-1:0)',1,numBlocks),numStat*numBlocks,1);
        policyForReg=policyForTrialReg(:,trials_for_reg_reward_prob);
        regressor=[reshape(ones(numStat,1)*RChoose(1,:),numStat*numBlocks,1) , reshape(ones(numStat,1)*RChoose(2,:),numStat*numBlocks,1)];
        for i=1:N
            rStats=regstats(policyForReg(i,:), regressor,'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            reg_policy((experiments-1)*N+i,:)=[ tvalue(2) , tvalue(3) , f.pval];

        end
        %regression on estimated action-values
        %for policy neurons
        for i=1:N
            rStats=regstats(policyForTrialReg(i,:), estQ','linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
           regTrial_policy((experiments-1)*N+i,:)=[  tvalue(2) , tvalue(3) , f.pval];

        end
        
        %regression on estimated action-values including choice in
        %regression
        %for policy neurons
        for i=1:N
            rStats=regstats(policyForTrialReg(i,:), [estQ' choice'],'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
           regChoiceInReg_policy((experiments-1)*N+i,:)=[  tvalue(2) , tvalue(3) , f.pval];

        end

        %end of experiments
    end
 reg_policy(isnan(reg_policy(:,1)),:)=[]; 
regTrial_policy(isnan(regTrial_policy(:,1)),:)=[];
regChoiceInReg_policy(isnan(regChoiceInReg_policy(:,1)),:)=[];
end
    










