function [] = Draw_four_bar_plots_Wang(varargin)

regForPlotWang=varargin{1};
alphaWang=varargin{2};
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
      locationTextBoxY=[0 0 0];
    elseif length(varargin{6})==3
       locationTextBoxY=varargin{6};
       loc_textbox2=[0 0 0 0];
    else
       locationTextBoxY=[0 0 0];
       loc_textbox2=[0 0 0 0];
    end
else
       locationTextBoxY=[0 0 0];
       loc_textbox2=[0 0 0 0]; 
end

locationTextBoxX1=([0.33 1.33 2.3 3.3]./4);
locationTextBoxX2=([loc_textbox2+[0.1 1.2 2.3 3.3]]./4);
locationTextBoxY=([0.94 0.80 0.96]+locationTextBoxY);
colorPalette=[0.635 0.0784 0.184 ; 0 0 0.8 ;0.8 0.5 0 ; 0 0.749 0.749 ; 0 0 0 ; 0 0.498039215803146 0];

regForPlotWang(:,3)=regForPlotWang(:,3)<alphaWang;
regForPlotWang=[regForPlotWang atan2(regForPlotWang(:,2),regForPlotWang(:,1)) regForPlotWang(:,2).^2+regForPlotWang(:,1).^2];
regForPlotWangNotSig=regForPlotWang(regForPlotWang(:,3)==0,1:2);
regForPlotWangQ1=regForPlotWang(regForPlotWang(:,3)==1 & (regForPlotWang(:,4)>(7*pi/8) | regForPlotWang(:,4)<(-7*pi/8) | (regForPlotWang(:,4)>(-pi/8) & regForPlotWang(:,4)<(pi/8))),1:2);
regForPlotWangQ2=regForPlotWang(regForPlotWang(:,3)==1 & abs(regForPlotWang(:,4))>(3*pi/8) & abs(regForPlotWang(:,4))<(5*pi/8) ,1:2);
regForPlotWangDeltaQ=regForPlotWang(regForPlotWang(:,3)==1 & ((regForPlotWang(:,4)>(-3*pi/8) & regForPlotWang(:,4)<(-pi/8))|(regForPlotWang(:,4)>(5*pi/8) & regForPlotWang(:,4)<(7*pi/8))),1:2);
regForPlotWangState=regForPlotWang(regForPlotWang(:,3)==1 & ((regForPlotWang(:,4)>(pi/8) & regForPlotWang(:,4)<(3*pi/8))|(regForPlotWang(:,4)>(-7*pi/8) & regForPlotWang(:,4)<(-5*pi/8))),1:2);
Q1Fraction=size(regForPlotWangQ1,1)/size(regForPlotWang,1);
Q2Fraction=size(regForPlotWangQ2,1)/size(regForPlotWang,1);
DeltaQFraction=size(regForPlotWangDeltaQ,1)/size(regForPlotWang,1);
SigmaQFraction=size(regForPlotWangState,1)/size(regForPlotWang,1);
NotSigFraction=size(regForPlotWangNotSig,1)/size(regForPlotWang,1);

if length(supp)==4
 axes1=axes('position',supp);   
elseif supp
figure('units','centimeters','position',[3 3 24 18]);
set(gca,'position',[ 0.1    0.1300    0.15    0.12]);
else
axes1=axes('position',[ 0.37   0.1300     0.16    0.32]);
end




set(gca,'color','none');
hold on
b1=bar(1,Q1Fraction,'FaceColor',colorPalette(1,:),'EdgeColor','none');
bar(2,Q2Fraction,'FaceColor',colorPalette(2,:),'EdgeColor','none');
bar(3,DeltaQFraction,'FaceColor',colorPalette(3,:),'EdgeColor','none');
bar(4,SigmaQFraction,'FaceColor',colorPalette(4,:),'EdgeColor','none');
errorValues=sqrt([Q1Fraction*(1-Q1Fraction) Q2Fraction*(1-Q2Fraction) DeltaQFraction*(1-DeltaQFraction) SigmaQFraction*(1-SigmaQFraction)]./(sample_size-1));
e=errorbar(1:4,[Q1Fraction Q2Fraction DeltaQFraction SigmaQFraction],errorValues,'k','LineWidth',1.5,'LineStyle','none');
BarWidth=get(b1,'BarWidth');
error_bar_caps([1:4],[Q1Fraction Q2Fraction DeltaQFraction SigmaQFraction],errorValues,BarWidth,1.5);
plot([0.5 4.5],[alphaWang/4 alphaWang/4],'k--','LineWidth',2);
maxBar=max([Q1Fraction Q2Fraction DeltaQFraction SigmaQFraction]);
maxerrorValues=max(errorValues);
axis([0.5 4.5 0 (maxBar+maxerrorValues)*1.2+y_height]);
set(gca,'fontsize',12);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'color','none');


Fraction_text={round(Q1Fraction*100), round(Q2Fraction*100), round(DeltaQFraction*100), round(SigmaQFraction*100)};
for i=1:length(Fraction_text)
 if Fraction_text{i}>0
    Fraction_text{i}=num2str(Fraction_text{i});
 else
   vec=[Q1Fraction Q2Fraction DeltaQFraction SigmaQFraction];
   Fraction_text{i}=num2str(round(vec(i)*1000)/10);
 end
end
mTextBox = text(locationTextBoxX1(1),locationTextBoxY(1),'\itQ_1','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));

mTextBox = text(locationTextBoxX2(1),locationTextBoxY(2),[Fraction_text{1},'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(1,:));

mTextBox = text(locationTextBoxX1(2),locationTextBoxY(1),'\itQ_2','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));

mTextBox = text(locationTextBoxX2(2),locationTextBoxY(2),[Fraction_text{2},'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(2,:));

mTextBox = text(locationTextBoxX1(3),locationTextBoxY(3),'\it\Delta\itQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(3,:));

mTextBox = text(locationTextBoxX2(3),locationTextBoxY(2),[Fraction_text{3},'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(3,:));

mTextBox = text(locationTextBoxX1(4),locationTextBoxY(3),'\it\Sigma\itQ','interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(4,:));

mTextBox = text(locationTextBoxX2(4),locationTextBoxY(2),[Fraction_text{4},'%'],'interpreter','tex',...
    'Units','Normalized','FontSize',12,'Color',colorPalette(4,:));

    