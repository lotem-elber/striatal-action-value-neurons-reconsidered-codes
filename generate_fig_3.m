close all
clear all
addpath(genpath(pwd));
%figure of t distribution
%test on Q-values
whichstats={'tstat','fstat'};
load('seedMem_for_figs_1_and_2.mat');
[~,~,~,AllQs]=Qlearning_action_value_and_RW(seedMem);
figure('units','centimeters','position',[3 3 18 18]);
figPosition=[0.1    0.82    0.45   0.15 ; 0.1    0.62    0.45    0.15 ]; 


a2=axes('Position',figPosition(2,:));
tvaluesRealQ=[];
pValues=[];

minLength=170;
AllQs_long=AllQs;
for i=size(AllQs_long,1):-1:1
    if length(AllQs_long{i,1})<minLength
        AllQs_long(i,:)=[];
    end
end
for i=343
         spikeCount=AllQs{i,7};
         estQ=AllQs{i,1};

    for ValNum=2       
        rStats=regstats(spikeCount(1:minLength,ValNum), estQ(1:minLength,:),'linear',whichstats);        
        t=rStats.tstat;
        tvalue=t.t;        
        tvaluesRealQ=[tvaluesRealQ ; tvalue(2) tvalue(3)];
        tvaluesPermutations=[];
        for permutations=1:size(AllQs_long,1)
            estQForPermute=AllQs_long{permutations,1};           
            rStats=regstats(spikeCount(1:minLength,ValNum), estQForPermute(1:minLength,:),'linear',whichstats);           
            t=rStats.tstat;
            tvalue=t.t;            
            tvaluesPermutations=[tvaluesPermutations ; tvalue(2) ; tvalue(3)];            
        end
        tvaluesPermutationsSort=sort(abs(tvaluesPermutations),1,'descend');       
        t1Loc=find(abs(tvaluesRealQ(end,1))==tvaluesPermutationsSort);
        t2Loc=find(abs(tvaluesRealQ(end,2))==tvaluesPermutationsSort);                
        pValues=[pValues ; 1/size(tvaluesPermutations,1)/2+(t1Loc-1)/size(tvaluesPermutations,1) 1/size(tvaluesPermutations,1)/2+(t2Loc-1)/size(tvaluesPermutations,1)];
    end
end

