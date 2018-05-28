function [tvaluesTot, tvaluesTotQlearning,  tvaluesTotQlearningDetrending]=regression_analyses_motor_auditory_cortex(SpikeData,AllQs,num_for_experiment)
whichstats={'tstat','fstat'};
ValueNeurons=[];
tvaluesTot=[];

ValueNeuronsQlearning=[];
ValueNeuronsQlearningDetrending=[];
tvaluesTotQlearning=[];
tvaluesTotQlearningDetrending=[];

for experiment=1:40

    deletedRows=[];
    tvalues=[];
    fvalues=[];
    tvaluesQlearning=[];
    tvaluesQlearningDetrending=[];

    for column=1:size(SpikeData,2)
        estQ=AllQs{column+experiment*num_for_experiment,1};
        RChoose=AllQs{column+experiment*num_for_experiment,2};
        trialsPerBlock=AllQs{column+experiment*num_for_experiment,3};
        choice=AllQs{column+experiment*num_for_experiment,4};
        R=AllQs{column+experiment*num_for_experiment,5};
        goodSpikeCount=0;
        trialsPerBlock=[0 trialsPerBlock];
        for i=1:length(trialsPerBlock)-1
            if (mean(SpikeData(trialsPerBlock(i)+1:trialsPerBlock(i+1),column))>1)
                goodSpikeCount=1;
                
            end
        end
        %delete 0 fro row 25
        trialsPerBlock(1)=[];
        if goodSpikeCount==1
            regressor1=[];
            regressor2=[];
            for columnRChoose=1:size(RChoose,2)
                regressor1=[regressor1 ; ones(20,1)*RChoose(1,columnRChoose)];
                regressor2=[regressor2 ; ones(20,1)*RChoose(2,columnRChoose)];
            end
            trialsForReg=[];
            for blocksCount=1:length(trialsPerBlock)
                trialsForReg=[trialsForReg trialsPerBlock(blocksCount)-19:trialsPerBlock(blocksCount)];
            end
            rStats=regstats(SpikeData(trialsForReg,column), [regressor1 regressor2],'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            tvalues=[tvalues ; tvalue(2) tvalue(3) f.pval];

       
            rStats=regstats(SpikeData(1:trialsPerBlock(end),column), estQ,'linear',whichstats);
            
            t=rStats.tstat;
            tvalue=t.t;
           
            tvaluesQlearning=[tvaluesQlearning ; tvalue(2) tvalue(3)];
            
            rStats=regstats(SpikeData(2:trialsPerBlock(end),column), [estQ(2:end,:) (1:length(estQ(2:end,:)))' choice(1:end-1)' choice(2:end)' R(1:end-1)' R(2:end)'],'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningDetrending=[tvaluesQlearningDetrending ; tvalue(2) tvalue(3)];
            
        else
            deletedRows=[deletedRows column];
            tvalues=[tvalues ; NaN NaN NaN];
            tvaluesQlearning=[tvaluesQlearning ; NaN NaN];
            tvaluesQlearningDetrending=[tvaluesQlearningDetrending ; NaN NaN];
        end
    end

    tvaluesTot=[tvaluesTot ; tvalues];
 
    tvaluesTotQlearning=[tvaluesTotQlearning ; tvaluesQlearning];
  
    tvaluesTotQlearningDetrending=[tvaluesTotQlearningDetrending ; tvaluesQlearningDetrending];
end   
end
