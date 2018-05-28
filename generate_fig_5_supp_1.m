%generate Fig. 5 - Fig. supplement 1
close all
clear all
addpath(genpath(pwd));
%figure of correlation of choice with action-value
[reg_policy, regTrial_policy , regChoiceInReg_policy ,AllQs]=direct_policy_policy_neurons();
f=figure('units','centimeters','Position',[1 1 20 18/24*20]);
%draw scatter bar and plots for prob. choice with choice in regression
i=2;
samVec=[round(linspace(i,20000,500))];
Draw_scatter_plot(regChoiceInReg_policy(samVec,1:2),2,2.5,[0.1 0.6 0.24 0.32],0);
mTextBox = text(-0.4,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_four_bar_plots(regChoiceInReg_policy(:,1:2),2,1000,[0.37 0.6 0.16 0.32],0,[0 -0.05 -0.05 0.15]);

%draw scatter bar and plots wang
i=2;
session=98;
neuron2=5;
neuron1=2;
samVec=[round(linspace(i,20000,498)) 20*(session-1)+neuron1 20*(session-1)+neuron2];
etaPlace=1;
Draw_scatter_plot_unbiased(reg_policy(samVec,:),0.05,2.5,[0.1 0.1 0.24 0.32],0);
mTextBox = text(-0.4,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
Draw_four_bar_plots_unbiased(reg_policy(:,:),0.05,1000,[0.37 0.1 0.16 0.32],0.05,[0 0 -0.1 0.1]);
%%
%find only neurons who are not correlated with choice
whichstats={'tstat','fstat'};
regTrial_choice_not_sig=[];
count_significant=0;
for session =1:1000
for neuron=1:20
    policy_neurons=AllQs{session,8};
    choice=AllQs{session,4}';
    estQ= AllQs{session,6}';
    rStats=regstats(policy_neurons(neuron,:), choice,'linear',whichstats);
            t=rStats.tstat;
            pvalue=t.pval;
             if pvalue(2)>0.05
                rStats=regstats(policy_neurons(neuron,:),estQ,'linear',whichstats); 
                           t=rStats.tstat;
                           tvalue_new=t.t;
                           regTrial_choice_not_sig=[regTrial_choice_not_sig ; tvalue_new(2) tvalue_new(3)];
             else
              regTrial_choice_not_sig=[regTrial_choice_not_sig ; 0 0] ; 
              count_significant=count_significant+1;
             end
end
end
f=figure('units','centimeters','Position',[1 1 20 18/24*20]);
Draw_four_bar_plots(regTrial_choice_not_sig,2,1000,0,0)
diff=0;
for i=1:20000
    if ~isequal(regTrial_choice_not_sig(i,2),regTrial_policy(i,2))
        diff=diff+1;
    end
end