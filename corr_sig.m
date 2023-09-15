function [r,h] = corr_sig(x,y,alpha)
% Description of Pearson's linear correlation coefficient
%
%  [r,h] = corr_sig(x,y,varargin) for two column vectors x and y return their
%  correlation coefficient and T-test result
%
%  Input Arguments
%  x & y - Two column vectors, have the same length. NaNs have already been removed.
%  alpha -  A number between 0 and 1 to specify a significance level of the
%  T-test. Default is 0.05 for 95% confidence intervals.
%                  
%  Output Arguments
%  r - Pearson's linear correlation coefficient
%  h - T-test result [1] Reject of Null Hypthesis [0] Insufficient evidence to reject the null hypothesis
%
%  Example
%  x=rand(100,1);y=rand(100,1);
%  [r,h]=corr_sig(x,y);
%% calculating pearson correlation
if numel(x)~=numel(y) %x and y must have the same length.
      error(message('XYmismatch'));
end

if nargin == 2 %Default is 0.05.
    alpha=0.05;
end

[m n]=size(x);
if m==1 & n>1
    x=x';
end
clear m n

[m n]=size(y);
if m==1 & n>1
    y=y';
end
clear m n
% Pearson correlation r
Sxy=cov(x,y);Sxy=Sxy(1,2);
r=Sxy/std(x)/std(y);
n=length(x);
% Effective degree of freedom vt
lags=1;
r_lagx=autocorr(x,lags);
r_lagy=autocorr(y,lags);
vtx=n*(1-r_lagx(2,1)^2)/(1+r_lagx(2,1)^2);
vty=n*(1-r_lagy(2,1)^2)/(1+r_lagy(2,1)^2);
vt=(vtx+vty)/2;
tt=floor(vt);
% Two-tailed T-test 
t_r=sqrt(n-2)*abs(r)/sqrt(1-r^2);
t_ref=tinv(1-alpha/2,tt);
if t_r>t_ref
    h=1;
else
    h=0;
end
end
