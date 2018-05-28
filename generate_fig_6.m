%example for trial design without solution to policy in
%possible_solution_trial_design_experiment

%solution also to policy
close all
clear all
addpath(genpath(pwd));
%generate fig
figure('units','centimeters','position',[1 1 20 15]);
[~ ,regOnPolicyState,~ ]=Qlearning_action_value_and_RW_trial_design_for_fig_4_and_6();
samVec=[round(linspace(50,19990,500))];
alpha=2;
thres=2;
mSize=2.5;
axSize=8;
sample_size=1000;
 Draw_scatter_plot_on_policy_and_state([regOnPolicyState.action_value(samVec,1:2) ; 100 axSize],thres,2.5,[ 0.1    0.600    0.24     0.32],'action-value neurons');
 mTextBox = text(-0.4,1.1,'A','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
 Draw_two_bar_plots_policy_and_state(regOnPolicyState.action_value(:,1:2),thres,1000,[ 0.37   0.600     0.16     0.32],0);
 mTextBox = text(-0.12,1.1,'B','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
 Draw_scatter_plot_on_policy_and_state( [regOnPolicyState.random_walk(samVec,1:2) ; 100 axSize],thres,2.5,[ 0.1    0.100     0.24     0.32],'random-walk neurons');
  mTextBox = text(-0.4,1.1,'C','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
 Draw_two_bar_plots_policy_and_state(regOnPolicyState.random_walk(:,1:2),thres,1000,[ 0.37   0.100       0.16     0.32],0);
  mTextBox = text(-0.12,1.1,'D','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');


%%
 figure('units','centimeters','position',[1 -5 20 15]);
[regOnPolicyState_policy]=direct_policy_trial_design_for_fig_6();
 Draw_scatter_plot_on_policy_and_state( [regOnPolicyState_policy(samVec,1:2) ; 100 axSize],thres,2.5,[ 0.1    0.600   0.24     0.32],'policy neurons');
   mTextBox = text(-0.4,1.1,'E','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
 Draw_two_bar_plots_policy_and_state(regOnPolicyState_policy(:,1:2),thres,1000,[ 0.37   0.600   0.16     0.32],0);
  mTextBox = text(-0.12,1.1,'F','interpreter','tex',...
    'Units','Normalized','FontSize',22,'Color','k','FontWeight','bold');
