function [cta]=cum_ta(ta,p)
% Description
% vertically cumulative temperature anomaly
%
%  Input Arguments
%   ta - ta(p),a vector
%   p - p(p),a vector
%
%  Otput Arguments
%
%   cta - vertically cumulative temperature anomaly.
%
%  Example
%  ta=rand(10,1);p=[1:10];
%  cta=cum_ta(ta,p);
[a,b]=size(ta);
if a==1 & b>a
    ta=ta';
end
clear a b

[a,b]=size(p);
if a==1 & b>a
    p=p';
end
clear a b
np=numel(p);
dp=nan(np,1);
dp(1,1)=p(1)-0;
dp(2:end,1)=p(2:end)-p(1:end-1);
for ip=1:np
    cta(ip)=sum(ta(1:ip).*dp(1:ip));
end
end