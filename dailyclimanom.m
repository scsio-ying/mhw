function [manom,mclim]=dailyclimanom(X,time,cli_start,cli_end,varargin)
% Description
%
% [manom,mclim]=dailyclimanom(X,time,cli_start,cli_end,varargin) returns
% the daily anomaly and climatology of the 3D matrix X(m,n,t).
%
%  Input Arguments
%
%   X - 3D daily data to calculate its climatology and anomaly, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension.
%
%   time - datenum(start_year,start_month,start_day):datenum(end_year,end_month,end_day),
%   the start date and end date of your input daily data X.
%
%   cli_start - datenum(start_yr,1,1) the first day of climatology period.
%
%   cli_end - datenum(end_yr,12,31) the last day of climatology period.
%
%  Output Arguments
%
%   manom - A 3D matrix (m-by-n-by-t) containing anomalies.
%
%   mclim - A 3D matrix (m-by-n-by-366) containing climatologies.
%

% vWindowHalfWidth = 5;
% vsmoothPercentileWidth = 31;

paramNames = {'WindowHalfWidth','smoothPercentileWidth'};
defaults   = {5,31};
[vWindowHalfWidth,vsmoothPercentileWidth]...
    = internal.stats.parseArgs(paramNames, defaults, varargin{:});
%% Calculating daily climatology
[nx ny nt]=size(X);

X_clim = cat(3,NaN(nx,ny,vWindowHalfWidth),X,NaN(nx,ny,vWindowHalfWidth));

date_true=datevec(cli_start-vWindowHalfWidth:cli_end+vWindowHalfWidth);
date_true=date_true(:,1:3);

date_false = date_true;
date_false(:,1) = 2000;

fake_doy = day(datetime(date_false),'dayofyear');
mclimtt = 1:length(date_false);

mclim=NaN(nx,ny,366);

for i=1:366
    if i == 60
        
    else

        mclimtt(fake_doy==i & ~ismember(datenum(date_true),cli_start:cli_end))=nan;
       
        mclim(:,:,i) = mean(X_clim(:,:,any(mclimtt'>=(mclimtt(fake_doy == i)-vWindowHalfWidth) & mclimtt' <= (mclimtt(fake_doy ==i)+vWindowHalfWidth),2)),3,'omitnan');
    end
end
% Dealing with Feb29
mclim(:,:,60) = mean(mclim(:,:,[59 61]),3,'omitnan');

% Smoothing threshold and climatology
mclimlong=smoothdata(cat(3,mclim,mclim,mclim),3,'movmean',vsmoothPercentileWidth);
mclim=mclimlong(:,:,367:367+365);

%% Calculating daily anomaly
date_anom=datevec(time);
date_anom(:,1)=2000;
datetoday = day(datetime(date_anom),'dayofyear');
manom=nan(nx,ny,nt);
for it=1:nt
    manom(:,:,it)=X(:,:,it)-mclim(:,:,datetoday(it));
end
end
%%
