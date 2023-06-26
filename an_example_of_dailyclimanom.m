%% An example about how to apply detect_mhw to real-world data
% Here we provide an example about how to apply detect_mhw to real-world data.

%% 1. Loading data

% Load SST data, geographical domain of [140-180E, 5-20N], a resolution of 2, from 1982 to 2021.
load('sst');
size(sst); %size of data

%% 2. Calculating climatology and anomaly

% Here we calculated sst climatologies and anomalies in [140-180E, 5-20N]. 
% tic
[ssta,sstm]=dailyclimanom(sst,datenum(1982,1,1):datenum(2021,12,31),datenum(1982,1,1),datenum(2011,12,31));
% toc
% Elapsed time is 0.595268 seconds.
% Have a look of the outputs.
ssta(:,:,1);
sstm(:,:,1);
%%
