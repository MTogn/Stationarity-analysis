function passNums = passStatyTestCheck(isStationary,burstMaxBins,burstStartIndex,burstEndIndex,condMask)

    arguments
        isStationary
        burstMaxBins
        burstStartIndex
        burstEndIndex
        condMask = ones(size(isStationary))
    end

    passNums.numRecords = 0;
    passNums.velPassP95Test = 0; passNums.velPassSlopeTest = 0;
    passNums.TKEPassP95Test = 0; passNums.TKEPassSlopeTest = 0;
    for burstCtr = burstStartIndex:burstEndIndex
        for zCtr = 1:burstMaxBins(burstCtr)
            if condMask(burstCtr,zCtr) == 1,
                passNums.velPassP95Test = passNums.velPassP95Test + ~isStationary(burstCtr,zCtr).isNonZeroSlopeP95Vel;
                passNums.velPassSlopeTest = passNums.velPassSlopeTest + ~isStationary(burstCtr,zCtr).exceedsMaxSlopeVel;
                passNums.TKEPassP95Test = passNums.TKEPassP95Test + ~isStationary(burstCtr,zCtr).isNonZeroSlopeP95TKE;
                passNums.TKEPassSlopeTest = passNums.TKEPassSlopeTest + ~isStationary(burstCtr,zCtr).exceedsMaxSlopeTKE;
                passNums.numRecords = passNums.numRecords + 1;
            end
        end
    end

end