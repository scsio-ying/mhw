%% An example about how to apply t_tendency, t_surfaceforcing, t_advection to real-world data
% Here we provide an example about how to apply t_tendency, t_surfaceforcing, t_advection to real-world data.
% 1. Loading data, geographical domain of [100-120E, 15-40S],from 2010,7,1-2011,6,30.
% 2. Calculating tendency, surface forcing, advection terms, respective.
% 3. Have a look of the outputs.
load('..code\mhw\dataset\mlt.mat');% Load mlt data, at a resolution of 1/4
% tic
tt = t_tendency(mlt);% Calculate mixed-layer temperature tendency
% toc
% Elapsed time is 0.031395 seconds.
%%
load('..code\mhw\dataset\Qnet.mat');% Load Qnet data, at a resolution of 2
load('..code\mhw\dataset\Qdsw.mat');% Load Qdsw data, at a resolution of 2
load('..code\mhw\dataset\mld.mat');% Load mld data, at a resolution of 2
% tic
sf = t_surfaceforcing(Qnet,Qdsw,mld);% Calculate surface heatflux forcing
% toc
% Elapsed time is 0.010435 seconds.
%%
load('..code\mhw\dataset\mlt.mat');% Load mlt data, at a resolution of 1/4
load('..code\mhw\dataset\mlu.mat');% Load mlu data, at a resolution of 1/4
load('..code\mhw\dataset\mlv.mat');% Load mlv data, at a resolution of 1/4
tic
[adv,advu,advv] = t_advection(mlt,mlu,mlv,lon,lat);% Calculate horizontal advection
toc
% Elapsed time is 0.211105 seconds.
%%
figure
subplot(2,2,1)
contourf(ttm')
subplot(2,2,2)
contourf(sfm')
subplot(2,2,3)
contourf(advm')
%%