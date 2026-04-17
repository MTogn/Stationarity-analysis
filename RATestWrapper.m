%This function examines whether mean velocity and TKE values are stationary
%over a burst (95% confidence level) based on the reverse arrangement test.

%Inputs:
% burstBeamVelocities: a structure containing one burst's worth of ADCP
% beam velocities s.t.
% burstBeamVelocities(beamCtr).beamVelocities(numTimeSteps,numBins)
% numInd: a 1D array containing the number of independent realisations
% expected over the burst duration based on the integral time scale (this
% must already be known). In most cases, numInd will be shorter than
% the maximum number of bins, as the ADCP is programmed to measure
% distances beyond the actual maximum water depth in order to avoid
% accidentally failing to measure real values near the surface; the zCtr
% loop therefore only goes as far as the length of numInd rather than up to
% the maximum bin number.

function isStationaryP95 = RATestWrapper(burstBeamVelocities,numInd,paramStruc)

%Calculate time series of mean velocity and TKE values based on the number
%of independent samples expected. Nominally this is calculated separately
%for each beam of the ADCP; for derived quantities such as velocity
%magnitude and TKE that draw on data from multiple beams, we conservatively
%choose the smallest values of Nind among the beams. indSampIndLength
%varies with depth because numInd does so as well.
indSampIndLength = ceil(max(size(burstBeamVelocities(1).beamVel))./numInd);

for zCtr = 1:length(numInd)
    sampCtr = 1; sampStartInd = 1; sampEndInd = indSampIndLength(zCtr);
    while sampEndInd < max(size(burstBeamVelocities(1).beamVel))
        velMagSeq(sampCtr) = calcVelMagSamp(burstBeamVelocities,sampStartInd,sampEndInd,zCtr,paramStruc);
        TKESeq(sampCtr) = calcTKESamp(burstBeamVelocities,sampStartInd,sampEndInd,zCtr,paramStruc);
        sampCtr = sampCtr + 1;
        sampStartInd = 1 + (sampCtr - 1)*indSampIndLength(zCtr);
        sampEndInd = sampCtr*indSampIndLength(zCtr);
    end
    %Perform RA test
    [isStationaryP95.velMagResult(zCtr),isStationaryP95.velMagA(zCtr),isStationaryP95.velMagAInf(zCtr),isStationaryP95.velMagASup(zCtr)] = RA_test(velMagSeq,1);
    [isStationaryP95.TKEResult(zCtr),isStationaryP95.TKEA(zCtr),isStationaryP95.TKEAInf(zCtr),isStationaryP95.TKEASup(zCtr)] = RA_test(velMagSeq,1);
end

end