function [passNums,figHand,plotHands,legHand] = statyVelMagAnys(isStationary,velMag,burstMaxBins,burstStartIndex,burstEndIndex,velBinVec,makePlots)

    arguments
        isStationary struct
        velMag
        burstMaxBins
        burstStartIndex
        burstEndIndex
        velBinVec
        makePlots = 0
    end

    for velBinCtr = 1:length(velBinVec) - 1
        velMagMask = (velMag > velBinVec(velBinCtr)) & (velMag <= velBinVec(velBinCtr + 1));
        passNums(velBinCtr) = passStatyTestCheck(isStationary,burstMaxBins,burstStartIndex,burstEndIndex,velMagMask);
    end
    velMagMask(:,:) = velMag > velBinVec(end);
    passNums(length(velBinVec)) = passStatyTestCheck(isStationary,burstMaxBins,burstStartIndex,burstEndIndex,velMagMask);

    if makePlots
        for binCtr = 1:length(velBinVec)
            velTestAPassFrac(binCtr) = passNums(binCtr).velPassP95Test/passNums(binCtr).numRecords;
            velTestBPassFrac(binCtr) = passNums(binCtr).velPassSlopeTest/passNums(binCtr).numRecords;
            TKETestAPassFrac(binCtr) = passNums(binCtr).TKEPassP95Test/passNums(binCtr).numRecords;
            TKETestBPassFrac(binCtr) = passNums(binCtr).TKEPassSlopeTest/passNums(binCtr).numRecords;
        end

        figHand = figure, hold on
        plotHands(1) = plot(velBinVec,velTestAPassFrac,'LineWidth',2)
        plotHands(2) = plot(velBinVec,velTestBPassFrac,'LineWidth',2)
        plotHands(3) = plot(velBinVec,TKETestAPassFrac,'LineWidth',2)
        plotHands(4) = plot(velBinVec,TKETestBPassFrac,'LineWidth',2)
        legHand = legend('Velocity - P95 test', 'Velocity - max slope test','TKE - P95 test','TKE - max slope test');
        legHand.Location = 'northwest';
        legHand.AutoUpdate = 'off';

        passNumsAll = passStatyTestCheck(isStationary,burstMaxBins,burstStartIndex,burstEndIndex,ones(size(isStationary)));
        line([velBinVec(1) velBinVec(end)],[passNumsAll.velPassP95Test/passNumsAll.numRecords passNumsAll.velPassP95Test/passNumsAll.numRecords],...
            'Color',get(plotHands(1),'Color'),'LineStyle','--')
        line([velBinVec(1) velBinVec(end)],[passNumsAll.velPassSlopeTest/passNumsAll.numRecords passNumsAll.velPassSlopeTest/passNumsAll.numRecords],...
            'Color',get(plotHands(2),'Color'),'LineStyle','--')
        line([velBinVec(1) velBinVec(end)],[passNumsAll.TKEPassP95Test/passNumsAll.numRecords passNumsAll.TKEPassP95Test/passNumsAll.numRecords],...
            'Color',get(plotHands(3),'Color'),'LineStyle','--')
        line([velBinVec(1) velBinVec(end)],[passNumsAll.TKEPassSlopeTest/passNumsAll.numRecords passNumsAll.TKEPassSlopeTest/passNumsAll.numRecords],...
            'Color',get(plotHands(4),'Color'),'LineStyle','--')

        set(gca,'FontSize',14)
        set(get(gca,'XLabel'),'String','Velocity bin (m \cdot s ^{-1})','FontSize',16)
        set(get(gca,'YLabel'),'String','Proportion passing test','FontSize',16)
    else
        figHand = NaN; plotHands = NaN; legHand = NaN;
    end

end