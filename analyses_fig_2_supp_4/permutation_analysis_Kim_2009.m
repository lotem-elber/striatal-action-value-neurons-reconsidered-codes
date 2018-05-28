function [tvaluesQlearningTot , tvaluesPermutationTot , pValue] = permutation_analysis_Kim_2009(dataForAnalysis,AllQs_Kim,seedRem,RW)

N=min(size(dataForAnalysis,2),length(AllQs_Kim));
%calculate regression slopes

whichstats={'tstat','fstat'};

ValueNeuronsQlearningPerm=[];
ValueNeuronsQlearning=[];
tvaluesQlearningTot=[];
tvaluesPermutationTot=[];
rng(seedRem);
num_repeats=20+20*(1-RW);
num_shift=floor((length(AllQs_Kim)-N)/40);
for experiment=1:num_repeats
    experiment

tvaluesQlearning=[];
tvaluesQlearningPerm=zeros(1000,N*2);

for column=1:N
    if mod(column,100)==0
        column
    end
    estQ=AllQs_Kim{column+(1-RW)*num_shift*(experiment-1),1}';
    trialsPerBlock=AllQs_Kim{column+(1-RW)*num_shift*(experiment-1),3};
    %cancelled the test for goodspikecount
    goodSpikeCount=0;
    trialsPerBlock=[0 trialsPerBlock];
    for i=1:length(trialsPerBlock)-1
        if mean(dataForAnalysis((trialsPerBlock(i)+1):trialsPerBlock(i+1),column+RW*length(AllQs_Kim)*(experiment-1)))>1
            goodSpikeCount=1;
            
        end
    end
    if goodSpikeCount==1;
        %delete 0 from beginning of trials per block
        trialsPerBlock(1)=[];
        
        rStats=regstats(dataForAnalysis(1:length(estQ),column+RW*length(AllQs_Kim)*(experiment-1)),estQ,'linear',whichstats);
        t=rStats.tstat;
        tvalue=t.t;
        tvaluesQlearning=[tvaluesQlearning ; tvalue(2) tvalue(3)];

        %run permutation test
        for permutations=1:1000
            dataForAnalysisPerm=[randperm(trialsPerBlock(1)) trialsPerBlock(1)+randperm(trialsPerBlock(2)-trialsPerBlock(1))...
                trialsPerBlock(2)+randperm(trialsPerBlock(3)-trialsPerBlock(2)) trialsPerBlock(3)+randperm(trialsPerBlock(4)-trialsPerBlock(3))];
            dataForAnalysisPerm=dataForAnalysis(dataForAnalysisPerm,column+RW*length(AllQs_Kim)*(experiment-1));
            
            rStats=regstats(dataForAnalysisPerm, estQ,'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningPerm(permutations,(column*2-1):(2*column))=[ tvalue(2) tvalue(3)];

        end

    else
        tvaluesQlearning=[ tvaluesQlearning ; nan nan];

    end
end



tvaluesQlearningTot=[tvaluesQlearningTot ;  tvaluesQlearning];
abstvaluesQlearning=(abs(tvaluesQlearning))>2;
tRightQlearning=(abstvaluesQlearning(:,1)-abstvaluesQlearning(:,2))==1;
tLeftQlearning=(abstvaluesQlearning(:,2)-abstvaluesQlearning(:,1))==1;
tBothQlearning=(abstvaluesQlearning(:,2)+abstvaluesQlearning(:,1))==2;
tNoneQlearning=(abstvaluesQlearning(:,2)+abstvaluesQlearning(:,1))==0;
ValueNeuronsQlearning=[ValueNeuronsQlearning ; nanmean(tRightQlearning) nanmean(tLeftQlearning) nanmean(tBothQlearning) nanmean(tNoneQlearning)];


%Permutation test

%permutation test on Q-values
tvaluesQlearningPermQ1=tvaluesQlearningPerm(:,1:2:(N*2-1));
tvaluesQlearningPermQ2=tvaluesQlearningPerm(:,2:2:N*2);
tvaluesQlearningPermQ1(:,isnan(tvaluesQlearning(:,1)))=[];
tvaluesQlearningPermQ2(:,isnan(tvaluesQlearning(:,2)))=[];
tvaluesQlearning(isnan(tvaluesQlearning(:,1)),:)=[];

tvaluesQlearningPermQ1Sorted=sort(abs(tvaluesQlearningPermQ1),1,'descend');
permtestQlearningQ1=abs(tvaluesQlearning(:,1))>mean([tvaluesQlearningPermQ1Sorted(24,:) ; tvaluesQlearningPermQ1Sorted(25,:)])';
mean(permtestQlearningQ1)

tvaluesQlearningPermQ2Sorted=sort(abs(tvaluesQlearningPermQ2),1,'descend');
permtestQlearningQ2=abs(tvaluesQlearning(:,2))>mean([tvaluesQlearningPermQ2Sorted(24,:) ; tvaluesQlearningPermQ2Sorted(25,:)])';
mean(permtestQlearningQ2)

tRightQlearningPerm=(permtestQlearningQ1-permtestQlearningQ2)==1;
tLeftQlearningPerm=(permtestQlearningQ2-permtestQlearningQ1)==1;
tBothQlearningPerm=(permtestQlearningQ2+permtestQlearningQ1)==2;
tNoneQlearningPerm=(permtestQlearningQ2+permtestQlearningQ1)==0;
ValueNeuronsQlearningPerm=[ ValueNeuronsQlearningPerm ; nanmean(tRightQlearningPerm) nanmean(tLeftQlearningPerm) nanmean(tBothQlearningPerm) nanmean(tNoneQlearningPerm)]

tvaluesPermutationTot=[tvaluesPermutationTot ; (permtestQlearningQ1+permtestQlearningQ2)>0 ];
end
pValue=binocdf(sum(tvaluesPermutationTot)-1,length(tvaluesPermutationTot),0.05,'upper')