hold on
h=histogram(tvaluesPermutations,40,'Normalization','pdf','FaceColor',[ 0.3 0.3 0.8],'EdgeColor',[ 0.3 0.3 0.8],'FaceAlpha',1);
sigBoundries= tvaluesPermutationsSort(ceil(size(tvaluesPermutations,1)*0.05));
plot([-sigBoundries -sigBoundries],[0 100],'k--',[sigBoundries sigBoundries],[0 100],'k--','linewidth',2);
limitsX=([floor(-max(abs(tvaluesPermutations))) ceil(max(abs(tvaluesPermutations)))]);
xlim(limitsX);
annotation('arrow',[figPosition(2,1)+(tvaluesRealQ(1)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(2,3) ...
   figPosition(2,1)+(tvaluesRealQ(1)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(2,3) ],...
    [figPosition(2,2)-0.03 figPosition(2,2)-0.01],'Color',[1 0 0]);
annotation('arrow',[figPosition(2,1)+(tvaluesRealQ(2)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(2,3) ...
   figPosition(2,1)+(tvaluesRealQ(2)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(2,3) ],...
    [figPosition(2,2)-0.03 figPosition(2,2)-0.01],'Color',[0 0 1]);
ylim([0 0.4]);
ax = gca;
set(ax,'XTick',[ -3 -1 0 1 3 5]);
set(ax,'YTick',[ 0.1 0.2 0.3]);
ylabel('pdf','fontsize',12);
xlabel('t-values','fontsize',12);
set(gca,'position',figPosition(2,:));
set(gca,'fontsize',12);
set(gca,'fontsize',12);
a1=axes('Position',figPosition(1,:));

pValues=[];
tvaluesRealQ=[];
minLength=170;

for i=343
         spikeCount=AllQs{i,7};
         estQ=AllQs{i,1};
    for ValNum=1        
        rStats=regstats(spikeCount(1:minLength,ValNum), estQ(1:minLength,:),'linear',whichstats);        
        t=rStats.tstat;
        tvalue=t.t;       
        tvaluesRealQ=[tvaluesRealQ ; tvalue(2) tvalue(3)];
        tvaluesPermutations=[];
        for permutations=1:size(AllQs_long,1)
            estQForPermute=AllQs_long{permutations,1};            
            rStats=regstats(spikeCount(1:minLength,ValNum), estQForPermute(1:minLength,:),'linear',whichstats);           
            t=rStats.tstat;
            tvalue=t.t;            
            tvaluesPermutations=[tvaluesPermutations ; tvalue(2) ; tvalue(3)];
            
        end
        tvaluesPermutationsSort=sort(abs(tvaluesPermutations),1,'descend');       
        t1Loc=find(abs(tvaluesRealQ(end,1))==tvaluesPermutationsSort);
        t2Loc=find(abs(tvaluesRealQ(end,2))==tvaluesPermutationsSort);
        pValues=[pValues ; 1/size(tvaluesPermutations,1)/2+(t1Loc-1)/size(tvaluesPermutations,1) 1/size(tvaluesPermutations,1)/2+(t2Loc-1)/size(tvaluesPermutations,1)];
    end
end

hold on
h=histogram(tvaluesPermutations,40,'Normalization','pdf','FaceColor',[0.9 0.4 0.4],'EdgeColor',[0.9 0.4 0.4],'FaceAlpha',1);
sigBoundries= tvaluesPermutationsSort(ceil(size(tvaluesPermutations,1)*0.05));
plot([-sigBoundries -sigBoundries],[0 100],'k--',[sigBoundries sigBoundries],[0 100],'k--','linewidth',2);
limitsX=([floor(-max(abs(tvaluesPermutations))) ceil(max(abs(tvaluesPermutations)))]);
xlim(limitsX);
ylim([0 0.25]);
annotation('arrow',[figPosition(1,1)+(tvaluesRealQ(1)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(1,3) ...
   figPosition(1,1)+(tvaluesRealQ(1)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(1,3) ],...
    [figPosition(1,2)-0.03 figPosition(1,2)-0.01],'Color',[1 0 0]);
annotation('arrow',[figPosition(1,1)+(tvaluesRealQ(2)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(1,3) ...
   figPosition(1,1)+(tvaluesRealQ(2)-limitsX(1))/(limitsX(2)-limitsX(1))*figPosition(1,3) ],...
    [figPosition(1,2)-0.03 figPosition(1,2)-0.01],'Color',[0 0 1]);

ax = gca;
set(ax,'XTick',[-5 -3 -1 0 1 3 5]);
set(gca,'position',figPosition(1,:));
ylabel('pdf','fontsize',12);
set(ax,'YTick',[0.1 0.2]);
set(gca,'fontsize',12);
mTextBox = text(- 0.2133,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
 
%%
%bar figure - action-value and random-walk
        
a3=axes('position',[ 0.1    0.300    0.45    0.2]);

mTextBox = text(- 0.2133,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
hold on
%the data from the analyses on action-value and random-walk neurons is
%loaded because it takes long to run. See analyses_fig_3 for the analyses
%used to create it
load('possible_solution_permutation_all_pValues.mat');
number_samples=504;
colors=colormap(summer);
colors=colors([20 60],:);
colors(1,:)=colors(1,:)*0.6;
colors(2,:)=[0.9 0.8 0];

bars=bar(1:4,[ValueNeuronsValue(1:4)'  ValueNeuronsRW(1:4)']); 
set(bars(1),'facecolor',colors(1,:),'edgecolor',colors(1,:));
set(bars(2),'facecolor',colors(2,:),'edgecolor',colors(2,:));

errorValues=[sqrt(ValueNeuronsValue.*(1-ValueNeuronsValue)./(number_samples-1)) ;...
                    sqrt(ValueNeuronsRW.*(1-ValueNeuronsRW)./(number_samples-1))];

errorbar((1:4)-0.15,ValueNeuronsValue(1:4),errorValues(1,1:4),'color','k','LineWidth',1.5,'LineStyle','none');
errorbar((1:4)+0.15,ValueNeuronsRW(1:4),errorValues(2,1:4),'color','k','LineWidth',1.5,'LineStyle','none');

plot([0.5 2.5],[0.05*0.95 0.05*0.95],'k--','linewidth',1.5);
plot([2.5 4.5],[0.05*0.05/2 0.05*0.05/2],'k--','linewidth',1.5);

axis([0.5 4.5 0 0.25]);

l=legend(bars,'value','random w.');
Children = get(l, 'Children') ;

set(l,'fontsize',12,'orientation','vertical','edgecolor','none','position',[0.5 0.36 0.2 0.07]);

set(gca,'fontsize',12);
set(gca,'XTick',[]);
set(gca,'YTick',[0 0.1 0.2]);
ylabel('fraction','FontSize',12);
locationTextBoxX1=([0.47 1.47 2.3 3.3]./4);
locationTextBoxY=([0.88 0.7 0.9]+0.07);

mTextBox = text(locationTextBoxX1(1),locationTextBoxY(1),'\itQ_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');

mTextBox = text(locationTextBoxX1(2),locationTextBoxY(1),'\itQ_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');

mTextBox = text(locationTextBoxX1(3),locationTextBoxY(3),'\it\SigmaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');

mTextBox = text(locationTextBoxX1(4),locationTextBoxY(3),'\it\DeltaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');

strings=cell(2,4);
for i=1:2
    if round(ValueNeuronsValue(i)*100)>0
    strings{1,i}=[num2str(round(ValueNeuronsValue(i)*100)),'%'];
    strings{2,i}=[num2str(round(ValueNeuronsRW(i)*100)),'%'];
    else
       strings{1,i}=[num2str(round(ValueNeuronsValue(i)*1000)/10),'%'];
       strings{2,i}=[num2str(round(ValueNeuronsRW(i)*1000)/10),'%']; 
    end
end
    
locationTextBoxX1=([0.35 1.35 2.3 3.3]./4-0.05);
locationTextBoxY=([0.8 0.7 0.8]);
for i=1:2
mTextBox = text(locationTextBoxX1(i),locationTextBoxY(1),strings{1,i},'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colors(1,:));
mTextBox = text(locationTextBoxX1(i)+0.12,locationTextBoxY(1),strings{2,i},'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colors(2,:));
end

set(gca,'fontsize',12);
%%
%figure of analysis on basal ganglia
%first analyze data
if ~exist('basal_ganglia_data.mat','file')
    disp('basal ganglia data is missing')
else
load('basal_ganglia_data.mat');
%here analyze using the standard analysis of Fig. 1
tvaluesTotQlearning=nan(642,2);
boundary=2.64;
[~, tvaluesTotQlearning(1:214,:)]=basal_ganglia_original_analyses(spike_data_basal_ganglia_all_phases(1:214),AllQs_basal_ganglia,boundary);
[~, tvaluesTotQlearning(215:428,:)]=basal_ganglia_original_analyses(spike_data_basal_ganglia_all_phases(215:428),AllQs_basal_ganglia,boundary);
[~, tvaluesTotQlearning(429:642,:)]=basal_ganglia_original_analyses(spike_data_basal_ganglia_all_phases(429:642),AllQs_basal_ganglia,boundary);
abstvaluesTotQlearning=abs(tvaluesTotQlearning)>boundary;
basal_ganglia_Qlearning_original_analysis=[nanmean(abstvaluesTotQlearning(:,1) & ~abstvaluesTotQlearning(:,2))...
    nanmean(~abstvaluesTotQlearning(:,1) & abstvaluesTotQlearning(:,2))...
    nanmean(abstvaluesTotQlearning(:,1) & abstvaluesTotQlearning(:,2) & sign(tvaluesTotQlearning(:,1))==sign(tvaluesTotQlearning(:,2)))...
    nanmean(abstvaluesTotQlearning(:,1) & abstvaluesTotQlearning(:,2) & sign(tvaluesTotQlearning(:,1))~=sign(tvaluesTotQlearning(:,2)))];

%here analyze using the permutation analysis
whichstats={'tstat','fstat'};
%lines 221-233 are used to create an array of unique estimated
%action-values, so that there are no repeats
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
mean(pValues<alpha);
basal_ganglia_PermutationAnalysis=[mean(pValues(:,1)<alpha & pValues(:,2)>alpha)...
    mean(pValues(:,1)>alpha & pValues(:,2)<alpha)...
    mean(pValues(:,1)<alpha & pValues(:,2)<alpha & sign(tvaluesRealQ(:,1))==sign(tvaluesRealQ(:,2))) ...    
    mean(pValues(:,1)<alpha & pValues(:,2)<alpha & sign(tvaluesRealQ(:,1))~=sign(tvaluesRealQ(:,2))) ...
    mean(pValues(:,1)>alpha & pValues(:,2)>alpha)];

%now draw the figure
a3=axes('position',[ 0.1    0.0500    0.45    0.2]);
mTextBox = text(- 0.2133,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
hold on
colors=colormap(autumn);
colors=colors(32,:);
bars1=bar(1:4,basal_ganglia_Qlearning_original_analysis(1:4));
set(bars1(1),'facecolor',colors*0.8,'edgecolor',colors*0.8,'BarWidth',0.4);
axis([0.5 4.5 0 0.23]);
set(gca,'fontsize',12);
set(gca,'XTick',[]);
ylabel('fraction','FontSize',12);
locationTextBoxX1=([0.4 1.4 2.3 3.3]./4);
locationTextBoxY=([0.93 0.7 0.98]);

mTextBox = text(locationTextBoxX1(1),locationTextBoxY(1),'\itQ_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');

mTextBox = text(locationTextBoxX1(2),locationTextBoxY(1),'\itQ_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');

mTextBox = text(locationTextBoxX1(3),locationTextBoxY(3),'\it\SigmaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');

mTextBox = text(locationTextBoxX1(4),locationTextBoxY(3),'\it\DeltaQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color','k');


hold on
bars2=bar(1:4,basal_ganglia_PermutationAnalysis(1:4)) ;
set(bars2(1),'facecolor',colors*0.3,'edgecolor',colors*0.3,'BarWidth',0.4);
plot([0.5 2.5],[0.01*0.99 0.01*0.99],'k--','linewidth',1.5);
plot([2.5 4.5],[0.01^2/2 0.01^2/2],'k--','linewidth',1.5);

strings=cell(2,4);
for i=1:4
    strings{1,i}=[num2str(round(basal_ganglia_Qlearning_original_analysis(i)*100)),'%'];
    strings{2,i}=[num2str(round(basal_ganglia_PermutationAnalysis(i)*1000)/10),'%'];
end
    
locationTextBoxX1=([0.49 1.49 2.5 3.52]./4-0.05);
locationTextBoxY=([0.78 0.2]);
for i=1:4
mTextBox = text(locationTextBoxX1(i),locationTextBoxY(1),strings{1,i},'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colors*0.8);
mTextBox = text(locationTextBoxX1(i),locationTextBoxY(2),strings{2,i},'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colors*0.3);
end

l=legend([bars1(1) bars2(1)],'standard','permutation');
set(l,'fontsize',12,'orientation','vertical','edgecolor','none','position',[0.5 0.11 0.21 0.07]);
mTextBox = text(- 0.2133,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
end

