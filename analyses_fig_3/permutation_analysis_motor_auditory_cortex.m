function [pValues] = permutation_analysis_motor_auditory_cortex(AllQs_long,spikeDataForPosSul)
whichstats={'tstat','fstat'};
pValues=[];
 tvaluesRealQ=[];
 minLength=170;

for i=1:size(AllQs_long,1)

    %
    modForCount=mod(i,size(spikeDataForPosSul,2));
    if modForCount==0
        modForCount=size(spikeDataForPosSul,2);
    end
    spikeCount=spikeDataForPosSul(:,modForCount);
    
    estQ=AllQs_long{i,1};
    rStats=regstats(spikeCount(1:minLength), estQ(1:minLength,:),'linear',whichstats);
    
    t=rStats.tstat;
    tvalue=t.t;
    
    tvaluesRealQ=[  tvaluesRealQ ; tvalue(2) tvalue(3)];

    tvaluesPermutations=[];
    for permutations=1:size(AllQs_long,1)
        estQPermutations=AllQs_long{permutations,1};
        
        rStats=regstats(spikeCount(1:minLength), estQPermutations(1:minLength,:),'linear',whichstats);
        
        t=rStats.tstat;
        tvalue=t.t;
        
        tvaluesPermutations=[tvaluesPermutations ; tvalue(2)  ; tvalue(3)];
        
    end
    tvaluesPermutations=sort(abs(tvaluesPermutations),1,'descend');
    
    t1Loc=find(abs(tvaluesRealQ(end,1))==tvaluesPermutations);
    t2Loc=find(abs(tvaluesRealQ(end,2))==tvaluesPermutations);
    
    pValues=[pValues ; 1/size(tvaluesPermutations,1)/2+(t1Loc-1)/size(tvaluesPermutations,1),...
        1/size(tvaluesPermutations,1)/2+(t2Loc-1)/size(tvaluesPermutations,1)];
    
end
