function [tvg]=tempvergrad(temp,p)
% Description
% temperature vertical gradient
%
%  Input Arguments
%   ta - ta(lon,lat,p)
%   p - p(p)
%
%  Otput Arguments
%   tvg - temperature vertical gradient
%   
%
%  Example
%  load ts.mat temp lon lat p
%  [tvg]=tempvergrad(temp,p);
[nx ny np]=size(temp);
pm=repmat(reshape(p,1,1,np),nx,ny,1);
temp_df=diff(temp,1,3);
p_df=diff(pm,1,3);
tvg=temp_df./p_df;
end