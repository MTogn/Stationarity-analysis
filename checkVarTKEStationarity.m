function beamVarStationarities = checkVarTKEStationarity(burstBeamVelocities,paramStruc,statyDurations)

arguments
    burstBeamVelocities
    %paramStruc contains important parameters of the ADCP instrument
    %geometry and the deployment
    paramStruc
    %By default, we calculate stationarity for time delays of 1, 2, 5 & 10
    %minutes at 2Hz.
    statyDurations = [60 120 300 600]
end

%statyIndices must be int-valued.
statyIndices = round(statyDurations*paramStruc.sampFreq);
for beamCtr = 1:4
    beamVarStatyStruc(beamCtr).beamVar = var(burstBeamVelocities(beamCtr).beamVel,1,1);
    beamVarStatyStruc(beamCtr).beamVarStaty = nan(length(statyIndices),size(beamVarStatyStruc(beamCtr).beamVar,2));
    for lengthCtr = 1:length(statyIndices)
        beamVarStatyStruc(beamCtr).beamVarStaty(lengthCtr,:) = var(burstBeamVelocities(beamCtr).beamVel(1:statyIndices(lengthCtr),:),1,1);
    end
    beamVarStatyStruc(beamCtr).beamVarStatyScaled = beamVarStatyStruc(beamCtr).beamVarStaty./repmat(beamVarStatyStruc(beamCtr).beamVar,4,1);
end
burst4BeamTKEStruc.fourBeamTKE = beamVarStatyStruc(1).beamVar + beamVarStatyStruc(2).beamVar + beamVarStatyStruc(3).beamVar + beamVarStatyStruc(4).beamVar;
burst4BeamTKEStruc.fourBeamTKE = burst4BeamTKEStruc.fourBeamTKE/(4*(sin(paramStruc.beamAngle)^2)*(1 + (2*(cot(paramStruc.beamAngle)^2) - 1)*paramStruc.anisoParam));
burst4BeamTKEStruc.fourBeamTKEStaty = beamVarStatyStruc(1).beamVarStaty + beamVarStatyStruc(2).beamVarStaty + beamVarStatyStruc(3).beamVarStaty + beamVarStatyStruc(4).beamVarStaty;
burst4BeamTKEStruc.fourBeamTKEStaty = burst4BeamTKEStruc.fourBeamTKEStaty/(4*(sin(paramStruc.beamAngle)^2)*(1 + (2*(cot(paramStruc.beamAngle)^2) - 1)*paramStruc.anisoParam));
burst4BeamTKEStruc.fourBeamTKEStatyScaled = burst4BeamTKEStruc.fourBeamTKEStaty./repmat(burst4BeamTKEStruc.fourBeamTKE,4,1);

beamVarStationarities.beamVarStatyStruc = beamVarStatyStruc;
beamVarStationarities.burst4BeamTKEStruc = burst4BeamTKEStruc;

end