function [reg , regOnPolicyState , AllQs]=Qlearning_action_value_and_RW_trial_design_for_fig_4_and_6()

lastwarn('');
%num of random-walk neurons
N=20;
%run experimental session for this many trials
experiment_length=400;
%
analysis_starts=201;
%
alpha=0.1;
beta=2.5;
VecSigma=[0.1];
maxModulation=2.35;
%time of measurement - translates firing rates into spike counts
T=1;
%setup of possible blocks
setup=[0.5 0.5 0.1 0.9; 0.1 0.9 0.5 0.5];

%Mean firing rate below which we will not include the neuron in the
%calculations
Thres=1;
%number of experimental sessions
numExperiments=1000;

%which stats in regression test
whichstats={'tstat','fstat'};
%initialize data sets that will be filled with regression results
% reg - regression on final values, regTrail - regresion according
%to Qlearning trial by trial

reg=struct('action_value',nan(N*numExperiments,3),'random_walk',nan(N*numExperiments,3));
regOnPolicyState=struct('action_value',nan(N*numExperiments,3),'random_walk',nan(N*numExperiments,3));
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

    %alpha & beta are parameters in the Qlearning algorithm of value 
    experiments=0;
            RChoose = setup;
    while experiments<numExperiments

        %countSuccess
        experiments=experiments+1;
        %initializing Qlearning
        Q_4blocks=cell(4);
        for n_for_Q=1:4
          Q_4blocks{n_for_Q}=[0.5 0.5]; 
        end
        
        % training sessions%%
        Trial_order=[];
        Qs=[];
        Pr1=[];
        R=[];
        choice=[];
           for trials=1:experiment_length
        %these are the reward probabilities for the blocks in the current
        %session

        rPerm=randperm(4);
        current_trial=rPerm(1);
        Trial_order=[Trial_order  RChoose(:,current_trial)];
        %spike count in 1s is distributed poisson around firing rate
        Qs=[Qs ; Q_4blocks{current_trial}(end,:)];
        %choice is softmax on Q(1),Q(2), 1-choose 1 0-choose 2
        %and reward (R) for action is stochastic according to reward schedule
        Pr1=[Pr1 (1/(1+exp(-beta*(Qs(end,1)-Qs(end,2)))))];
        choice=[choice ; rand<Pr1(end)];
        R=[R ; (rand<RChoose(1,current_trial))*(choice(end)==1)+(rand<RChoose(2,current_trial))*(choice(end)==0)];
              if choice(end)
                    Q_4blocks{current_trial}=[Q_4blocks{current_trial} ;...
                        (1-alpha)*Qs(end,1)+alpha*R(end)  Qs(end,2)];
                else
                    Q_4blocks{current_trial}=[Q_4blocks{current_trial} ;...
                         Qs(end,1) (1-alpha)*Qs(end,2)+alpha*R(end) ];
                end

            
        end
        
        %session is over - now analyses
        % stats
 
        S=size(AllQs,1);
        AllQs{S+1,1}= Pr1';
        AllQs{S+1,2}=Trial_order;

        AllQs{S+1,4}=choice;
        AllQs{S+1,5}=R;
        AllQs{S+1,6}=Qs;
        
        %decide on modulation for Q-values
        modulation=rand*maxModulation;

  

        %create RW
        RW=ones(1,N)*2.5;
        for trial=2:experiment_length
            RW=[RW ; max(RW(end,:)+randn(1,N)*VecSigma(1),0)];
        end

        RW=poissrnd(RW);
        valueForTrialReg=repmat([2.5-modulation/2+Qs*modulation  2.5+modulation/2-Qs*modulation],1,5);
        AllQs{S+1,7}=valueForTrialReg;
        valueForTrialReg=poissrnd(valueForTrialReg);
        AllQs{S+1,8}=valueForTrialReg;

        AllQs{S+1,9}=modulation;
        AllQs{S+1,10}=RW;

        %regression of firing rates at the end of the experiment on
        %reward probabilities (e.g, 0.5, 0.9) at these
        %stages
        %for action-value
        for i=1:N
            rStats=regstats(valueForTrialReg(analysis_starts:end,i), Trial_order(:,analysis_starts:end)','linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            reg.action_value((experiments-1)*N+i,:)=[tvalue(2) , tvalue(3) ,f.pval ];

            %random walk
            rStats=regstats(RW(analysis_starts:end,i), Trial_order(:,analysis_starts:end)','linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            reg.random_walk((experiments-1)*N+i,:)=[tvalue(2) , tvalue(3) ,f.pval ];

        end

                %regression on policy and state
               
        for i=1:N
            %action-value neurons
            rStats=regstats(valueForTrialReg(analysis_starts:end,i), [Trial_order(1,analysis_starts:end)'+Trial_order(2,analysis_starts:end)'...
                Trial_order(1,analysis_starts:end)'-Trial_order(2,analysis_starts:end)'],'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            regOnPolicyState.action_value((experiments-1)*N+i,:)=[tvalue(2) , tvalue(3) ,f.pval ];
            
            %random-walk neurons
            rStats=regstats(RW(analysis_starts:end,i), [Trial_order(1,analysis_starts:end)'+Trial_order(2,analysis_starts:end)'...
                Trial_order(1,analysis_starts:end)'-Trial_order(2,analysis_starts:end)'],'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            regOnPolicyState.random_walk((experiments-1)*N+i,:)=[tvalue(2) , tvalue(3) ,f.pval ];
        end

    end
  reg.action_value(isnan(reg.action_value(:,1)),:)=[];    
   reg.random_walk(isnan(reg.random_walk(:,1)),:)=[];    
   regOnPolicyState.action_value(isnan(regOnPolicyState.action_value(:,1)),:)=[];    
   regOnPolicyState.random_walk(isnan(regOnPolicyState.random_walk(:,1)),:)=[];    
   
end








