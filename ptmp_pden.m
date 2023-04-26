function [ptmp,pden]=ptmp_pden(salt,temp,p,pr)
% Description--Potential temperature
%
% INPUT:  
%   (salt and temp must have same dimensions, salt(lon/lat,p) or salt(lonxlat,p) or salt(lon,lat))
%   salt  = salinity    [psu      (PSS-78) ]
%   temp  = temperature [degree C (ITS-90)]
%   p  = pressure    [db]
%   pr = Reference pressure  [db]  
%   (p & pr may have dims 1x1, mx1, 1xn or mxn for salt(mxn) )
%
% OUTPUT:
%   ptmp = Potential temperature relative to PR [degree C (ITS-90)]
%   pden = Potential denisty relative to the ref. pressure [kg/m^3]
%
% EXAMPLE
% load ts.mat
% [nx ny np]=size(salt);
% s0=reshape(salt,nx*ny,np);
% t0=reshape(temp,nx*ny,np);
% p0=p';
% pr=0;
% [ptmp,pden]=ptmp_pden(s0,t0,p0,pr);
% ptmp=reshape(ptmp,nx,ny,np);
% pden=reshape(pden,nx,ny,np);
% 
% load ts.mat
% [nx ny np]=size(salt);
% s0=salt(:,:,1);
% t0=temp(:,:,1);
% p0=p(1);
% pr=0;
% [ptmp,pden]=ptmp_pden(s0,t0,p0,pr);
%
ptmp=sw_ptmp(salt,temp,p,pr);
pden=sw_pden(salt,temp,p,pr);
end
%%
