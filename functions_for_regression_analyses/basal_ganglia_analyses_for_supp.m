function[ tvaluesTot tvaluesTotQlearning tvaluesTotQlearningDetrending]=basal_ganglia_analyses_for_supp(AllQs_for_analysis,data_for_analysis)
whichstats={'tstat','fstat'};
ValueNeurons=[];
tvaluesTot=[];
fvaluesTot=[];
ValueNeuronsQlearning=[];
ValueNeuronsQlearningDetrending=[];
tvaluesTotQlearning=[];
tvaluesTotQlearningDetrending=[];
tvaluesTotQlearningKim=[];
num_of_blocks=[]; 
num_of_trials=[];
for experiment=1:40

    deletedRows=[];
    tvalues=[];
    fvalues=[];
    tvaluesQlearning=[];
    tvaluesQlearningDetrending=[];
    for column=1:size(data_for_analysis,2)
         data_for_analysis_use_current_run=data_for_analysis{column};
         minLengthSpikesAndEstQ=length(data_for_analysis_use_current_run);
         columnForAllQs=column;
 
         while AllQs_for_analysis{columnForAllQs+experiment,3}(4)>minLengthSpikesAndEstQ
             columnForAllQs=columnForAllQs+50;
         end
          
        minLengthSpikesAndEstQ=min(length(AllQs_for_analysis{columnForAllQs+experiment,1}),length(data_for_analysis{column}));
        estQ=AllQs_for_analysis{columnForAllQs+experiment,1}(1:minLengthSpikesAndEstQ,:);
        RChoose=AllQs_for_analysis{columnForAllQs+experiment,2};
        trialsPerBlock=AllQs_for_analysis{columnForAllQs+experiment,3};
          trialsPerBlock=trialsPerBlock(find(trialsPerBlock<=length(estQ)));
          RChoose=RChoose(:,1:length(trialsPerBlock));
        
        choice=AllQs_for_analysis{columnForAllQs+experiment,4}(1:minLengthSpikesAndEstQ);
        R=AllQs_for_analysis{columnForAllQs+experiment,5}(1:minLengthSpikesAndEstQ);
  
        goodSpikeCount=0;
        trialsPerBlock=[0 trialsPerBlock];

        for i=1:length(trialsPerBlock)-1
            if (mean(data_for_analysis{column}(trialsPerBlock(i)+1:trialsPerBlock(i+1)))>1)
                goodSpikeCount=1;
                
            end
        end

        %delete 0 from trialsPerBlock
        trialsPerBlock(1)=[];
        
        if goodSpikeCount==1 
              num_of_blocks=[num_of_blocks length(RChoose)];
              num_of_trials=[num_of_trials length(estQ)]; 
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
            rStats=regstats(data_for_analysis_use_current_run(trialsForReg), [regressor1 regressor2],'linear',whichstats);
            t=rStats.tstat;
            f=rStats.fstat;
            tvalue=t.t;
            tvalues=[tvalues ; tvalue(2) tvalue(3)];
            fvalues=[fvalues ; f.pval];
       
            rStats=regstats(data_for_analysis_use_current_run(1:minLengthSpikesAndEstQ), estQ,'linear',whichstats);
            
            t=rStats.tstat;
            tvalue=t.t;
           
            tvaluesQlearning=[tvaluesQlearning ; tvalue(2) tvalue(3)];
           
            rStats=regstats(data_for_analysis_use_current_run(2:minLengthSpikesAndEstQ), [estQ(2:end,:) (1:length(estQ(2:end,:)))' choice(1:end-1)' choice(2:end)' R(1:end-1)' R(2:end)'],'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningDetrending=[tvaluesQlearningDetrending ; tvalue(2) tvalue(3)];
          
        else

            deletedRows=[deletedRows column];
            tvalues=[tvalues ; NaN NaN];
            fvalues=[fvalues ; NaN];
            tvaluesQlearning=[tvaluesQlearning ; NaN NaN];
            tvaluesQlearningDetrending=[tvaluesQlearningDetrending ; NaN NaN];
        end
    end

    tvaluesTot=[tvaluesTot ; tvalues fvalues];
    tvaluesTotQlearning=[tvaluesTotQlearning ; tvaluesQlearning];
    tvaluesTotQlearningDetrending=[tvaluesTotQlearningDetrending ; tvaluesQlearningDetrending];
 
    
end