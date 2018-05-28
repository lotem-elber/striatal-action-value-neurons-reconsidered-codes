function [] = Draw_two_bar_plots_policy_and_state(varargin)
tValues=varargin{1};
alpha=varargin{2};
sample_size=varargin{3};
if length(varargin)>4
    y_height=varargin{5};
else
    y_height=0;
end
supp=varargin{4};
if supp
y_height=y_height+0.05;
end
if length(varargin)>5
    if length(varargin{6})==4
      loc_textbox2=varargin{6};
      loc_textboxY=[0 0 0];
    elseif length(varargin{6})==3
       loc_textboxY=varargin{6};
       loc_textbox2=[ 0 0];
    else
       loc_textboxY=[0 0 0];
       loc_textbox2=[ 0 0];
    end
else
       loc_textboxY=[0 0 0];
       loc_textbox2=[0 0]; 
end

colorPalette=[0.635 0.0784 0.184 ; 0 0 0.8 ;0.8 0.5 0 ; 0 0.749 0.749 ; 0 0 0 ; 0 0.498039215803146 0];

FractionQ1=mean(abs(tValues(:,1))>alpha & abs(tValues(:,2))>alpha & sign(tValues(:,1))==sign(tValues(:,2)));
FractionQ2=mean(abs(tValues(:,1))>alpha & abs(tValues(:,2))>alpha & sign(tValues(:,1))~=sign(tValues(:,2)));
FractionSigmaQ=mean(abs(tValues(:,1))>alpha & abs(tValues(:,2))<alpha);
FractionPolicyQ=mean(abs(tValues(:,1))<alpha & abs(tValues(:,2))>alpha);


if length(supp)==4
    axes1=axes('position',supp);
elseif supp==1
figure('units','centimeters','position',[3 3 24 18]);
set(gca,'position',[ 0.1    0.1300    0.15  0.12]);
elseif supp==0
axes1=axes('position',[ 0.37    0.1300     0.16    0.32]);
end
locationTextBoxX1=([0.83 2.8]./4);
locationTextBoxX2=([loc_textbox2+[0.65 2.65]]./4);
locationTextBoxY=(loc_textboxY+[0.94 0.80 0.96]);



set(gca,'color','none');
hold on
b1=bar(1,FractionQ1,'FaceColor',colorPalette(1,:),'EdgeColor','none');
b2=bar(2,FractionQ2,'FaceColor',colorPalette(2,:),'EdgeColor','none');

errorValues=sqrt([FractionQ1*(1-FractionQ1) FractionQ2*(1-FractionQ2) ]./(sample_size-1));
p7=errorbar([1:2],[FractionQ1 FractionQ2 ],errorValues,'Color','k','LineWidth',1.5,'LineStyle','none');
barWidth=get(b2,'BarWidth');
error_bar_caps([1:2],[FractionQ1 FractionQ2 ],errorValues,barWidth,1.5);
real_alpha=tcdf(-alpha,77)*2;
plot([0.5 2.5],[real_alpha^2/2 real_alpha^2/2],'k--','LineWidth',2);
plot([0.5 2.5],[real_alpha/2 real_alpha/2],'--','Color',[0.5 0.5 0.5],'LineWidth',2);
maxBar=max([FractionQ1 FractionQ2]);
maxerrorValues=max(errorValues);
axis([0.5 2.5 0 0.24]);
set(gca,'fontsize',12);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'color','none');

percent_text={round(FractionQ1*100), round(FractionQ2*100)};
for i=1:length(percent_text)
 if percent_text{i}>10
    percent_text{i}=num2str(percent_text{i});
 else
     vec=[FractionQ1 FractionQ2];
  percent_text{i}=num2str(round(vec(i)*1000)/10);
 end
end

mTextBox = text(locationTextBoxX1(1),locationTextBoxY(1),'\itQ_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));

mTextBox = text(locationTextBoxX2(1),locationTextBoxY(2),[percent_text{1},'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));

mTextBox = text(locationTextBoxX1(2),locationTextBoxY(1),'\itQ_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));

mTextBox = text(locationTextBoxX2(2),locationTextBoxY(2),[percent_text{2},'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));
