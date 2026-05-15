function isStationaryP95 = statySlopeTest(burstBeamVelocities,idxLength,paramStruc)

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

%Calculate max permissible slope
    velMagMaxSlope(zCtr) = paramStruc.statySlope*mean(velMagSeq(zCtr,1:idxLength(zCtr)));
    TKEMaxSlope(zCtr) = paramStruc.statySlope*mean(TKESeq(zCtr,1:idxLength(zCtr)));

%Generate linear fit
    [b,bint,r,rint,stats] = regress(velMagSeq(zCtr,:),timeSeq(zCtr,sampCtr));

%Placeholder line to assign something to the output
    isStationaryP95(zCtr).stats = stats;
end

end