function [figHand,axHand] = plotBurstVarStaty(beamVarStationarities,plotParams,statyDurations,legLabels)

arguments
    beamVarStationarities
    plotParams
    %By default, we calculate stationarity for time delays of 1, 2, 5 & 10
    %minutes at 2Hz.
    statyDurations = [60 120 300 600]
    legLabels = {'1 min', '2 min', '5 min', '10 min'}
end

figHand = figure;
for beamCtr = 1:4
    axHand(beamCtr) = subplot(2,2,beamCtr); hold on
    for durCtr = 1:size(beamVarStationarities,3)
        plot(beamVarStationarities(beamCtr,:,durCtr),plotParams.HASBVec)
    end
    line([1 1],[plotParams.HASBVec(1) plotParams.HASBVec(end)],'Color','k','LineStyle','--')
    title(["Beam " int2str(beamCtr)],'FontSize',16)
    set(gca,'FontSize',14)
end

legHand = legend(legLabels);
legHand.Location = 'southeast'; legHand.Box = 'off';

for axCtr = 1:4
    set(axHand(axCtr),'XLim',[0.8 1.2]);
end