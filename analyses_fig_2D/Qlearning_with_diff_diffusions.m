close all
%if script is run from its folder 'analyses_fig_2D' add main folder and all its subfolders to path
 [folder_path folder]=fileparts(pwd);
 if isequal(folder,'analyses_fig_2D')
      addpath(genpath(folder_path));
 else
    disp('current path not in "analyses_fig_2D" folder');
end
%num of random-walk neurons
N=20;

%
VecSigma=[0 0.02 0.04 0.06 0.08 0.09 0.1 0.11 0.12 0.14 0.16 0.18 0.2];
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
whichstats={'tstat','fstat','rsquare'};
r_square=ones(20000,1)*-1;
%initialize data sets that will be filled with regression results
% reg - regression on final values, regTrail - regresion according
%to Qlearning trial by trial

reg=cell(3,2,length(VecSigma));
regTrialDiffSigmas=cell(3,2,length(VecSigma));
RW_data=cell(1000,length(VecSigma));
regTrialDiffSigmasDoya=cell(4,2,length(VecSigma));
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
%Sigma - different diffusion parameters
for sigma=VecSigma
    sigma
    sigmaPlace=find(VecSigma==sigma);
    %alpha & beta are parameters in the Qlearning algorithm of value
    alpha=0.1;
    beta=2.5;
    
    experiments=0;
    %count how many trials in a session
    %measure of number of trials in each session
    trials_in_session=[];
    while experiments<1000
        
        %countSuccess
        experiments=experiments+1;
        %initializing Qlearning
        Q=[0.5 ; 0.5];
        %probability of choosing left
        Pr1Qlearning=[0.5];
        %This line is only meant to keep a new version synchronized with
        %the seed in older versions
        NeurInput=randn(1,N);
        %these are the random-walk neurons
        NeurActivityPopMean=ones(1,N)*2.5;
        %these are for fig 1B
        singleNeurons=1:N;
        NeurActivitySingleNeuronsForPlot=[NeurActivityPopMean(singleNeurons)];
        
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
            %larger than is required to calculate proprtion
            
            while (i<numStat) || sum(choice(max(length(choice)-i+1,length(choice)-numStat+1):end)==(RChoose(1,k)>RChoose(2,k)))<=ceil(numStat*prop)
                %updating value for Qlearning Q1 and Q2 represent the values for the
                %actions. Pr1Qlearning is the probability of choosing 1 according to
                %Qlearning
                if choice(end)
                    Q=[Q [(1-alpha)*Q(1,end)+alpha*R(end) ; Q(2,end)]];
                else
                    Q=[Q [Q(1,end) ; (1-alpha)*Q(2,end)+alpha*R(end)]];
                end
                Pr1Qlearning=[Pr1Qlearning 1/(1+exp(-beta*(Q(1,end)-Q(2,end))))];
                
                %add step to random walk
                NeurActivityPopMean=max(NeurActivityPopMean+randn(1,N)*sigma,zeros(1,N));
                NeurActivitySingleNeuronsForPlot=[NeurActivitySingleNeuronsForPlot ; NeurActivityPopMean(singleNeurons)];
                NeurActivity=poissrnd(NeurActivityPopMean*T);
                %update choice, reward and trial number
                choice=[choice rand<(1/(1+exp(-beta*(Q(1,end)-Q(2,end)))))];
                R=[R (rand<RChoose(1,k))*(choice(end)==1)+(rand<RChoose(2,k))*(choice(end)==0)];
                i=i+1;
                NeurActivityForStats(i,:,k)=NeurActivity;
            end
            
        end
        
        %session is over - now analyses
        % stats
        
        %estimate Q with ML from behavior
        [estQ,estAlphaRem,estBetaRem]=Estimate_Q(choice,R,estAlphaRem,estBetaRem);
        S=size(AllQs,1);
        AllQs{S+1,1}= estQ';
        AllQs{S+1,2}=RChoose;
        trialsPerBlock=find(NeurActivityForStats(:,1,1)>-1,1,'last');
        for j=2:4
            trialsPerBlock=[trialsPerBlock trialsPerBlock(end)+find(NeurActivityForStats(:,1,j)>-1,1,'last')];
        end
        AllQs{S+1,3}=trialsPerBlock;
        AllQs{S+1,4}=choice;
        AllQs{S+1,5}=R; 
        trials_in_session=[trials_in_session trialsPerBlock(end)];
        
        
        %decide on modulation for Q-values
        modulation=rand*2.35;

        
        %initialize neurActivity for regressions Reg- reward probability
        %regTrialDiffSigmas - regression on estimated Q-values
        NeurActivityForTrialReg=[];
        
        %organize data for statistical analysis
        
        for k=1:numBlocks
            NeurActivityForTrialReg=[NeurActivityForTrialReg ; NeurActivityForStats(1:find(NeurActivityForStats(:,1,k)>-1,1,'last'),:,k)];
        end
        
        %count how many times randomWalk touched 0
        zeroTouch(sigmaPlace)=zeroTouch(sigmaPlace)+sum(sum(NeurActivitySingleNeuronsForPlot==0)>0);
        touch100(sigmaPlace)=touch100(sigmaPlace)+sum(sum(NeurActivityForTrialReg>99));
        
        %deleting neurons with a below threshold mean firing rate
        
        NeurActivityForStats(NeurActivityForStats==-1)=NaN;
        BelowThres=nanmean(NeurActivityForStats,1);
        BelowThres=sum(BelowThres>Thres,3)<1;
        NeurActivityForTrialReg(:,BelowThres)=[];

        %more for AllQs
        S=size(AllQs,1);
        AllQs{S,6}=Q';
        AllQs{S,8}=modulation;
        AllQs{S,9}=NeurActivityForTrialReg;        
        
        %regression on estimated action-values

        %for random-walk
        for i=1:size(NeurActivityForTrialReg,2)
            rStats=regstats(NeurActivityForTrialReg(:,i), estQ','linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            r_square((experiments-1)*20+i,1)=rStats.rsquare;
            tvalue=t.t;
            regTrialDiffSigmas{1,2,sigmaPlace}=[regTrialDiffSigmas{1,2,sigmaPlace} ;  tvalue(2)];
            regTrialDiffSigmas{2,2,sigmaPlace}=[regTrialDiffSigmas{2,2,sigmaPlace} ; tvalue(3)];
            regTrialDiffSigmas{3,2,sigmaPlace}=[regTrialDiffSigmas{3,2,sigmaPlace} ; f.pval];
        end
    end    
end










