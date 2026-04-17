for burstCtr = burstStartIndex:burstEndIndex
    for beamCtr = 1:4
        check(beamCtr,1) = max(abs(beamVarStationarities(burstCtr).beamVarStatyStruc(beamCtr).beamVar - beamVarStationarities2(burstCtr).beamVarStatyStruc(beamCtr).beamVar));
        check(beamCtr,2) = max(max(abs(beamVarStationarities(burstCtr).beamVarStatyStruc(beamCtr).beamVarStaty - beamVarStationarities2(burstCtr).beamVarStatyStruc(beamCtr).beamVarStaty)));
        check(beamCtr,3) = max(max(abs(beamVarStationarities(burstCtr).beamVarStatyStruc(beamCtr).beamVarStatyScaled - beamVarStationarities2(burstCtr).beamVarStatyStruc(beamCtr).beamVarStatyScaled)));
        check(beamCtr,4) = max(abs(beamVarStationarities(burstCtr).burst4BeamTKEStruc.fourBeamTKE - beamVarStationarities2(burstCtr).burst4BeamTKEStruc.fourBeamTKE));
        check(beamCtr,5) = max(max(abs(beamVarStationarities(burstCtr).burst4BeamTKEStruc.fourBeamTKEStaty - beamVarStationarities2(burstCtr).burst4BeamTKEStruc.fourBeamTKEStaty)));
        check(beamCtr,6) = max(max(abs(beamVarStationarities(burstCtr).burst4BeamTKEStruc.fourBeamTKEStatyScaled - beamVarStationarities2(burstCtr).burst4BeamTKEStruc.fourBeamTKEStatyScaled)));
    end
end