[burstEnsembleNos,burstDatenums,burstBeamVelocities] = importWADZBurst(burstCtr,tiltDataLong);
wholeRecordEnsNos(:,burstCtr) = [burstEnsembleNos(1); burstEnsembleNos(end)];
wholeRecordDatenums(:,burstCtr) = [burstDatenums(1); burstDatenums(end)];
[burstDepths(burstCtr),burstMaxBins(burstCtr)] = demozoneDepthPreprocessing(paramStruc,demozoneRawDepth,wholeRecordEnsNos(:,burstCtr),burstCtr);
for beamCtr = 1:length(burstBeamVelocities)
    burstBeamVelocities(beamCtr).beamVel = burstBeamVelocities(beamCtr).beamVel(:,1:burstMaxBins(burstCtr));
end