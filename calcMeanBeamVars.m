%Calculation of mean beam variances for different averaging periods scaled
%by the beam variance of the complete burst data set.

function meanBeamVarStationarities = calcMeanBeamVars(beamVarStationarities,burstSubset)

commonDepthElements = length(beamVarStationarities(burstSubset(1)).b1Var);
for burstCtr = 1:length(burstSubset)
    commonDepthElements = min(commonDepthElements,length(beamVarStationarities(burstSubset(burstCtr)).b1Var));
end

meanBeamVarStationarities.b1VarStatyScaled = zeros(4,commonDepthElements);
meanBeamVarStationarities.b2VarStatyScaled = zeros(4,commonDepthElements);
meanBeamVarStationarities.b3VarStatyScaled = zeros(4,commonDepthElements);
meanBeamVarStationarities.b4VarStatyScaled = zeros(4,commonDepthElements);
for burstCtr = 1:length(burstSubset)
    profBins = length(beamVarStationarities(burstSubset(burstCtr)).b1VarStatyScaled);
    meanBeamVarStationarities.b1VarStatyScaled = meanBeamVarStationarities.b1VarStatyScaled + beamVarStationarities(burstSubset(burstCtr)).b1VarStatyScaled(:,(profBins - commonDepthElements + 1):profBins);
    meanBeamVarStationarities.b2VarStatyScaled = meanBeamVarStationarities.b2VarStatyScaled + beamVarStationarities(burstSubset(burstCtr)).b2VarStatyScaled(:,(profBins - commonDepthElements + 1):profBins);
    meanBeamVarStationarities.b3VarStatyScaled = meanBeamVarStationarities.b3VarStatyScaled + beamVarStationarities(burstSubset(burstCtr)).b3VarStatyScaled(:,(profBins - commonDepthElements + 1):profBins);
    meanBeamVarStationarities.b4VarStatyScaled = meanBeamVarStationarities.b4VarStatyScaled + beamVarStationarities(burstSubset(burstCtr)).b4VarStatyScaled(:,(profBins - commonDepthElements + 1):profBins);
end
meanBeamVarStationarities.b1VarStatyScaled = meanBeamVarStationarities.b1VarStatyScaled/(length(burstSubset));
meanBeamVarStationarities.b2VarStatyScaled = meanBeamVarStationarities.b2VarStatyScaled/(length(burstSubset));
meanBeamVarStationarities.b3VarStatyScaled = meanBeamVarStationarities.b3VarStatyScaled/(length(burstSubset));
meanBeamVarStationarities.b4VarStatyScaled = meanBeamVarStationarities.b4VarStatyScaled/(length(burstSubset));