function [adv,advu,advv] = t_advection(mlt,mlu,mlv,lon,lat)
% Description-advection term of heat budget
% input
% mlt - 3D daily mixed-layer temperature data to calculate advection term of heat budget, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
% mlu - 3D daily mixed-layer zonal velocity data to calculate advection term of heat budget, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
% mlv - 3D daily mixed-layer meridional velocity data to calculate advection term of heat budget, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
% mlt & mlu & mlv must have the same dimensions.
% lon -  A vector, longitude range of temperatures and horizontal
% velocity
% lat - A vector, latitude range of temperatures and horizontal
% velocity
% output
% adv -  horizontal advection term of heat budget
% advu -  zonal advection term of heat budget
% advv -  meridional advection term of heat budget
%
[nx,ny,nt]=size(mlt);
dx=zeros(nx,ny);
for j=1:length(lat)
    for i=2:length(lon)-1
        dx(i,j,:)=m_lldist([lon(i-1) lon(i+1)],[lat(j),lat(j)])*1e3;
    end
end
dx(1,:,:)=dx(2,:,:);
dx(end,:,:)=dx(end-1,:,:);
dy=m_lldist([lon(1),lon(1)],[lat(1),lat(2)])*1000*2;
%%
advu0=nan(nx,ny,nt);% unit:¡æ/day
advv0=nan(nx,ny,nt);% unit:¡æ/day
advu0(2:end-1,2:end-1,:)=-(mlu(2:end-1,2:end-1,:).*(mlt(3:end,2:end-1,:)-mlt(1:end-2,2:end-1,:))./dx(2:end-1,2:end-1,:))*3600*24;
advv0(2:end-1,2:end-1,:)=-(mlv(2:end-1,2:end-1,:).*(mlt(2:end-1,3:end,:)-mlt(2:end-1,1:end-2,:))/dy)*3600*24;
advu=(advu0(:,:,1:end-1)+advu0(:,:,2:end))/2;
advv=(advv0(:,:,1:end-1)+advv0(:,:,2:end))/2;
adv=advu+advv;
end 