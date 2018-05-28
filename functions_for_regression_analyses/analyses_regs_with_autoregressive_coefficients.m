function [tvaluesQlearningAutoregressive_coefficients_RW , tvaluesQlearningAutoregressive_coefficients_motor_cortex...
    tvaluesQlearningAutoregressive_coefficients_auditory_cortex , tvaluesQlearningAutoregressive_coefficients_basal_ganglia...
    ]=analyses_regs_with_autoregressive_coefficients()
%create allQs_Autoregressive_coefficients
setupTot=[0.72 0.12 0.63 0.21 ; 0.12 0.72 0.21 0.63 ;...
    0.72 0.21 0.63 0.12 ; 0.12 0.63 0.21 0.72 ;...
    0.63 0.21 0.72 0.12  ; 0.21 0.63 0.12 0.72 ;...
    0.63 0.12 0.72 0.21  ; 0.21 0.72 0.12 0.63];
alpha=0.1;
beta=2.5;
load('seedForAllPermutations.mat')
rng(seedRemPermutation);
estAlphaRem=[];
estBetaRem=[];
AllQs_Autoregressive_coefficients={};
numQs=1000;
for All=1:numQs
    randy=randperm(4);
    randy=randy(1);
    setup=setupTot((randy*2-1):(randy*2),:);
    setup=setup(randperm(2),:);
    AllQs_Autoregressive_coefficients{All,2}=setup;
    trialsPerBlock=zeros(1,4);
    trialsPerBlock(1)=35+round(rand*10);
    trialsPerBlock(2)=trialsPerBlock(1)+35+round(rand*10);
    trialsPerBlock(3)=trialsPerBlock(2)+35+round(rand*10);
    trialsPerBlock(4)=trialsPerBlock(3)+35+round(rand*10);
    
    AllQs_Autoregressive_coefficients{All,3}=trialsPerBlock;
    Q=[0.5 0.5];
    trialsPerBlock=[0 trialsPerBlock];
    choice=[];
    R=[];
    for block=1:4
        rProb=setup(:,block);
        for trials=(trialsPerBlock(block)+1):trialsPerBlock(block+1)
            
            
            probChoice=1/(1+exp(-beta*(Q(end,1)-Q(end,2))));
            choice=[choice rand<probChoice];
            if choice(end)
                R=[R rand<rProb(1)];
                Q=[Q ; Q(end,1)+alpha*(R(end)-Q(end,1)) Q(end,2)];
            else
                R=[R rand<rProb(2)];
                Q=[Q ; Q(end,1) Q(end,2)+alpha*(R(end)-Q(end,2))];
            end
            
        end
    end
    trialsPerBlock(1)=[];
    [estQ,estAlphaRem,estBetaRem] = Estimate_Q(choice,R,estAlphaRem,estBetaRem );
    AllQs_Autoregressive_coefficients{All,1}=estQ';
    AllQs_Autoregressive_coefficients{All,4}=choice'*2-1;
    AllQs_Autoregressive_coefficients{All,5}=R'*2-1;
end

%create random-walk
rng(seedRemPermutation);
N=20000;
beginRandomWalk=2.5;
randomWalkFiringRate=ones(1,N)*beginRandomWalk;
NeurActivity=poissrnd(randomWalkFiringRate);
sigma=0.1;

for i=2:180
    randomWalkFiringRate=[randomWalkFiringRate ; max(randomWalkFiringRate(end,:)+randn(1,N)*sigma,0)];
    NeurActivity=[NeurActivity ; poissrnd(randomWalkFiringRate(end,:))];
end

%random walk
%define data
dataForAnalysisGeneral=NeurActivity;
N=min(size(dataForAnalysisGeneral,2),size(AllQs_Autoregressive_coefficients,1));


whichstats={'tstat','fstat'};
tvaluesQlearningAutoregressive_coefficients_RW=[];

