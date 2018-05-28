function [regOnPolicyState_policy]=direct_policy_trial_design_for_fig_6()
lastwarn('');
%num of random-walk neurons
N=20;
experiment_length=400;
analysis_starts=201;
%
alpha=0.17;
beta=1;
VecSigma=[0.1];
maxModulation=3;
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
% reg_policy - regression on final values,regOnPolicyState_policy - regresion on
% policy and state

reg_policy=nan(N*numExperiments,3);
regOnPolicyState_policy=nan(N*numExperiments,3);
%variables for correlation with trend and frequency of random-walk getting
%to boundaries
numNonStat=zeros(size(VecSigma));
numNonStatValue=zeros(size(VecSigma));
zeroTouch=zeros(size(VecSigma));
touch100=zeros(size(VecSigma));
%variables for estimated alpha and beta
estAlphaRem=[];
estBetaRem=[];
%here all the information about the sessions will be stored -
%action-values, choice, reward, etc.
AllQs={};

load('seedMem_for_figs_1_and_2.mat')
rng(seedMem);

plotDone=0;

    %alpha & beta are parameters in the Qlearning algorithm of value
    
    
    experiments=0;
            RChoose = setup;
    %count how many trials in a session
    %measure of number of trials in each session
    trials_in_session=[];
    while experiments<numExperiments
        %countSuccess
        experiments=experiments+1;
        %initializing Qlearning

        %probability of choosing left
        Pr1_W_4blocks=cell(4);
        for n_for_Pr1=1:4
          Pr1_W_4blocks{n_for_Pr1}=[0 0.5]; 
        end
        Pr1Direct_Policy=[];

        % training sessions%%
        Trial_order=[];
           for trials=1:experiment_length
        %these are the reward probabilities for the blocks in the current
        %session

        rPerm=randperm(4);
        current_trial=rPerm(1);
        Trial_order=[Trial_order  RChoose(:,current_trial)];
        %spike count in 1s is distributed poisson around firing rate
 
        %choice is softmax on Q(1),Q(2), 1-choose 1 0-choose 2
        %and reward (R) for action is stochastic according to reward schedule
        Pr1Direct_Policy=[Pr1Direct_Policy Pr1_W_4blocks{current_trial}(end,2)];
        choice=rand<Pr1Direct_Policy;
        R=(rand<RChoose(1,current_trial))*(choice(end)==1)+(rand<RChoose(2,current_trial))*(choice(end)==0);
        
               W=Pr1_W_4blocks{current_trial}(end,1);
               W=W+alpha*(R(end)*2-1)*(choice(end)-Pr1Direct_Policy(end));
               Pr1_W_4blocks{current_trial}=[Pr1_W_4blocks{current_trial} ; W 1/(1+exp(-W*beta))];

      
            
        end
        
        %session is over - now analyses
        % stats
 
        S=size(AllQs,1);
        AllQs{S+1,1}= Pr1Direct_Policy';
        AllQs{S+1,2}=Trial_order;

        AllQs{S+1,4}=choice;
        AllQs{S+1,5}=R;
      %  trials_in_session=[trials_in_session trialsPerBlock(end)];
        
        
        %decide on modulation for Q-values
        modulation=rand*maxModulation;
   
        %initialize neurActivity for regressions Reg- reward probability
        %RegTrial - regression on estimated Q-values
        NeurActivityForRegFinal=[];
        NeurActivityForTrialReg=[];
  

        %create policy neurons, by adding poisson noise to Q-values
        choiceForTrialReg=repmat([2.5-modulation/2+Pr1Direct_Policy*modulation ; 2.5+modulation/2-Pr1Direct_Policy*modulation],10,1);
        AllQs{S+1,7}=choiceForTrialReg;
        choiceForTrialReg=poissrnd(choiceForTrialReg);
        AllQs{S+1,8}=choiceForTrialReg;
        choiceForStatReg=[];

        AllQs{S+1,9}=modulation;
 

        %regression on reward probabilities after learning
        for i=1:20
            rStats=regstats(choiceForTrialReg(i,analysis_starts:end), Trial_order(:,analysis_starts:end)','linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            reg_policy((experiments-1)*N+i,:)=[tvalue(2) ,  tvalue(3) , f.pval];

        end
        
        %regression on policy and state
               
        for i=1:20
         
            rStats=regstats(choiceForTrialReg(i,analysis_starts:end), [Trial_order(1,analysis_starts:end)'+Trial_order(2,analysis_starts:end)'...
              Trial_order(1,analysis_starts:end)'-Trial_order(2,analysis_starts:end)'],'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            regOnPolicyState_policy((experiments-1)*N+i,:)=[tvalue(2) ,  tvalue(3) , f.pval];
            
        end
               
        %end of experiments
    end
    reg_policy(isnan(reg_policy(:,1)),:)=[];
    regOnPolicyState_policy(isnan(regOnPolicyState_policy(:,1)),:)=[];
end
  











