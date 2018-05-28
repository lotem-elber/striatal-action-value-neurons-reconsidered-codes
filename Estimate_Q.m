function [estQ,estAlphaRem,estBetaRem] = Estimate_Q(choice,R,estAlphaRem,estBetaRem )

 %estimating Q from choice behavior
  %trying different Alphas and Betas
                %calculating real probability for a
                %starting randomly, i zooms in on ideal alpha and beta
                estAlpha=0.5;
                estBeta=2;
                for i=[0.1 0.01 0.001]
                    estAlphaVec=estAlpha-i*8:i:estAlpha+i*8;
                    estBetaVec=estBeta-i*25:i*5:estBeta+i*25;
                    estPr1=zeros(size(choice));
                    %errorValue designates error in probability of choosing group 1
                    %this error in sum of squares error
                    estErrorValue=zeros(length(estAlphaVec),length(estBetaVec));
                    
                    for estAlpha=estAlphaVec
                        for estBeta=estBetaVec
                            
                            estQ1=0.5;
                            estQ2=0.5;
                            estPr1(1)=[1/(1+exp(estBeta*(estQ2-estQ1)))];
                            for j=1:length(choice)-1
                                if choice(j)==1
                                    estQ1=(1-estAlpha)*estQ1+estAlpha*R(j);
                                else
                                    estQ2=(1-estAlpha)*estQ2+estAlpha*R(j);
                                end
                                estPr1(j+1)=[1/(1+exp(estBeta*(estQ2-estQ1)))];
                            end
                            
                            probChoice=estPr1.*choice+(1-estPr1).*(1-choice);
                            errorValue(find(estAlpha==estAlphaVec),find(estBeta==estBetaVec))=-sum(log(probChoice));
                            
                        end
                    end
          
                    [ minVec row]=min(errorValue);
                    [minE column ]=min(minVec);
                    estBeta=estBetaVec(column);
                    estAlpha=estAlphaVec(row(column));
                    
                end
                estAlphaRem=[estAlphaRem estAlpha];
                estBetaRem=[estBetaRem estBeta];
                estQ=[0.5 ; 0.5];
                for j=1:length(choice)-1
                    if choice(j)==1
                        estQ=[estQ [(1-estAlpha)*estQ(1,end)+estAlpha*R(j) ; estQ(2,end)]];
                    else
                        estQ=[estQ [estQ(1,end) ; (1-estAlpha)*estQ(2,end)+estAlpha*R(j)]];
                    end
                end
                
end

