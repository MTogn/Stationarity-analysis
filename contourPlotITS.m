%This function creates a figure containing four subfigures, each of which
%has a contour plot of the integral time scales for the four off-vertical
%beams of an ADCP across the duration of a deployment

%Inputs:
% - ITSDataStruc must be a structure with at least four entries
% ITSDataStruc(1:4). Each entry must have an array field beamITS containing
% the integral time scales for that beam; this field should be of the shape
% (1:burstEndIndex,1:maxNumBins), where maxNumBins is the maximum number of
% depth bins across the deployment duration
% - plotParams must be a structure containing at least the fields HASBVec
% (a 1D array containing maxNumBins elements corresponding to the height
% above seabed for each of the measurement bins) and timeVec (a 1D array
% containing burstEndIndex elements which are the datetimes corresponding
% to each burst in the deployment).
% - burstStartIndex and burstEndIndex are the numbers of the first and last
% burst that you want to visualise in the figure (e.g., if some bursts near
% the start or end of the record contain bad data)
%Outputs:
% - ITSFigHand and ITSAxHand are the object handles for the figure and the 
% four subfigure axes respectively
function [ITSFigHand,ITSAxHand] = contourPlotITS(ITSDataStruc,plotParams,burstStartIndex,burstEndIndex)

    [HASBArr,timeArr] = meshgrid(plotParams.HASBVec,plotParams.timeVec);
    
    ITSFigHand = figure;
    for beamCtr = 1:4
        ITSAxHand(beamCtr) = subplot(2,2,beamCtr);
        contourf(timeArr',HASBArr',ITSDataStruc(beamCtr).beamITS(burstStartIndex:burstEndIndex,1:length(plotParams.HASBVec))','LineStyle','none');
        set(ITSAxHand(beamCtr),'FontSize',14)
        datetick('x','mmm-dd','keepticks','keeplimits')
        ITSAxHand(beamCtr).Title.String = strcat("Beam ",int2str(beamCtr));
    end
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
    
    wholeFigAx = axes(gcf,'visible','off');
    wholeFigAx.YLabel.Visible = 'on'; ylabel(wholeFigAx,'Depth above seabed (m)')
    wholeFigAx.FontSize = 16
    
    cbAxPosTR = get(ITSAxHand(2), 'Position');
    cbAxPosBR = get(ITSAxHand(end), 'Position');
    % Create a new invisible axes positioned just to the right of the subplots
    cbAx = axes('Position', [cbAxPosBR(1) + cbAxPosBR(3) + 0.02, cbAxPosBR(2), 0.015, cbAxPosTR(2) + cbAxPosTR(4) - cbAxPosBR(2)], 'Visible', 'off');
    set(cbAx,'FontSize',14)
    
    % Add the colorbar to this dummy axes
    cb = colorbar(cbAx, 'Position', [cbAxPosBR(1) + cbAxPosBR(3) + 0.01, cbAxPosBR(2), 0.02, cbAxPosTR(2) + cbAxPosTR(4) - cbAxPosBR(2)]);
    
    % Set the colorbar limits to match your established range
    cb.Limits = [contLvlListStart contLvlListEnd];
    
    % Link the colorbar to one of your actual subplot axes for correct scaling
    cb.Axes.CLim = [contLvlListStart contLvlListEnd];
    
    cb.Label.String = 'Integral time scale (s)';
    cb.Label.FontSize = 16;
    tempLabelPos = cb.Label.Position; tempLabelPos(1) = tempLabelPos(1) + 5; cb.Label.Position = tempLabelPos;
    
    %Shift the two right-hand panels of the original plot leftward
    cbAxPosTR(1) = cbAxPosTR(1) - 0.03; set(ITSAxHand(2), 'Position', cbAxPosTR);
    cbAxPosBR(1) = cbAxPosBR(1) - 0.03; set(ITSAxHand(4), 'Position', cbAxPosBR);

end