%For the original WADZ data set, preprocessing tasks are gathered into the
%function WADZPreprocessing, which includes:
% - Loading and formatting tilt and depth data
[tiltDataLong,demozoneRawDepth] = WADZPreprocessing();

%Initialising some key parameters
paramStruc.beamAngle = 25*pi/180; paramStruc.anisoParam = 0.1684;
paramStruc.blankDist = 1.89; paramStruc.binVertSize = 0.6;
paramStruc.sampFreq = 2;
paramStruc.dataLocation = 'C:\Users\michael\Documents\ADCP\DEMOZONE\';
paramStruc.burstDurn = 15*60;
%statySlope expresses the threshold for slopes that are regarded as
%approximately stationary in terms of change with respect to the mean value
%over a minute - for instance a value of 0.02 corresponds to a slope
%giving 2% of change over a minute
paramStruc.statySlope = 0.02;