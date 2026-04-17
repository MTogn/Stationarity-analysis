function [figHand,axHand] = plotBurstVarStaty(paramStruc,beamVarStationarities)

%This plots the profiles of scaled variance of all four beams at four
%different averaging periods (one beam per panel) to visualise stationarity
%for a single burst.
surfRelDepthVec = -paramStruc.binVertSize*((size(beamVarStationarities.b1VarStatyScaled,2) - 1):-1:0);

figHand = figure; axHand(1) = subplot(2,2,1); hold on
plot(beamVarStationarities.b1VarStatyScaled(1,:),surfRelDepthVec,'Color',[0.5 0.5 0.5],'LineWidth',2)
plot(beamVarStationarities.b1VarStatyScaled(2,:),surfRelDepthVec,'Color',[0.5 0.5 0.8],'LineWidth',2)
plot(beamVarStationarities.b1VarStatyScaled(3,:),surfRelDepthVec,'Color',[0.3 0.3 0.6],'LineWidth',2)
plot(beamVarStationarities.b1VarStatyScaled(4,:),surfRelDepthVec,'Color',[0.7 0.4 0.1],'LineWidth',2)
line([1 1],[surfRelDepthVec(1) surfRelDepthVec(end)],'Color','k','LineStyle','--')
title("Beam 1",'FontSize',16)
set(gca,'FontSize',14)
axHand(2) = subplot(2,2,2); hold on
plot(beamVarStationarities.b2VarStatyScaled(1,:),surfRelDepthVec,'Color',[0.5 0.5 0.5],'LineWidth',2)
plot(beamVarStationarities.b2VarStatyScaled(2,:),surfRelDepthVec,'Color',[0.5 0.5 0.8],'LineWidth',2)
plot(beamVarStationarities.b2VarStatyScaled(3,:),surfRelDepthVec,'Color',[0.3 0.3 0.6],'LineWidth',2)
plot(beamVarStationarities.b2VarStatyScaled(4,:),surfRelDepthVec,'Color',[0.7 0.4 0.1],'LineWidth',2)
line([1 1],[surfRelDepthVec(1) surfRelDepthVec(end)],'Color','k','LineStyle','--')
title("Beam 2",'FontSize',16)
set(gca,'FontSize',14)
axHand(3) = subplot(2,2,3); hold on
plot(beamVarStationarities.b3VarStatyScaled(1,:),surfRelDepthVec,'Color',[0.5 0.5 0.5],'LineWidth',2)
plot(beamVarStationarities.b3VarStatyScaled(2,:),surfRelDepthVec,'Color',[0.5 0.5 0.8],'LineWidth',2)
plot(beamVarStationarities.b3VarStatyScaled(3,:),surfRelDepthVec,'Color',[0.3 0.3 0.6],'LineWidth',2)
plot(beamVarStationarities.b3VarStatyScaled(4,:),surfRelDepthVec,'Color',[0.7 0.4 0.1],'LineWidth',2)
line([1 1],[surfRelDepthVec(1) surfRelDepthVec(end)],'Color','k','LineStyle','--')
title("Beam 3",'FontSize',16)
set(gca,'FontSize',14)
xLabHand = get(gca,'XLabel'); set(xLabHand,'String','Scaled beam variance','FontSize',14)
yLabHand = get(gca,'YLabel'); set(yLabHand,'String','Depth below surface (m)','FontSize',14)
xLabHand.Units = 'normalized'; yLabHand.Units = 'normalized';
xLabHand.Position(1) = 1.2; yLabHand.Position(2) = 1.2;
xLabHand.FontSize = 16; yLabHand.FontSize = 16;
axHand(4) = subplot(2,2,4); hold on
plot(beamVarStationarities.b4VarStatyScaled(1,:),surfRelDepthVec,'Color',[0.5 0.5 0.5],'LineWidth',2)
plot(beamVarStationarities.b4VarStatyScaled(2,:),surfRelDepthVec,'Color',[0.5 0.5 0.8],'LineWidth',2)
plot(beamVarStationarities.b4VarStatyScaled(3,:),surfRelDepthVec,'Color',[0.3 0.3 0.6],'LineWidth',2)
plot(beamVarStationarities.b4VarStatyScaled(4,:),surfRelDepthVec,'Color',[0.7 0.4 0.1],'LineWidth',2)
line([1 1],[surfRelDepthVec(1) surfRelDepthVec(end)],'Color','k','LineStyle','--')
title("Beam 4",'FontSize',16)
set(gca,'FontSize',14)
legHand = legend('1 min','2 min','5 min','10 min');
legHand.Location = 'southeast'; legHand.Box = 'off';

for axCtr = 1:4
    set(axHand(axCtr),'XLim',[0.8 1.2]);
end