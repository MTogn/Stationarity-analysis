%This function accepts a structure containing arrays of along-beam
%velocities in the as beamVelocityStructure.beamx for x = 1:4 or 1:5, with
%time along the first rank and depth along the second. It then truncates
%all beam records according to the length of the maximum useful bin -
%usually the highest bin before sidelobe interference makes measurements
%unreliable.
function beamVelocityStructure = truncateBeamVelocityDepthRange(beamVelocityStructure,maxUsefulBin)

for beamCtr = 1:length(beamVelocityStructure)
    beamVelocityStructure(beamCtr).beamVel = beamVelocityStructure(beamCtr).beamVel(:,1:maxUsefulBin);
end

end