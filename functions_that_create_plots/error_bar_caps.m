function [] = error_bar_caps(X,Y,E,barWidth,lineWidth)
  W=barWidth/10;
  E=E*31/30;
  for b=X
      plot([X(b)-W X(b)-W; X(b)+W X(b)+W],[Y(b)-E(b) Y(b)+E(b) ; Y(b)-E(b) Y(b)+E(b)],'Color','k','lineWidth',lineWidth);
  end