% addpath('C:\Users\michael\Documents\WTIMTS\analysisCode\WADZSpecificScripts');
% addpath('C:\Users\michael\Documents\WTIMTS\analysisCode');

burstStartIndex = 5;
burstEndIndex = 1470;

dataPreprocessingWADZ;

for burstCtr = burstStartIndex:burstEndIndex;
    burstLoadingWADZ;

    b1VarStaty = nan(4,size(burstBeamVelocities.beam1,2));
    b2VarStaty = nan(4,size(burstBeamVelocities.beam2,2));
    b3VarStaty = nan(4,size(burstBeamVelocities.beam3,2));
    b4VarStaty = nan(4,size(burstBeamVelocities.beam4,2));

    b1Var = var(burstBeamVelocities.beam1,1,1);
    b2Var = var(burstBeamVelocities.beam2,1,1);
    b3Var = var(burstBeamVelocities.beam3,1,1);
    b4Var = var(burstBeamVelocities.beam4,1,1);

    burst4BeamTKE = b1Var + b2Var + b3Var + b4Var;
    burst4BeamTKE = burst4BeamTKE/(4*(sin(paramStruc.beamAngle)^2)*(1 + (2*(cot(paramStruc.beamAngle)^2) - 1)*paramStruc.anisoParam));

    %We calculate stationarity for time delays of 1, 2, 5 & 10 minutes
    statyIndices = [120,240,600,1200];
    for ctr = 1:4
        b1VarStaty(ctr,:) = var(burstBeamVelocities.beam1(1:statyIndices(ctr),:),1,1);
        b2VarStaty(ctr,:) = var(burstBeamVelocities.beam2(1:statyIndices(ctr),:),1,1);
        b3VarStaty(ctr,:) = var(burstBeamVelocities.beam3(1:statyIndices(ctr),:),1,1);
        b4VarStaty(ctr,:) = var(burstBeamVelocities.beam4(1:statyIndices(ctr),:),1,1);
    end
    burst4BeamTKEStaty = b1VarStaty + b2VarStaty + b3VarStaty + b4VarStaty;
    burst4BeamTKEStaty = burst4BeamTKEStaty/(4*(sin(paramStruc.beamAngle)^2)*(1 + (2*(cot(paramStruc.beamAngle)^2) - 1)*paramStruc.anisoParam));

    b1VarStatyScaled = b1VarStaty./repmat(b1Var,4,1);
    b2VarStatyScaled = b2VarStaty./repmat(b2Var,4,1);
    b3VarStatyScaled = b3VarStaty./repmat(b2Var,4,1);
    b4VarStatyScaled = b4VarStaty./repmat(b4Var,4,1);
    burst4BeamTKEStatyScaled = burst4BeamTKEStaty./repmat(burst4BeamTKE,4,1);

    if rem(burstCtr,10) == 0,
        fprintf("Burst # is %d \r",burstCtr)
    end

    beamVarStationarities(burstCtr).b1Var = b1Var; beamVarStationarities(burstCtr).b2Var = b2Var; beamVarStationarities(burstCtr).b3Var = b3Var; beamVarStationarities(burstCtr).b4Var = b4Var;
    beamVarStationarities(burstCtr).b1VarStaty = b1VarStaty; beamVarStationarities(burstCtr).b2VarStaty = b2VarStaty;
        beamVarStationarities(burstCtr).b3VarStaty = b3VarStaty; beamVarStationarities(burstCtr).b4VarStaty = b4VarStaty;
    beamVarStationarities(burstCtr).b1VarStatyScaled = b1VarStatyScaled; beamVarStationarities(burstCtr).b2VarStatyScaled = b2VarStatyScaled;
        beamVarStationarities(burstCtr).b3VarStatyScaled = b3VarStatyScaled; beamVarStationarities(burstCtr).b4VarStatyScaled = b4VarStatyScaled;
    beamVarStationarities(burstCtr).TKE = burst4BeamTKE; beamVarStationarities(burstCtr).TKEStaty = burst4BeamTKEStaty; beamVarStationarities(burstCtr).TKEStatyScaled = burst4BeamTKEStatyScaled;

