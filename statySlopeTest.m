function stationaryTestParams = statySlopeTest(burstBeamVelocities,idxLength,paramStruc)

    indSampIndLength = floor(max(size(burstBeamVelocities(1).beamVel))./idxLength);
    
    for zCtr = 1:length(idxLength)
        sampCtr = 1; sampStartInd = 1; sampEndInd = indSampIndLength(zCtr);
        while sampEndInd < max(size(burstBeamVelocities(1).beamVel))
            velMagSeq(zCtr,sampCtr) = calcVelMagSamp(burstBeamVelocities,sampStartInd,sampEndInd,zCtr,paramStruc);
            TKESeq(zCtr,sampCtr) = calcTKESamp(burstBeamVelocities,sampStartInd,sampEndInd,zCtr,paramStruc);
            timeSeq(zCtr,sampCtr) = (sampStartInd - 1)/paramStruc.sampFreq;
            sampCtr = sampCtr + 1;
            sampStartInd = 1 + (sampCtr - 1)*indSampIndLength(zCtr);
            sampEndInd = sampCtr*indSampIndLength(zCtr);
        end
    
    %Generate linear fit for velocity
        velMagFitVals = velMagSeq(zCtr,:)';
        timeSeqFitVals = timeSeq(zCtr,:)'; timeSeqFitVals = [ones(size(timeSeqFitVals)), timeSeqFitVals];
        [b,bint] = regress(velMagFitVals,timeSeqFitVals);
    
    %Assign outputs
        stationaryTestParams(zCtr).bestFitSlopeVel = b(2);
        stationaryTestParams(zCtr).p95SlopeLimsVel = bint(2,:);
        stationaryTestParams(zCtr).isNonZeroSlopeP95Vel = ~((bint(2,1) < 0) & (bint(2,2) > 0));
        stationaryTestParams(zCtr).exceedsMaxSlopeVel = 60*abs(b(2)) > paramStruc.statySlope*mean(velMagFitVals);
    
    %Repeat for TKE
        TKEFitVals = TKESeq(zCtr,:)';
        [b,bint] = regress(TKEFitVals,timeSeqFitVals);
    
        stationaryTestParams(zCtr).bestFitSlopeTKE = b(2);
        stationaryTestParams(zCtr).p95SlopeLimsTKE = bint(2,:);
        stationaryTestParams(zCtr).isNonZeroSlopeP95TKE = ~((bint(2,1) < 0) & (bint(2,2) > 0));
        stationaryTestParams(zCtr).exceedsMaxSlopeTKE = 60*abs(b(2)) > paramStruc.statySlope*mean(TKEFitVals);
    
    end

end