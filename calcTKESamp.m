%This is a shortened version of the TKE calculation used to reckon the
%stationarity of the TKE estimates.
function TKESamp = calcTKESamp(burstVelocities,sampStartInd,sampEndInd,zCtr,paramStruc)

if ~exist('paramStruc.anisoParam'),
    paramStruc.anisoParam = 0.1684;
end

%For the beam velocity data, time should be the first dimension and depth
%the second.
for beamCtr = 1:4
    if size(burstVelocities(beamCtr).beamVel,1) < size(burstVelocities(beamCtr).beamVel,2)
        burstVelocities(beamCtr).beamVel = burstVelocities(beamCtr).beamVel';
    end
%Note that we create a field within the input structure here, but this does
%not persist outside the function call.
    burstVelocities(beamCtr).beamVar = var(burstVelocities(beamCtr).beamVel(sampStartInd:sampEndInd,zCtr),1,1);
end

TKESamp = sum(cat(3,burstVelocities.beamVar),3);
TKESamp = TKESamp/(4*(sin(paramStruc.beamAngle)^2)*(1 + (2*(cot(paramStruc.beamAngle)^2) - 1)*paramStruc.anisoParam));

end