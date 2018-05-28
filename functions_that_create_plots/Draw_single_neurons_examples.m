function [] = Draw_single_neurons_examples(AllQs,num,ex1,ex2)

%figure('units','centimeters','position',[3 3 24 18])
figPosition=[0.1    0.62    0.43    0.14 ; 0.1    0.46   0.43    0.14 ]; 
locationTextBoxX=0.05;
locationTextBoxY=[0.9 0.8];
estQ=AllQs{num,1};
QForTrialReg=AllQs{num,7}; 
Q=AllQs{num,6};
modulation=AllQs{num,8};
trialsPerBlock=AllQs{num,3};

i=ex1;
a1=axes('position',figPosition(1,:));
Locs_Fonts{1}=figPosition;
Locs_Fonts{2}=[locationTextBoxX locationTextBoxY];
Locs_Fonts{3}=((trialsPerBlock)-10)/trialsPerBlock(4)*figPosition(1,3)+figPosition(1,1);
Locs_Fonts{4}=[figPosition(1,4)*3/4+figPosition(1,2)+0.01 figPosition(1,4)*3/4+figPosition(1,2)-0.03 ];
Locs_Fonts{5}=[mean(trialsPerBlock(1:2)-10)/trialsPerBlock(4)-0.03 0.85 ;...
   mean(trialsPerBlock(3:4)-10)/trialsPerBlock(4)-0.03 0.92];
Locs_Fonts{6}=[18 14];
Draw_single_neuron_subplot(QForTrialReg(:,i),[0.9 0.4 0.4],trialsPerBlock,modulation,Q(:,1),[0.9 0.4 0.4],estQ,Locs_Fonts);

i=ex2;   
a2=axes('position',figPosition(2,:));
Locs_Fonts{3}=((trialsPerBlock)-10)/trialsPerBlock(4)*figPosition(2,3)+figPosition(2,1);
Locs_Fonts{4}=[figPosition(2,4)*3/4+figPosition(2,2)+0.012 figPosition(2,4)*3/4+figPosition(2,2)-0.03 ];
Locs_Fonts{5}=[mean(trialsPerBlock(1:2)-10)/trialsPerBlock(4)-0.04 0.95 ;...
   mean(trialsPerBlock(3:4)-10)/trialsPerBlock(4)-0.03 0.88];
Locs_Fonts{6}=[14 18];
Draw_single_neuron_subplot(QForTrialReg(:,i),[ 0.3 0.3 0.8],trialsPerBlock,modulation,Q(:,2),[ 0.3 0.3 0.8],estQ,Locs_Fonts);