end

%%
%New analysis Mar 26

b1ITS = nan(burstEndIndex,size(burstBeamVelocities.beam1,2)); b2ITS = nan(burstEndIndex,size(burstBeamVelocities.beam2,2));
    b3ITS = nan(burstEndIndex,size(burstBeamVelocities.beam1,2)); b4ITS = nan(burstEndIndex,size(burstBeamVelocities.beam4,2));
for burstCtr = burstStartIndex:burstEndIndex;
    burstLoadingWADZ;

    for zCtr = 1:size(burstBeamVelocities.beam1,2)
        [~,b1ITS(burstCtr,zCtr)] = calcIntScales(burstBeamVelocities.beam1(:,zCtr),paramStruc.sampFreq,0);
        [~,b2ITS(burstCtr,zCtr)] = calcIntScales(burstBeamVelocities.beam2(:,zCtr),paramStruc.sampFreq,0);
        [~,b3ITS(burstCtr,zCtr)] = calcIntScales(burstBeamVelocities.beam3(:,zCtr),paramStruc.sampFreq,0);
        [~,b4ITS(burstCtr,zCtr)] = calcIntScales(burstBeamVelocities.beam4(:,zCtr),paramStruc.sampFreq,0);
    end

    if rem(burstCtr,10) == 0,
        fprintf("Burst # is %d \r",burstCtr)
    end

end

%%
%Creating plots for the analysis above
plotParams.HASBVec = paramStruc.blankDist + paramStruc.binVertSize*(0:size(burstBeamVelocities.beam1,2));
plotParams.timeVec = wholeRecordDatenums(1,burstStartIndex:burstEndIndex);
[HASBArr,timeArr] = meshgrid(plotParams.HASBVec,plotParams.timeVec);

