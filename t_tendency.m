function tt = t_tendency(mlt)
% Description-temperature tendency term of heat budget
% input
% mlt - 3D daily mixed-layer temperature data to calculate tendency of heat budget, specified as a
%   three dimensions matrix m-by-n-by-t. m and n separately indicate two spatial dimensions
%   and t indicates temporal dimension. 
% output
% tt -  temperature tendency
%
tt=mlt(:,:,2:end)-mlt(:,:,1:end-1);% unit:¡æ/day
end 
