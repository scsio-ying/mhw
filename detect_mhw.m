function [MHW,mhw_ts]=detect_mhw(sst,time,cli_start,cli_end,mhw_start,mhw_end,varargin)
%  Description of detect_mhw
%
%  [MHW,mhw_ts]=detect_mhw(sst,time,cli_start,cli_end,mhw_start,mhw_end) returns
%  all detected MHW events (including all metrics of a MHW event) for the 3D matrix SST(m,n,t) 
%  and their corresponding spatial intensities for each day . 
%
%  Input Arguments
%
%   sst - 3D daily sea surface temperature to detect MHW events, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
%
%   time - datenum(start_year,start_month,start_day):datenum(end_year,end_month,end_day),
%   the start date and end date of your input data SST.
%
%   cli_start - datennum(yyyy,mm,dd), the start date for the period
%   across which the spatial climatology and threshold are calculated. 
%
%   cli_end - datennum(yyyy,mm,dd), the end year for the period
%   across which the spatial climatology and threshold are calculated. 
%
%   mhw_start - datennum(yyyy,mm,dd), the start year for the period
%   across which MHW events are detected. 
%
%   mhw_end - datennum(yyyy,mm,dd), the end year for the period 
%   across which MHW events are detected.
%
%   'Threshold' - Default is 0.9. Threshold percentile to detect MHW events
%
%   'windowHalfWidth' - Default is 5. Width of sliding window to calculate
%   spatial climatology and threshold. 
%
%   'smoothPercentileWidth' - Default is 31. Width of moving mean window to smooth 
%   spatial climatology and threshold.
%
%   'minDuration' - Default is 5. Minimum duration to accept a detection of MHW
%   event.
%
%   'maxGap' - Default is 2. Maximum gap accepting joining of MHW events.
%   
%
%  Output Arguments
%   
%   MHW - A table containing all detected MHW events where each row corresponds to
%   a particular event and each column corresponds to a metric.
%   Specified metrics are:
%       - mhw_onset - onset date of each event.
%       - mhw_end - end date of each event.
%       - mhw_dur - duration of each event.
%       - int_max - maximum intensity of each event.
%       - int_mean - mean intensity of each event.
%       - int_var - variance of intensity during each event.
%       - int_cum - cumulative intensity across each event.
%       - xloc - location of each event in x-dimension of SST.
%       - yloc - location of each event in y-dimension of SST. 
%
%   mhw_ts - A 3D matrix
%   (m-by-n-by-(datenum(MHW_end,1,1)-datenum(MHW_start)+1)) containing 
%   spatial intensity of MHW in each day.


