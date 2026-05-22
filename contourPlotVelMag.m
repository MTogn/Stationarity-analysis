%Simple function to create velocity magnitude plot; note that the
% parameters in plotParams must contain the fields HASBVec (a 1D array
% containing maxNumBins elements corresponding to the height above seabed
% for each of the measurement bins) and timeVec (a 1D array containing
% burstEndIndex elements which are the datetimes corresponding to each
% burst in the deployment).
%velMag can be passed to the function in either dimension alignment (burst-
% first or depth-first) but the burst dimension must be exactly
% burstEndIndex long.
function velMagFigHand = contourPlotVelMag(velMag,plotParams,burstStartIndex,burstEndIndex)

    [HASBArr,timeArr] = meshgrid(plotParams.HASBVec,plotParams.timeVec);
    switch size(velMag,1) == burstEndIndex
        case 1
            velMag = velMag';
    end
    velMagFigHand = figure;
    contourf(timeArr',HASBArr',velMag(1:length(plotParams.HASBVec),burstStartIndex:burstEndIndex),'LineStyle','none');
    set(gca,'FontSize',14)
    datetick('x','mmm-dd','keepticks','keeplimits')
    set(get(gca,'YLabel'),'String','Height above seabed (m)','FontSize',16)

    cb = colorbar;
    cb.Label.String = 'Velocity magnitude (ms^{-1})';
    cb.Label.FontSize = 16;

end