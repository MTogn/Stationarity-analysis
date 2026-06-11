function statyOutputStruc = checkVarTKEStationarity(burstBeamVelocities,paramStruc,statyDurations)

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
beamVar = nan(4,size(burstBeamVelocities(1).beamVel,2));
beamVarStaty = nan(4,size(burstBeamVelocities(1).beamVel,2),length(statyIndices));
beamVarStatyScaled = beamVarStaty;
for beamCtr = 1:4
    beamVar(beamCtr,:) = var(burstBeamVelocities(beamCtr).beamVel,1,1);
    for lengthCtr = 1:length(statyIndices)
        beamVarStaty(beamCtr,:,lengthCtr) = var(burstBeamVelocities(beamCtr).beamVel(1:statyIndices(lengthCtr),:),1,1);
    end
    beamVarStatyScaled = beamVarStaty./repmat(beamVar(beamCtr,:),[1 1 4]);
end
fourBeamTKE = sum(beamVar,1)/(4*(sin(paramStruc.beamAngle)^2)*(1 + (2*(cot(paramStruc.beamAngle)^2) - 1)*paramStruc.anisoParam));
fourBeamTKEStaty = sum(beamVarStaty,1)/(4*(sin(paramStruc.beamAngle)^2)*(1 + (2*(cot(paramStruc.beamAngle)^2) - 1)*paramStruc.anisoParam));
fourBeamTKEStatyScaled = fourBeamTKEStaty./repmat(fourBeamTKE,[1 1 4]);

statyOutputStruc.beamVar = beamVar;
statyOutputStruc.beamVarStaty = beamVarStaty;
statyOutputStruc.beamVarStatyScaled = beamVarStatyScaled;
statyOutputStruc.fourBeamTKE = fourBeamTKE;
statyOutputStruc.fourBeamTKEStaty = fourBeamTKEStaty;
statyOutputStruc.fourBeamTKEStatyScaled = fourBeamTKEStatyScaled;

end