% vEvent = 'MHW';
% vThreshold = 0.9;
% vWindowHalfWidth = 5;
% vsmoothPercentileWidth = 31;
% vminDuration = 5;
% vmaxGap = 2;
% 
% This is a modified version of the function "detect" from the "m_mhw" Matlab toolbox
% (Copyright (C) <2019>  <ZijieZhao> https://github.com/ZijieZhaoMMHW/m_mhw1.0), 
% released by YZ in April 2023, 
% following the iterms in GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007.

paramNames = {'Threshold','WindowHalfWidth','smoothPercentileWidth','minDuration',...
    'maxGap'};
defaults   = {0.9,5,31,5,2};

[vThreshold,vWindowHalfWidth,vsmoothPercentileWidth,vminDuration,vmaxGap]...
    = internal.stats.parseArgs(paramNames, defaults, varargin{:});

%% Calculating climatology and thresholds

%%  "What if cli_start-window or cli_end+window exceeds the time range of data"
[nx,ny,~]=size(sst);

ahead_date=time(1)-(cli_start-vWindowHalfWidth);
after_date=cli_end+vWindowHalfWidth-time(end);
sst_clim=sst(:,:,time>=cli_start-vWindowHalfWidth & time<=cli_end+vWindowHalfWidth);

if ahead_date>0 && after_date>0
    sst_clim=cat(3,NaN(size(sst_clim,1),size(sst_clim,2),ahead_date), ...
        sst_clim,NaN(size(sst_clim,1),size(sst_clim,2),after_date));
elseif ahead_date>0 && after_date<=0
    sst_clim=cat(3,NaN(size(sst_clim,1),size(sst_clim,2),ahead_date), ...
        sst_clim);
elseif ahead_date<=0 && after_date>0
    sst_clim=cat(3, ...
        sst_clim,NaN(size(sst_clim,1),size(sst_clim,2),after_date));
else
end

%%
date_true=datevec(cli_start-vWindowHalfWidth:cli_end+vWindowHalfWidth);
date_true=date_true(:,1:3);

date_false = date_true;
date_false(:,1) = 2012;

fake_doy = day(datetime(date_false),'dayofyear');
mclimtt = 1:length(date_false);

mclim=NaN(nx,ny,366);
m90=NaN(nx,ny,366);

for i=1:366
    if i == 60
        
    else
        mclimtt_fake=mclimtt;
        mclimtt_fake(fake_doy==i & ~ismember(datenum(date_true),cli_start:cli_end))=nan;
        
    m90(:,:,i) = quantile(sst_clim(:,:,any(mclimtt_fake'>=(mclimtt_fake(fake_doy == i)-vWindowHalfWidth) & mclimtt_fake' <= (mclimtt_fake(fake_doy ==i)+vWindowHalfWidth),2)),vThreshold,3);
    mclim(:,:,i) = mean(sst_clim(:,:,any(mclimtt_fake'>=(mclimtt_fake(fake_doy == i)-vWindowHalfWidth) & mclimtt_fake' <= (mclimtt_fake(fake_doy ==i)+vWindowHalfWidth),2)),3,'omitnan');
    end
end
% Dealing with Feb29
m90(:,:,60) = mean(m90(:,:,[59 61]),3,'omitnan');
mclim(:,:,60) = mean(mclim(:,:,[59 61]),3,'omitnan');

% Smoothing threshold and climatology

m90long=smoothdata(cat(3,m90,m90,m90),3,'movmean',vsmoothPercentileWidth);
m90=m90long(:,:,367:367+365);
mclimlong=smoothdata(cat(3,mclim,mclim,mclim),3,'movmean',vsmoothPercentileWidth);
mclim=mclimlong(:,:,367:367+365);

date_mhw=datevec(mhw_start:mhw_end);
date_mhw(:,1)=2000;
datetoday = day(datetime(date_mhw),'dayofyear');

sst_mhw=sst(:,:,time>=mhw_start & time<=mhw_end);

ts=str2double(string(datestr(mhw_start:mhw_end,'YYYYmmdd')));
nt=length(ts);
mhw_ts=zeros(nx,ny,nt);

MHW=[];

%% Detecting MHW in each grid
     
        for i=1:nx
            for j=1:ny
                
                mhw_ts(i,j,isnan(squeeze(sst_mhw(i,j,:))))=nan;
                
                if sum(isnan(squeeze(sst_mhw(i,j,:))))~=size(sst_mhw,3)
                    
                    maysum=zeros(size(sst_mhw,3),1);
                    
                    maysum(squeeze(sst_mhw(i,j,:))>=squeeze(m90(i,j,datetoday)))=1;
                    
                    trigger=0;
                    potential_event=[];
                    
                    for n=1:size(maysum,1)
                        if trigger==0 && maysum(n)==1
                            start_here=n;
                            trigger=1;
                        elseif trigger==1 && maysum(n)==0
                            end_here=n-1;
                            trigger=0;
                            potential_event=[potential_event;[start_here end_here]];
                        elseif n==size(maysum,1) && trigger==1 && maysum(n)==1
                            trigger=0;
                            end_here=n;
                            potential_event=[potential_event;[start_here end_here]];
                        end
                    end
                    
                    if ~isempty(potential_event)
                        
                        potential_event=potential_event((potential_event(:,2)-potential_event(:,1)+1)>=vminDuration,:);
                        
                        if ~isempty(potential_event)
                            
                            gaps=(potential_event(2:end,1) - potential_event(1:(end-1),2) - 1);
                            
                            while min(gaps)<=vmaxGap
                               
                                potential_event(find(gaps<=vmaxGap),2)=potential_event(find(gaps<=vmaxGap)+1,2);
                                loc_should_del=(find(gaps<=vmaxGap)+1);
                                loc_should_del=loc_should_del(~ismember(loc_should_del,find(gaps<=vmaxGap)));
                                potential_event(loc_should_del,:)=[];
                                gaps=(potential_event(2:end,1) - potential_event(1:(end-1),2) - 1);
                            end
                            
                            mhwstart=NaN(size(potential_event,1),1);
                            mhwend=NaN(size(potential_event,1),1);
                            mduration=NaN(size(potential_event,1),1);
                            mhwint_max=NaN(size(potential_event,1),1);
                            mhwint_mean=NaN(size(potential_event,1),1);
                            mhwint_var=NaN(size(potential_event,1),1);
                            mhwint_cum=NaN(size(potential_event,1),1);
                            
                            for le=1:size(potential_event,1)
                                event_here=potential_event(le,:);
                                endtime=ts(event_here(2));
                                starttime=ts(event_here(1));
                                mcl=squeeze(mclim(i,j,datetoday(event_here(1):event_here(2))));
                                mrow=squeeze(sst_mhw(i,j,event_here(1):event_here(2)));
                                manom=mrow-mcl;
                                mhw_ts(i,j,event_here(1):event_here(2))=manom;
                                
                                [maxanom,~]=nanmax(squeeze(manom));
                                
                                mhwint_max(le)=...
                                    maxanom;
                                mhwint_mean(le)=...
                                    mean(manom);
                                mhwint_var(le)=...
                                    std(manom);
                                mhwint_cum(le)=...
                                    sum(manom);
                                mhwstart(le)=starttime;
                                mhwend(le)=endtime;
                                mduration(le)=event_here(2)-event_here(1)+1;
                            end
                            MHW=[MHW;[mhwstart mhwend mduration mhwint_max mhwint_mean mhwint_var mhwint_cum repmat(i,size(mhwstart,1),1) repmat(j,size(mhwstart,1),1)]];
                        end
                    end
                end
                
                
                
                
            end
        end
        

MHW=table(MHW(:,1),MHW(:,2),MHW(:,3),MHW(:,4),MHW(:,5),MHW(:,6),MHW(:,7),MHW(:,8),MHW(:,9),...
    'variablenames',{'mhw_onset','mhw_end','mhw_dur','int_max','int_mean','int_var','int_cum','xloc','yloc'});
