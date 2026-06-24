%A function to calculate the number of (burst, depth) pairs from an ADCP
%record that pass the P95 and max slope stationarity tests as implemented
%in statySlopeTest, with an optional condition passed as a mask within the
%inputs.

%Outputs:
%passNums - a structure containing the number of records that pass each of
%the four tests, and the total number of records covered by the mask.

%Inputs:
%isStationary - a structure of size (burstEndIndex,max(burstMaxBins))
%produced as an output of statySlopeTest. Each entry includes fields that
%characterise whether velocity and TKE pass the two stationarity tests of
%that function.
%burstMaxBins - an array of length burstEndIndex, containing the maximum
%number of bins for each burst with useful data.
%burstStartIndex, burstEndIndex - the first and last index numbers of
%bursts in the ADCP record
%condMask - a Boolean mask equal in size to isStationary (although it can
%be passed transposed). True entries are included in the sum of records
%passing each stationarity test, false entries are excluded.
function passNums = passStatyTestCheck(isStationary,burstMaxBins,burstStartIndex,burstEndIndex,condMask)

    arguments
        isStationary
        burstMaxBins
        burstStartIndex
        burstEndIndex
        condMask = ones(size(isStationary))
    end

    %Depending on what flags have been switched on and which analyses
    %performed, condMask dimensions may be ordered (depth, burst) instead
    %of (burst, depth) as required for this analysis.
    if size(condMask,2) == burstEndIndex, condMask = condMask'; end
    passNums.numRecords = 0;
    passNums.velPassP95Test = 0; passNums.velPassSlopeTest = 0;
    passNums.TKEPassP95Test = 0; passNums.TKEPassSlopeTest = 0;
    for burstCtr = burstStartIndex:burstEndIndex
        for zCtr = 1:burstMaxBins(burstCtr)
            if condMask(burstCtr,zCtr) == 1,
                passNums.velPassP95Test = passNums.velPassP95Test + ~isStationary(burstCtr,zCtr).isNonZeroSlopeP95Vel;
                passNums.velPassSlopeTest = passNums.velPassSlopeTest + ~isStationary(burstCtr,zCtr).exceedsMaxSlopeVel;
                passNums.TKEPassP95Test = passNums.TKEPassP95Test + ~isStationary(burstCtr,zCtr).isNonZeroSlopeP95TKE;
                passNums.TKEPassSlopeTest = passNums.TKEPassSlopeTest + ~isStationary(burstCtr,zCtr).exceedsMaxSlopeTKE;
                passNums.numRecords = passNums.numRecords + 1;
            end
        end
    end

end