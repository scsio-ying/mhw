function sf = t_surfaceforcing(Qnet,Qdsw,mld,varargin)
% Description-surface forcing term of heat budget
% input
% Qnet - 3D daily net air-sea heat flux data to calculate surface forcing term of heat budget, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
% Qdsw - 3D daily downward shortwave radiation data to calculate surface forcing term of heat budget, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
% mld - 3D daily mixed-layer depth data to calculate surface forcing term of heat budget, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
% Q & Qdsw & mld must have the same dimensions.
% rho - seawater density, default is 1025 kg/m3.
% Cp - seawater heat capacity, default is 3986 J/(kg°„C).
% r,c1,c2 - defaults are 0.58,0.35,23, respectively.(Paulson and Simpon,1977)
% output
% sf -  surface forcing term of heat budget
%

paramNames = {'rho','Cp','r','c1','c2'};
defaults   = {1025,3986,0.58,0.35,23};

[rho,Cp,r,c1,c2]...
    = internal.stats.parseArgs(paramNames, defaults, varargin{:});

Qd=Qdsw.*(r.*exp(-mld./c1)+(1-r)*exp(-mld./c2));%shortwave radiation penetrating below the mixed layer
sf0=(Qnet-Qd)./rho./Cp./mld*3600*24; % unit:°Ê/day
sf=(sf0(:,:,1:end-1)+sf0(:,:,2:end))/2;
end 