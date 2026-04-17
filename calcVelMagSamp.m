%This is a shortened version of the velocity magnitude calculation used to
%reckon the stationarity of the mean velocity estimates.
function velMagSamp = calcVelMagSamp(burstVelocities,sampStartInd,sampEndInd,zCtr,paramStruc)

uMeanSamp = (mean(burstVelocities(2).beamVel(sampStartInd:sampEndInd,zCtr),1) - mean(burstVelocities(1).beamVel(sampStartInd:sampEndInd,zCtr),1))/(2*sin(paramStruc.beamAngle));
vMeanSamp = (mean(burstVelocities(3).beamVel(sampStartInd:sampEndInd,zCtr),1) - mean(burstVelocities(4).beamVel(sampStartInd:sampEndInd,zCtr),1))/(2*sin(paramStruc.beamAngle));
wMeanSamp = -(mean(burstVelocities(1).beamVel(sampStartInd:sampEndInd,zCtr),1) + mean(burstVelocities(2).beamVel(sampStartInd:sampEndInd,zCtr),1) + ...
    mean(burstVelocities(3).beamVel(sampStartInd:sampEndInd,zCtr),1) + mean(burstVelocities(4).beamVel(sampStartInd:sampEndInd,zCtr),1))/(4*cos(paramStruc.beamAngle));
velMagSamp = sqrt(uMeanSamp^2 + vMeanSamp^2 + wMeanSamp^2);

end