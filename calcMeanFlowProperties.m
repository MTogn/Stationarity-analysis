%This version of calcMeanFlowProperties is based on measurements taken from
%a Teledyne RDI Sentinel V ADCP.
%The function calculates the mean flow properties for a single burst i.e.,
%to calculate mean properties across a whole deployment it must be called
%in a loop over all bursts in the deployment.
function meanFlow = calcMeanFlowProperties(beamVelocityStruc,paramStruc)

%Per the "Sentinel V Real-Time Operation Manual" (version from May 2022),
%in the discussion of system orientation in Chapter 8 (and in particular
%figures 107 & 108), when the ADCP is pointed downwards the transducers are
%numbered 3-2-4-1 clockwise. An upward-looking ADCP will then have
%transducers numbered 3-1-4-2. We take transducer 3 as defining positive
%y-direction and transducer 1 as defining positive x-direction. The manual
%also specifies that fluid velocity is positive towards the ADCP. The mean
%velocity components are therefore calculated as below.
meanFlow.uMean = (mean(beamVelocityStruc(2).beamVel,1) - mean(beamVelocityStruc(1).beamVel,1))/(2*sin(paramStruc.beamAngle));
meanFlow.vMean = (mean(beamVelocityStruc(3).beamVel,1) - mean(beamVelocityStruc(4).beamVel,1))/(2*sin(paramStruc.beamAngle));
meanFlow.wMean = -(mean(beamVelocityStruc(1).beamVel,1) + mean(beamVelocityStruc(2).beamVel,1) + ...
    mean(beamVelocityStruc(3).beamVel,1) + mean(beamVelocityStruc(4).beamVel,1))/(4*cos(paramStruc.beamAngle));
meanFlow.devRelFlowDirn = atan(meanFlow.uMean./meanFlow.vMean);