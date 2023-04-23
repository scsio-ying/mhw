function [mt,mp]=maxtp(temp,p,n)
% Description
%
% [maxt,maxtp]=maxtp(temp,p) returns 
% the maxmimum value of the vertical temperature anomaly and the depth at which it is located.
%
%  Input Arguments
%
%   temp - A n-dimensional matrix of temp data (e.g.,temperature anomalies)
%   to calculate its vertical maximum and corresponding depth.   
%
%   p - Depth range of temperature
%   
%   n - Dimension of the temp data, n>=2 and n<=4.
%   if n=2, temp(lon/lat/t,p);if n=3, temp(lon,lat,p) or temp(lon/lat,t,p) 
%   if n=4, temp(lon,lat,t,p)
%
%  Input Arguments
%
%   maxt - A (n-1)D matrix containing vertical maximums.
%
%   maxtp - A (n-1)D matrix containing corresponding depth.
%
%  Example
%  temp=rand(1,10);p=[1:10];n=2
%  [mt,mp]=maxtp(temp,p,n);
%  temp=rand(3,10);p=[1:10];n=2;
%  [mt,mp]=maxtp(temp,p,n);
%  temp=rand(3,5,10);p=[1:10];n=3;
%  [mt,mp]=maxtp(temp,p,n);
%  temp=rand(3,5,4,10);p=[1:10];n=4;
%  [mt,mp]=maxtp(temp,p,n);

[a,b]=size(p);
if a==1 & b>a
    p=p';
end

[m,i]=max(temp,[],n);
mt=m;
mp=p(i);

end
%%
