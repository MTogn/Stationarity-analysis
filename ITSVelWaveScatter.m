%This function plots the scatter of ITS vs velocity magnitude and ITS vs
%wave height for all four off-vertical beams of an ADCP across a whole
%deployment.

%Inputs:
% - ITSStruc: a structure which should be of shape ITSStruc(1:4). Each
% entry must have an array field beamITS containing the integral time
% scales for the corresponding ADCP beam; this field should be of the shape
% (1:burstEndIndex,1:maxNumBins), where maxNumBins is the maximum number of
% depth bins across the deployment duration (but see note below).
% - velMagArray: an array of velocity magnitude values over the ADCP
% deployment, each entry corresponding to a particular burst at a
% particular depth. This should be of shape (1:burstEndIndex,1:burstMaxBin)
% but the function can accept velMagArray with transposed axes as well.
% - waveHeightRecord: a vector of the average significant wave height
% values for each burst of the ADCP deployment
% - burstMaxBins: a vector of the maximum bin number with meaningful data
% for each burst of the ADCP deployment.

%Outputs:
% - velITSFigHand,velITSAxHand: object handles for the figure and axes of
% the scatter plot of velocity magnitude vs ITS values
% - waveITSFigHand,waveITSAxHand: object handles for the figure and axes of
% the scatter plot of wave heights vs ITS values
% - ITSStruc: the same structure passed as an input with the fields
% velMagCorreln, velMagCorrelnP, waveMagCorreln,waveMagCorrelnP added.
% These are the correlation of velocity magnitude with ITS for each beam
% and its p=value, and the correlation of wave height with ITS for each
% beam and its p-value.
function [velITSFigHand,velITSAxHand,waveITSFigHand,waveITSAxHand,ITSStruc] = ITSVelWaveScatter(ITSStruc,velMagArray,waveHeightRecord,burstMaxBins)

