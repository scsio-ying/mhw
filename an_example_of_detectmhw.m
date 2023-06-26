%% An example about how to apply detect_mhw to real-world data
% Here we provide an example about how to apply detect_mhw to real-world data.

%% 1. Loading data

% Load SST data, geographical domain of [140-180E, 5-20N], a resolution of 2, from 1982 to 2021.
load('sst');
size(sst); %size of data

%% 2. Detecting MHWs 

% Here we detect marine heatwaves in [140-180E, 5-20N] based on the
% traditional definition of MHWs (Hobday et al. 2016). 
% We detected MHWs during 2001 to 2020 for climatologies and thresholds in 1982 to 2011.
% tic
[MHW,mhw_ts]=detect_mhw(sst,datenum(1982,1,1):datenum(2021,12,31),datenum(1982,1,1),datenum(2011,12,31),datenum(2001,1,1),datenum(2020,12,31));
% toc
% Elapsed time is 2.297243 seconds.
% Have a look of the outputs.
MHW(1:4,:);
squeeze(mhw_ts(12,6,:));
%%