ITSFigHand = figure;
ITSAxHand(1) = subplot(2,2,1);
contourf(timeArr',HASBArr',b1ITS(burstStartIndex:burstEndIndex,1:length(plotParams.HASBVec))','LineStyle','none');
datetick('x','mmm-dd','keepticks','keeplimits')
ITSAxHand(2) = subplot(2,2,2);
contourf(timeArr',HASBArr',b2ITS(burstStartIndex:burstEndIndex,1:length(plotParams.HASBVec))','LineStyle','none');
datetick('x','mmm-dd','keepticks','keeplimits')
ITSAxHand(3) = subplot(2,2,3);
contourf(timeArr',HASBArr',b3ITS(burstStartIndex:burstEndIndex,1:length(plotParams.HASBVec))','LineStyle','none');
datetick('x','mmm-dd','keepticks','keeplimits')
ITSAxHand(4) = subplot(2,2,4);
contourf(timeArr',HASBArr',b4ITS(burstStartIndex:burstEndIndex,1:length(plotParams.HASBVec))','LineStyle','none');
datetick('x','mmm-dd','keepticks','keeplimits')

contLvlList = get(get(ITSAxHand(1),'Children'),'LevelList');
contLvlListStart = contLvlList(1); contLvlListEnd = contLvlList(end);
for beamCtr = 2:4
    contLvlList = get(get(ITSAxHand(beamCtr),'Children'),'LevelList');
    if contLvlList(1) < contLvlListStart, contLvlListStart = contLvlList(1); end
    if contLvlList(end) > contLvlListEnd, contLvlListEnd = contLvlList(end); end
end

for beamCtr = 1:4
    clim(ITSAxHand(beamCtr), [contLvlListStart contLvlListEnd])
end

%%
cbAxPosTR = get(ITSAxHand(2), 'Position');
cbAxPosBR = get(ITSAxHand(end), 'Position');
% Create a new invisible axes positioned just to the right of the subplots
cbAx = axes('Position', [cbAxPosBR(1) + cbAxPosBR(3) + 0.02, cbAxPosBR(2), 0.015, cbAxPosTR(2) + cbAxPosTR(4) - cbAxPosBR(2)], 'Visible', 'off');

% Add the colorbar to this dummy axes
cb = colorbar(cbAx, 'Position', [cbAxPosBR(1) + cbAxPosBR(3) + 0.01, cbAxPosBR(2), 0.02, cbAxPosTR(2) + cbAxPosTR(4) - cbAxPosBR(2)]);

% Set the colorbar limits to match your established range
cb.Limits = [contLvlListStart contLvlListEnd];

% Link the colorbar to one of your actual subplot axes for correct scaling
cb.Axes.CLim = [contLvlListStart contLvlListEnd];

%Shift the two right-hand panels of the original plot leftward
cbAxPosTR(1) = cbAxPosTR(1) - 0.03; set(ITSAxHand(2), 'Position', cbAxPosTR);
cbAxPosBR(1) = cbAxPosBR(1) - 0.03; set(ITSAxHand(4), 'Position', cbAxPosBR);

%%
%Overall mean profiles of scaled variance and TKE to visualise stationarity
cmnDepthProfLgth = length(beamVarStationarities(burstStartIndex).b1Var);
for burstCtr = (burstStartIndex + 1):burstEndIndex
    cmnDepthProfLgth = min(cmnDepthProfLgth,length(beamVarStationarities(burstCtr).b1Var));
end

meanBeamVarStationarities.b1VarStatyScaled = zeros(4,cmnDepthProfLgth);
meanBeamVarStationarities.b2VarStatyScaled = zeros(4,cmnDepthProfLgth);
meanBeamVarStationarities.b3VarStatyScaled = zeros(4,cmnDepthProfLgth);
meanBeamVarStationarities.b4VarStatyScaled = zeros(4,cmnDepthProfLgth);
for burstCtr = burstStartIndex:burstEndIndex
    profBins = length(beamVarStationarities(burstCtr).b1VarStatyScaled);
    meanBeamVarStationarities.b1VarStatyScaled = meanBeamVarStationarities.b1VarStatyScaled + beamVarStationarities(burstCtr).b1VarStatyScaled(:,(profBins - cmnDepthProfLgth + 1):profBins);
    meanBeamVarStationarities.b2VarStatyScaled = meanBeamVarStationarities.b2VarStatyScaled + beamVarStationarities(burstCtr).b2VarStatyScaled(:,(profBins - cmnDepthProfLgth + 1):profBins);
    meanBeamVarStationarities.b3VarStatyScaled = meanBeamVarStationarities.b3VarStatyScaled + beamVarStationarities(burstCtr).b3VarStatyScaled(:,(profBins - cmnDepthProfLgth + 1):profBins);
    meanBeamVarStationarities.b4VarStatyScaled = meanBeamVarStationarities.b4VarStatyScaled + beamVarStationarities(burstCtr).b4VarStatyScaled(:,(profBins - cmnDepthProfLgth + 1):profBins);
end
meanBeamVarStationarities.b1VarStatyScaled = meanBeamVarStationarities.b1VarStatyScaled/(burstEndIndex - burstStartIndex + 1);
meanBeamVarStationarities.b2VarStatyScaled = meanBeamVarStationarities.b2VarStatyScaled/(burstEndIndex - burstStartIndex + 1);
meanBeamVarStationarities.b3VarStatyScaled = meanBeamVarStationarities.b3VarStatyScaled/(burstEndIndex - burstStartIndex + 1);
meanBeamVarStationarities.b4VarStatyScaled = meanBeamVarStationarities.b4VarStatyScaled/(burstEndIndex - burstStartIndex + 1);

[meanStatyFig,meanStatyAxes] = plotBurstVarStaty(paramStruc,meanBeamVarStationarities);
%%
%Conditional mean profiles of scaled variance to visualise stationarity's
%dependence on wave conditions

expanCoeffs = load('C:\Users\M.Togneri\Documents\WTIMTS\Results\WADZ\results-150Depth15Width0p02AmpCap\completeWorkspace.mat').TKEExpanCoeffs;
waveBursts = find(expanCoeffs(:,1) > 0); waveBursts = waveBursts + burstStartIndex - 1;
nonwaveBursts = find(expanCoeffs(:,1) <= 0); nonwaveBursts = nonwaveBursts + burstStartIndex - 1;

%First for waves:
meanBeamVarStatysWave = calcMeanBeamVars(beamVarStationarities,waveBursts);
[meanWaveStatyFig,meanQVWStatyAxes] = plotBurstVarStaty(paramStruc,meanBeamVarStatysWave);

%Then non-waves
meanBeamVarStatysNonwave = calcMeanBeamVars(beamVarStationarities,nonwaveBursts);
[meanNonwaveStatyFig,meanNonwaveStatyAxes] = plotBurstVarStaty(paramStruc,meanBeamVarStatysNonwave);

%%
%Mean and conditioned mean profiles of TKE stationarity
cmnDepthProfLgth = length(beamVarStationarities(burstStartIndex).b1Var);
for burstCtr = (burstStartIndex + 1):burstEndIndex
    cmnDepthProfLgth = min(cmnDepthProfLgth,length(beamVarStationarities(burstCtr).TKEStatyScaled));
end

meanTKEStationarities = zeros(4,cmnDepthProfLgth);
for burstCtr = burstStartIndex:burstEndIndex
    profBins = length(beamVarStationarities(burstCtr).TKEStatyScaled);
    meanTKEStationarities = meanTKEStationarities + beamVarStationarities(burstCtr).TKEStatyScaled(:,(profBins - cmnDepthProfLgth + 1):profBins);
end
meanTKEStationarities = meanTKEStationarities/(burstEndIndex - burstStartIndex + 1);
surfRelDepthVecMean = -paramStruc.binVertSize*((size(meanTKEStationarities,2) - 1):-1:0);

cmnDepthProfLgth = length(beamVarStationarities(waveBursts(1)).b1Var);
for burstCtr = 2:length(waveBursts)
    cmnDepthProfLgth = min(cmnDepthProfLgth,length(beamVarStationarities(waveBursts(burstCtr)).TKEStatyScaled));
end
meanTKEStationaritiesWave = zeros(4,cmnDepthProfLgth);
for burstCtr = 1:length(waveBursts)
    profBins = length(beamVarStationarities(waveBursts(burstCtr)).TKEStatyScaled);
    meanTKEStationaritiesWave = meanTKEStationaritiesWave + beamVarStationarities(waveBursts(burstCtr)).TKEStatyScaled(:,(profBins - cmnDepthProfLgth + 1):profBins);
end
meanTKEStationaritiesWave = meanTKEStationaritiesWave/length(waveBursts);
surfRelDepthVecWave = -paramStruc.binVertSize*((size(meanTKEStationaritiesWave,2) - 1):-1:0);

cmnDepthProfLgth = length(beamVarStationarities(nonwaveBursts(1)).b1Var);
for burstCtr = 2:length(nonwaveBursts)
    cmnDepthProfLgth = min(cmnDepthProfLgth,length(beamVarStationarities(nonwaveBursts(burstCtr)).TKEStatyScaled));
end
meanTKEStationaritiesNonwave = zeros(4,cmnDepthProfLgth);
for burstCtr = 1:length(nonwaveBursts)
    profBins = length(beamVarStationarities(nonwaveBursts(burstCtr)).TKEStatyScaled);
    meanTKEStationaritiesNonwave = meanTKEStationaritiesNonwave + beamVarStationarities(nonwaveBursts(burstCtr)).TKEStatyScaled(:,(profBins - cmnDepthProfLgth + 1):profBins);
end
meanTKEStationaritiesNonwave = meanTKEStationaritiesNonwave/length(nonwaveBursts);
surfRelDepthVecNonwave = -paramStruc.binVertSize*((size(meanTKEStationaritiesNonwave,2) - 1):-1:0);

%Visualise this as a figure with three panels: top panel is the overall
%mean TKE dependence on averaging period, and the bottom two show
%dependence on wave conditions (or not)
TKEFigHand = figure;
TKEAxHands(1) = subplot(2,2,1); hold on
plot(meanTKEStationarities(1,:),surfRelDepthVecMean,'Color',[0.5 0.5 0.5],'LineWidth',2)
plot(meanTKEStationarities(2,:),surfRelDepthVecMean,'Color',[0.5 0.5 0.8],'LineWidth',2)
plot(meanTKEStationarities(3,:),surfRelDepthVecMean,'Color',[0.3 0.3 0.6],'LineWidth',2)
plot(meanTKEStationarities(4,:),surfRelDepthVecMean,'Color',[0.7 0.4 0.1],'LineWidth',2)
line([1 1],[surfRelDepthVecMean(1) surfRelDepthVecMean(end)],'Color','k','LineStyle','--')
%TKEAxHands(1).Position(2) = 0.5 - 0.5*TKEAxHands(1).Position(4);
title("Standardised mean TKE with different averaging times",'FontSize',16)
set(gca,'FontSize',14)
legHand = legend('1 min','2 min','5 min','10 min');
legHand.Location = 'eastoutside'; legHand.Box = 'off';

TKEAxHands(2) = subplot(2,2,3); hold on
plot(meanTKEStationaritiesWave(1,:),surfRelDepthVecWave,'Color',[0.5 0.5 0.5],'LineWidth',2)
plot(meanTKEStationaritiesWave(2,:),surfRelDepthVecWave,'Color',[0.5 0.5 0.8],'LineWidth',2)
plot(meanTKEStationaritiesWave(3,:),surfRelDepthVecWave,'Color',[0.3 0.3 0.6],'LineWidth',2)
plot(meanTKEStationaritiesWave(4,:),surfRelDepthVecWave,'Color',[0.7 0.4 0.1],'LineWidth',2)
line([1 1],[surfRelDepthVecWave(1) surfRelDepthVecWave(end)],'Color','k','LineStyle','--')
title("In wave conditions only",'FontSize',16)
set(gca,'FontSize',14)
xLabHand = get(gca,'XLabel'); set(xLabHand,'String','Standardised mean TKE','FontSize',14)
yLabHand = get(gca,'YLabel'); set(yLabHand,'String','Depth below surface (m)','FontSize',14)
xLabHand.Units = 'normalized'; yLabHand.Units = 'normalized';
xLabHand.Position(1) = 1.2; yLabHand.Position(2) = 1.2;
xLabHand.FontSize = 16; yLabHand.FontSize = 16;

TKEAxHands(3) = subplot(2,2,4); hold on
plot(meanTKEStationaritiesNonwave(1,:),surfRelDepthVecNonwave,'Color',[0.5 0.5 0.5],'LineWidth',2)
plot(meanTKEStationaritiesNonwave(2,:),surfRelDepthVecNonwave,'Color',[0.5 0.5 0.8],'LineWidth',2)
plot(meanTKEStationaritiesNonwave(3,:),surfRelDepthVecNonwave,'Color',[0.3 0.3 0.6],'LineWidth',2)
plot(meanTKEStationaritiesNonwave(4,:),surfRelDepthVecNonwave,'Color',[0.7 0.4 0.1],'LineWidth',2)
line([1 1],[surfRelDepthVecNonwave(1) surfRelDepthVecNonwave(end)],'Color','k','LineStyle','--')
title("In non-wave conditions only",'FontSize',16)
set(gca,'FontSize',14)

TKEAxHands(1).Position(3) = TKEAxHands(2).Position(3);
TKEAxHands(1).Position(1) = 0.5 - 0.5*TKEAxHands(1).Position(3);
TKEAxHands(1).XLim = [0.8 1.2]; TKEAxHands(2).XLim = [0.8 1.2]; TKEAxHands(3).XLim = [0.8 1.2];