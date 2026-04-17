%The role of this function is to import the along-beam burst velocity
%records and the times (in datenums) corresponding to each timestep. Any
%filtering for bad data, spikes and excess tilt should be done within the
%function call, so that the output is a best approximation of the actual
%along-beam velocity time series.
function [burstEnsembleNos,burstDatenums,burstBeamVelocities] = importWADZBurst(burstCtr,tiltDataLong)

WADZDataAbsoluteLocation = 'C:\Users\michael\Documents\ADCP\DEMOZONE\burstData\';
burstData = load([WADZDataAbsoluteLocation 'burstData' int2str(burstCtr)]);
burstData = burstData.burstData;

% - For the WADZ data, the first column contains the ensemble number and
%the next 7 contain the time data.
% - Rows occur in groups of five; each group of five rows corresponds to a
%single record/time.
% - Within a group of five rows, row 1 contains beam 1 data, row 2 contains
%beam 2 data etc.

dataRecordLength = size(burstData,1);
burstEnsembleNos = burstData(1:5:dataRecordLength,1);
burstYear = burstData(1:5:dataRecordLength,2);
burstMonth = burstData(1:5:dataRecordLength,3);
burstDay = burstData(1:5:dataRecordLength,4);
burstHour = burstData(1:5:dataRecordLength,5);
burstMinute = burstData(1:5:dataRecordLength,6);
burstSecond = burstData(1:5:dataRecordLength,7) + burstData(1:5:dataRecordLength,8)/100;
burstDatenums = datenum(burstYear,burstMonth,burstDay,burstHour,burstMinute,burstSecond);

%After loading beam velocities into the structure, we filter the raw data
%for NaNs (or values of -32678, equal to -8000 in hex, which is the 'bad
%data' value in the RDI Workhorse firmware), and we normalise by 1000 since
%the raw data is in mms-1 rather than ms-1.

%We must also filter for times of excess tilt. For the WADZ data, tilt data
%is stored in a file in the immediate parent directory of the directory
%containing the burst data. It is better to keep the whole-record tilt data
%in the workspace rather than load the file containing the data with each
%call to this function.
%The tilt data replicates the ensemble numbers and time/date
%data included in the burst files containing the velocity records; only one
%of these is needed to find the portion of the whole-deployment tilt data
%corresponding to each shorter-duration burst, so we discard the time/date
if ~exist('tiltDataLong','var')
    [tiltDataLong,~] = WADZPreprocessing();
end

for beamCtr = 1:5
    burstBeamVelocities(beamCtr).beamVel = burstData(beamCtr:5:dataRecordLength,9:end);
    burstBeamVelocities(beamCtr).beamVel = NaNFilterv2(burstBeamVelocities(beamCtr).beamVel)/1000;
    burstBeamVelocities(beamCtr).beamVel = excessTiltFilter(burstBeamVelocities(beamCtr).beamVel,...
                                            tiltDataLong(burstEnsembleNos(1):burstEnsembleNos(end),2),...
                                            tiltDataLong(burstEnsembleNos(1):burstEnsembleNos(end),3));
end

%Function end
end