for experiment=1:20
    
    dataForAnalysis=dataForAnalysisGeneral(:,experiment:20:length(dataForAnalysisGeneral));
    tvaluesQlearningAutoregressive_coefficients=[];
    
    for column=1:N
        estQ=AllQs_Autoregressive_coefficients{column,1};
        trialsPerBlock=AllQs_Autoregressive_coefficients{column,3};
        choice=AllQs_Autoregressive_coefficients{column,4};
        R=AllQs_Autoregressive_coefficients{column,5};
        trialsPerBlock=[0 trialsPerBlock];
        %exclude neurons with firing rate that is too low
        goodSpikeCount=0;
        for i=1:length(trialsPerBlock)-1
            if mean(dataForAnalysis((trialsPerBlock(i)+1):trialsPerBlock(i+1),column))>1
                goodSpikeCount=1;
                
            end
        end
        if goodSpikeCount==1;
            
            AutoRegressionCoef=[dataForAnalysis(1:(length(estQ)-3),column)...
                dataForAnalysis(2:(length(estQ)-2),column)...
                dataForAnalysis(3:(length(estQ)-1),column)];
            chosen_value=estQ(:,1).*((choice+1)/2)+estQ(:,2).*((1-choice)/2);
            rStats=regstats(dataForAnalysis(4:length(estQ),column),[estQ(4:end,:) choice(4:end,:) R(4:end,:)...
                choice(4:end,:).*R(4:end,:) chosen_value(4:end) AutoRegressionCoef],'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningAutoregressive_coefficients=[tvaluesQlearningAutoregressive_coefficients ; tvalue(2) tvalue(3)];
            
        end
    end
    
    tvaluesQlearningAutoregressive_coefficients_RW=[tvaluesQlearningAutoregressive_coefficients_RW ;  tvaluesQlearningAutoregressive_coefficients];
    
end


%analyze motor cortex Data
load('motor_cortex_spike_data.mat')
%define data
dataForAnalysis=motor_cortex_spike_data;
N=min(size(dataForAnalysis,2),size(AllQs_Autoregressive_coefficients,1));

whichstats={'tstat','fstat'};
tvaluesQlearningAutoregressive_coefficients_motor_cortex=[];

for experiment=1:40

    tvaluesQlearningAutoregressive_coefficients=[];
    
    for column=1:N
        estQ=AllQs_Autoregressive_coefficients{column+experiment*20,1};
        trialsPerBlock=AllQs_Autoregressive_coefficients{column+experiment*20,3};
        choice=AllQs_Autoregressive_coefficients{column+experiment*20,4};
        R=AllQs_Autoregressive_coefficients{column+experiment*20,5};
        %exclude neurons with low firing rate
        trialsPerBlock=[0 trialsPerBlock];
        goodSpikeCount=0;
        for i=1:length(trialsPerBlock)-1
            if mean(dataForAnalysis((trialsPerBlock(i)+1):trialsPerBlock(i+1),column))>1
                goodSpikeCount=1;
                
            end
        end
        if goodSpikeCount==1;
 
            AutoRegressionCoef=[dataForAnalysis(1:(length(estQ)-3),column)...
                dataForAnalysis(2:(length(estQ)-2),column)...
                dataForAnalysis(3:(length(estQ)-1),column)];
            chosen_value=estQ(:,1).*((choice+1)/2)+estQ(:,2).*((1-choice)/2);
            rStats=regstats(dataForAnalysis(4:length(estQ),column),[estQ(4:end,:) choice(4:end,:) R(4:end,:)...
                choice(4:end,:).*R(4:end,:) chosen_value(4:end) AutoRegressionCoef],'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningAutoregressive_coefficients=[tvaluesQlearningAutoregressive_coefficients ; tvalue(2) tvalue(3)];

        end
    end
    
    tvaluesQlearningAutoregressive_coefficients_motor_cortex=[tvaluesQlearningAutoregressive_coefficients_motor_cortex ;  tvaluesQlearningAutoregressive_coefficients];
    
end

%%
%analyze auditory cortex Data
load('auditory_cortex_spike_data.mat')
%define data
dataForAnalysis=spikeDataRes;
N=min(size(dataForAnalysis,2),size(AllQs_Autoregressive_coefficients,1));

whichstats={'tstat','fstat'};
tvaluesQlearningAutoregressive_coefficients_auditory_cortex=[];

for experiment=1:40

    tvaluesQlearningAutoregressive_coefficients=[];
    
    for column=1:N
        estQ=AllQs_Autoregressive_coefficients{column+experiment*20,1};
        trialsPerBlock=AllQs_Autoregressive_coefficients{column+experiment*20,3};
        choice=AllQs_Autoregressive_coefficients{column+experiment*20,4};
        R=AllQs_Autoregressive_coefficients{column+experiment*20,5};
        trialsPerBlock=[0 trialsPerBlock];
        goodSpikeCount=0;
        for i=1:length(trialsPerBlock)-1
            if mean(dataForAnalysis((trialsPerBlock(i)+1):trialsPerBlock(i+1),column))>1
                goodSpikeCount=1;
                
            end
        end
        if goodSpikeCount==1;

            AutoRegressionCoef=[dataForAnalysis(1:(length(estQ)-3),column)...
                dataForAnalysis(2:(length(estQ)-2),column)...
                dataForAnalysis(3:(length(estQ)-1),column)];
            chosen_value=estQ(:,1).*((choice+1)/2)+estQ(:,2).*((1-choice)/2);
            rStats=regstats(dataForAnalysis(4:length(estQ),column),[estQ(4:end,:) choice(4:end,:) R(4:end,:)...
                choice(4:end,:).*R(4:end,:) chosen_value(4:end) AutoRegressionCoef],'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningAutoregressive_coefficients=[tvaluesQlearningAutoregressive_coefficients ; tvalue(2) tvalue(3)];
        else
            tvaluesQlearningAutoregressive_coefficients=[tvaluesQlearningAutoregressive_coefficients ; nan nan]; 
        end
    end    
    tvaluesQlearningAutoregressive_coefficients_auditory_cortex=[tvaluesQlearningAutoregressive_coefficients_auditory_cortex ;  tvaluesQlearningAutoregressive_coefficients];
    end

%analyze basal ganglia data
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
    tvaluesQlearningAutoregressive_coefficients_basal_ganglia=[];
else
load('basal_ganglia_data.mat')
%this is only used in the first 180 trials
%define data
dataForAnalysis=spike_data_basal_ganglia_all_phases;
N=min(size(dataForAnalysis,2),size(AllQs_Autoregressive_coefficients,1));

whichstats={'tstat','fstat'};

tvaluesQlearningAutoregressive_coefficients_basal_ganglia=[];

for experiment=1:40
    tvaluesQlearningAutoregressive_coefficients=[];
    
    for column=1:N
        
        estQ=AllQs_Autoregressive_coefficients{column+experiment,1};
        trialsPerBlock=AllQs_Autoregressive_coefficients{column+experiment,3};
        choice=AllQs_Autoregressive_coefficients{column+experiment,4};
        R=AllQs_Autoregressive_coefficients{column+experiment,5};
        trialsPerBlock=[0 trialsPerBlock];
        goodSpikeCount=0;
        for i=1:length(trialsPerBlock)-1
            if mean(dataForAnalysis{column}((trialsPerBlock(i)+1):trialsPerBlock(i+1)))>1
                goodSpikeCount=1;
                
            end
        end
        if goodSpikeCount==1;
            AutoRegressionCoef=[dataForAnalysis{column}(1:(length(estQ)-3))...
                dataForAnalysis{column}(2:(length(estQ)-2))...
                dataForAnalysis{column}(3:(length(estQ)-1))];
            chosen_value=estQ(:,1).*((choice+1)/2)+estQ(:,2).*((1-choice)/2);
            rStats=regstats(dataForAnalysis{column}(4:length(estQ)),[estQ(4:end,:) choice(4:end,:) R(4:end,:)...
                choice(4:end,:).*R(4:end,:) chosen_value(4:end) AutoRegressionCoef],'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningAutoregressive_coefficients=[tvaluesQlearningAutoregressive_coefficients ; tvalue(2) tvalue(3)];
            
        else
            tvaluesQlearningAutoregressive_coefficients=[ tvaluesQlearningAutoregressive_coefficients ; nan nan];
        end
    end
    tvaluesQlearningAutoregressive_coefficients_basal_ganglia=[tvaluesQlearningAutoregressive_coefficients_basal_ganglia ;  tvaluesQlearningAutoregressive_coefficients]; 
end
end