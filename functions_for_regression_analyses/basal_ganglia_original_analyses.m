function [tvaluesTot, tvaluesTotQlearning]=basal_ganglia_original_analyses(data_for_analysis,AllQs_for_analysis,boundary)
whichstats={'tstat','fstat'};
ValueNeurons=[];
tvaluesTot=[];
fvaluesTot=[];
ValueNeuronsQlearning=[];
ValueNeuronsQlearningDoya=[];
tvaluesTotQlearning=[];
tvaluesTotQlearningDoya=[];
 for experiment=0
    expRun=1;
    deletedRows=[];
    tvalues=[];
    fvalues=[];
    tvaluesQlearning=[];
    tvaluesQlearningDoya=[];
    for column=1:size(data_for_analysis,2)
         data_for_analysis_use_current_run=data_for_analysis{column}(:,expRun);
         minLengthSpikesAndEstQ=length(data_for_analysis_use_current_run);
         columnForAllQs=column;
 
         while AllQs_for_analysis{columnForAllQs+experiment,3}(4)>minLengthSpikesAndEstQ
             columnForAllQs=columnForAllQs+50;
         end
          
        minLengthSpikesAndEstQ=min(length(AllQs_for_analysis{columnForAllQs+experiment,1}),length(data_for_analysis{column}));
        
        estQ=AllQs_for_analysis{columnForAllQs+experiment,1}';
        estQ=estQ(1:minLengthSpikesAndEstQ,:);

        RChoose=AllQs_for_analysis{columnForAllQs+experiment,2};
        trialsPerBlock=AllQs_for_analysis{columnForAllQs+experiment,3};
          trialsPerBlock=trialsPerBlock(find(trialsPerBlock<=length(estQ)));
          RChoose=RChoose(:,1:length(trialsPerBlock));
        choice=AllQs_for_analysis{columnForAllQs+experiment,4}(1:minLengthSpikesAndEstQ)';
        R=AllQs_for_analysis{columnForAllQs+experiment,5}(1:minLengthSpikesAndEstQ)';

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
           
            rStats=regstats(data_for_analysis_use_current_run(2:minLengthSpikesAndEstQ), [estQ(2:end,:) (1:length(estQ(2:end,:)))'...
                choice(1:end-1)' choice(2:end)' R(1:end-1)' R(2:end)'],'linear',whichstats);
            t=rStats.tstat;
            tvalue=t.t;
            tvaluesQlearningDoya=[tvaluesQlearningDoya ; tvalue(2) tvalue(3)];

    end

    tvaluesTot=[tvaluesTot ; tvalues];
    fvaluesTot=[fvaluesTot ; fvalues];
    abstvalues=tvalues;
    abstvalues(deletedRows,:)=[];
    abstvalues=(abs(abstvalues))>boundary;
    tRight=(abstvalues(:,1)-abstvalues(:,2))==1;
    tLeft=(abstvalues(:,2)-abstvalues(:,1))==1;
    tBoth=(abstvalues(:,2)+abstvalues(:,1))==2;
    tNone=(abstvalues(:,2)+abstvalues(:,1))==0;
    findValueNeurons=find(abstvalues(:,1)+abstvalues(:,2)==1);
    findValueNeuronsRight=find(abstvalues(:,1)==0 & abstvalues(:,2)==1);
    findValueNeuronsLeft=find(abstvalues(:,1)==1 & abstvalues(:,2)==0);
    ValueNeurons=[ValueNeurons ; nanmean(tRight) nanmean(tLeft) nanmean(tBoth) nanmean(tNone)];
    
    tvaluesTotQlearning=[tvaluesTotQlearning ; tvaluesQlearning];
    abstvaluesQlearning=tvaluesQlearning;
    abstvaluesQlearning(deletedRows,:)=[];
    abstvaluesQlearning=(abs(abstvaluesQlearning))>boundary;
    tRightQlearning=(abstvaluesQlearning(:,1)-abstvaluesQlearning(:,2))==1;
    tLeftQlearning=(abstvaluesQlearning(:,2)-abstvaluesQlearning(:,1))==1;
    tBothQlearning=(abstvaluesQlearning(:,2)+abstvaluesQlearning(:,1))==2;
    tNoneQlearning=(abstvaluesQlearning(:,2)+abstvaluesQlearning(:,1))==0;
    ValueNeuronsQlearning=[ValueNeuronsQlearning ; nanmean(tRightQlearning) nanmean(tLeftQlearning) nanmean(tBothQlearning) nanmean(tNoneQlearning)];
    
  
    tvaluesTotQlearningDoya=[tvaluesTotQlearningDoya ; tvaluesQlearningDoya];
    abstvaluesQlearningDoya=tvaluesQlearningDoya;
    abstvaluesQlearningDoya(deletedRows,:)=[];
    abstvaluesQlearningDoya=(abs(abstvaluesQlearningDoya))>2.64;
    tRightQlearningDoya=(abstvaluesQlearningDoya(:,1)-abstvaluesQlearningDoya(:,2))==1;
    tLeftQlearningDoya=(abstvaluesQlearningDoya(:,2)-abstvaluesQlearningDoya(:,1))==1;
    tBothQlearningDoya=(abstvaluesQlearningDoya(:,2)+abstvaluesQlearningDoya(:,1))==2;
    tNoneQlearningDoya=(abstvaluesQlearningDoya(:,2)+abstvaluesQlearningDoya(:,1))==0;
    ValueNeuronsQlearningDoya=[ValueNeuronsQlearningDoya ; nanmean(tRightQlearningDoya) nanmean(tLeftQlearningDoya) nanmean(tBothQlearningDoya) nanmean(tNoneQlearningDoya)];
   
    
end