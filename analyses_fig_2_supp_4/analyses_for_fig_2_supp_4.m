
%create the data for the figure from the analyses 
clear all
close all
%if script is run from its folder 'analyses_fig_2_supp_4' add main folder and all its subfolders to path
 [folder_path folder]=fileparts(pwd);
 if isequal(folder,'analyses_fig_2_supp_4')
      addpath(genpath(folder_path));
 else
    disp('current path not in "analyses_fig_2_supp_4" folder');
end
%create random-walk
load('seedForAllPermutations.mat')
rng(seedRemPermutation)
N=20000;
beginRandomWalk=2.5;
randomWalkFiringRate=ones(1,N)*beginRandomWalk;
NeurActivity=poissrnd(randomWalkFiringRate);
sigma=0.1;

for i=2:180
    randomWalkFiringRate=[randomWalkFiringRate ; max(randomWalkFiringRate(end,:)+randn(1,N)*sigma,0)];
    
end
NeurActivity= poissrnd(randomWalkFiringRate);
%create AllQs
load('seedForAllPermutations.mat')
rng(seedRemPermutation)
setupTot=[0.72 0.12 0.63 0.21 ; 0.12 0.72 0.21 0.63 ;...
    0.72 0.21 0.63 0.12 ; 0.12 0.63 0.21 0.72 ;...
    0.63 0.21 0.72 0.12  ; 0.21 0.63 0.12 0.72 ;...
    0.63 0.12 0.72 0.21  ; 0.21 0.72 0.12 0.63];
alpha=0.1;
beta=2.5;
AllQs_Kim=cell(0);
estAlphaRem=[];
estBetaRem=[];
for All=1:1000
    randy=randperm(4);
    randy=randy(1);
    setup=setupTot((randy*2-1):(randy*2),:);
    setup=setup(randperm(2),:);
    AllQs_Kim{All,2}=setup;
    trialsPerBlock=zeros(1,4);
    trialsPerBlock(1)=35+round(rand*10);
    trialsPerBlock(2)=trialsPerBlock(1)+35+round(rand*10);
    trialsPerBlock(3)=trialsPerBlock(2)+35+round(rand*10);
    trialsPerBlock(4)=trialsPerBlock(3)+35+round(rand*10);
    
    AllQs_Kim{All,3}=trialsPerBlock;
    estQ=[0.5 0.5];
    trialsPerBlock=[0 trialsPerBlock];
    choice=[];
    R=[];
    for block=1:4
        rProb=setup(:,block);
        for trials=(trialsPerBlock(block)+1):trialsPerBlock(block+1)
            
            
            probChoice=1/(1+exp(-beta*(estQ(end,1)-estQ(end,2))));
            choice=[choice rand<probChoice];
            if choice(end)
              R=[R rand<rProb(1)];
              estQ=[estQ ; estQ(end,1)+alpha*(R(end)-estQ(end,1)) estQ(end,2)];
            else
              R=[R rand<rProb(2)];
              estQ=[estQ ; estQ(end,1) estQ(end,2)+alpha*(R(end)-estQ(end,2))];
            end
            
        end
    end
    trialsPerBlock(1)=[];
    [estQ,estAlphaRem,estBetaRem] = Estimate_Q(choice,R,estAlphaRem,estBetaRem );
    AllQs_Kim{All,1}=estQ;
end
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
else
load('basal_ganglia_data.mat')
load('seedForAllPermutations.mat')
tic
basal_ganglia_data_200_trials=[];
for i=1:length(spike_data_basal_ganglia_all_phases)
    basal_ganglia_data_200_trials=[basal_ganglia_data_200_trials spike_data_basal_ganglia_all_phases{i}(1:200)];
end
[tvalues_basal_ganglia tvaluesPerm_basal_ganglia pValue] = permutation_analysis_Kim_2009(basal_ganglia_data_200_trials,AllQs_Kim,seedRemPermutation,0);
time_elapsed=toc;
end
[tvalues_RW tvaluesPerm_RW pValue_RW] = permutation_analysis_Kim_2009(NeurActivity,AllQs_Kim,seedRemPermutation,1);
load('motor_cortex_spike_data.mat')
load('seedForAllPermutations.mat')
[tvalues_motor tvaluesPerm_motor pValue_motor] = permutation_analysis_Kim_2009(motor_cortex_spike_data,AllQs_Kim,seedRemPermutation,0);
load('auditory_cortex_spike_data.mat')
load('seedForAllPermutations.mat')
[tvalues_auditory tvaluesPerm_auditory pValue_auditory] = permutation_analysis_Kim_2009(spikeDataRes,AllQs_Kim,seedRemPermutation,0);