%For a scatter plot, the velocity magnitude array and ITS arrays should be
%made into column vectors; to ensure a comparison is meaninful their
%dimensions must be consistent with one another.
if size(velMagArray,1) ~= size(ITSStruc(1).beamITS,1), velMagArray = velMagArray'; end
velMagVec = velMagArray(:);
velITSFigHand = figure;
for beamCtr = 1:4
    %If beamITS was calculated when burstMaxBins did not already exist in
    %the workspace, then it may have been calculated with a conservatively
    %larger estimate of the maximum bin number. To ensure compatible sizes
    %for the scatter plot, we truncate the beamITS fields along the depth
    %axis before flattening.
    ITSStruc(beamCtr).beamITSVec = ITSStruc(beamCtr).beamITS(:,1:max(burstMaxBins));
    ITSStruc(beamCtr).beamITSVec = ITSStruc(beamCtr).beamITSVec(:);
    velITSAxHand(beamCtr) = subplot(2,2,beamCtr);
    %Points with value (0,0) correspond to burst numbers where no good data
    %was collected, or points above the surface for times where water level
    %is lower: they are therefore excluded from the plot
    velMagVec_realPointsOnly = velMagVec((velMagVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    beamITSVec_realPointsOnly = ITSStruc(beamCtr).beamITSVec((velMagVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    scatter(velMagVec_realPointsOnly,beamITSVec_realPointsOnly,'Marker','.')
    velITSAxHand(beamCtr).Title.String = strcat("Beam ",int2str(beamCtr));
    velITSAxHand(beamCtr).FontSize = 14;
end
%Unify the limits of the y-scatter
scatterYLim = get(velITSAxHand(1),'YLim'); scatterYLimLo = scatterYLim(1); scatterYLimHi = scatterYLim(2);
for beamCtr = 2:4
    scatterYLim = get(velITSAxHand(beamCtr),'YLim');
    if scatterYLim(1) < scatterYLimLo, scatterYLimLo = scatterYLim(1); end
    if scatterYLim(2) > scatterYLimHi, scatterYLimHi = scatterYLim(2); end
end
scatterYLim = [scatterYLimLo, scatterYLimHi];
for beamCtr = 1:4
    set(velITSAxHand(beamCtr),'YLim',scatterYLim);
end

wholeFigAx = axes(gcf,'visible','off');
wholeFigAx.YLabel.Visible = 'on'; ylabel(wholeFigAx,'Integral time scale (s)');
wholeFigAx.XLabel.Visible = 'on'; xlabel(wholeFigAx,'Mean velocity magnitude (ms^{-1})');
wholeFigAx.FontSize = 16;

waveHeightsVec = waveHeightRecord(:)/100;
waveITSFigHand = figure;
for beamCtr = 1:4
    waveITSAxHand(beamCtr) = subplot(2,2,beamCtr);
    %Points with value (0,0) correspond to burst numbers where no good data
    %was collected, or points above the surface for times where water level
    %is lower: they are therefore excluded from the plot
    waveHeightsVec_realPointsOnly = waveHeightsVec((waveHeightsVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    beamITSVec_realPointsOnly = ITSStruc(beamCtr).beamITSVec((waveHeightsVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    scatter(waveHeightsVec_realPointsOnly,beamITSVec_realPointsOnly,'Marker','.')
    waveITSAxHand(beamCtr).Title.String = strcat("Beam ",int2str(beamCtr));
    waveITSAxHand(beamCtr).FontSize = 14;
end
%Unify the limits of the y-scatter
scatterYLim = get(waveITSAxHand(1),'YLim'); scatterYLimLo = scatterYLim(1); scatterYLimHi = scatterYLim(2);
for beamCtr = 2:4
    scatterYLim = get(waveITSAxHand(beamCtr),'YLim');
    if scatterYLim(1) < scatterYLimLo, scatterYLimLo = scatterYLim(1); end
    if scatterYLim(2) > scatterYLimHi, scatterYLimHi = scatterYLim(2); end
end
scatterYLim = [scatterYLimLo, scatterYLimHi];
for beamCtr = 1:4
    set(waveITSAxHand(beamCtr),'YLim',scatterYLim);
end

wholeFigAx = axes(gcf,'visible','off');
wholeFigAx.YLabel.Visible = 'on'; ylabel(wholeFigAx,'Integral time scale (s)');
wholeFigAx.XLabel.Visible = 'on'; xlabel(wholeFigAx,'Significant wave height (m)');
wholeFigAx.FontSize = 16;

%Check the correlation coefficients of the ITS-vel mag and ITS-wave height
%scatters; the significance levels are in the corresponding variable names
%appended with P.
for beamCtr = 1:4
    %Points with value (0,0) correspond to burst numbers where no good data
    %was collected, or points above the surface for times where water level
    %is lower: they are therefore excluded from the plot
    velMagVec_realPointsOnly = velMagVec((velMagVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    beamITSVec_realPointsOnly = ITSStruc(beamCtr).beamITSVec((velMagVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    %Setting the argument 'Rows' to 'complete' omits any NaN values from
    %the calculation
    [tempcorr,tempsig] = corrcoef(velMagVec_realPointsOnly,beamITSVec_realPointsOnly,'Rows','complete');
    ITSStruc(beamCtr).velMagCorreln = tempcorr(1,2); ITSStruc(beamCtr).velMagCorrelnP = tempsig(1,2);
    waveHeightsVec_realPointsOnly = waveHeightsVec((waveHeightsVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    beamITSVec_realPointsOnly = ITSStruc(beamCtr).beamITSVec((waveHeightsVec ~= 0) & (ITSStruc(beamCtr).beamITSVec ~= 0));
    [tempcorr,tempsig] = corrcoef(waveHeightsVec_realPointsOnly,beamITSVec_realPointsOnly,'Rows','complete');
    ITSStruc(beamCtr).waveHeightCorreln = tempcorr(1,2); ITSStruc(beamCtr).waveHeightCorrelnP = tempsig(1,2);
end

end