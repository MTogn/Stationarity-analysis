%A function to calculate the integral time and length scales from a
%velocity time series

%Outputs:
%ILS, ITS - integral length scale, integral time scale

%Inputs:
%velocityTS - the velocity time series for which scales are to be
%calculated
%sampFreq - the sampling rate for velocityTS
%TaylorVel - the convection velocity used to convert the integral time
%scale into a lengthscale according to Taylor's frozen turbulence
%hypothesis

%Working variables:
%autocorr - the time-lagged autocorrelations of the velocity time series
%lag - the lag values corresponding to each element of autocov. Returned
%from xcorr as lags in # of elements and subsequently converted to lag in
%units of time

function [ILS,ITS] = calcIntScales(velocityTS,sampFreq,TaylorVel)

velocityTS = velocityTS - mean(velocityTS);
[autocorr,lag] = xcorr(velocityTS,'coeff');
lag = lag/sampFreq;

%xcorr returns two-sided outputs, so truncate
autocorr = autocorr(length(velocityTS):end); lag = lag(length(velocityTS):end);

%ITS should only be calculated up to the first zero crossing of autocorr
zcInds = find(autocorr(1:end - 1).*autocorr(2:end) < 0);
zcInds = zcInds(1);

ITS = trapz(lag(1:zcInds),autocorr(1:zcInds));
ILS = ITS*TaylorVel;