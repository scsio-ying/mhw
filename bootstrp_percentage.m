function [pmean, pstd,h] = bootstrp_percentage(x,k,nsample,nrepeat)
%%
% Description
% Bootstrap statistics - calculate statistics (mean and standard deviation) on 
% the percentage of different categories in the sample
%
% Input Arguments
% x -  A vector, contains integer values from 1 to k, representing different categories
% k -  Number of categories to be sorted
% nrepeat - Number of repeat captures of samples
% nsample - Number of samples per capture
%
% Output Arguments
% pmean -  The average of the estimated probabilities of occurrence for these categories
% pstd -  The standard deviation of the estimated probability for occurrence of these categories
% h - [1] mean value > standard deviation value [0] mean value <= standard deviation value
%
% Example
% x=randi([1 5],1,100);
% k=5;nsample=25;nrepeat=100;
% [pmean, pstd,h] = bootstrp_percentage(x,k,nsample,nrepeat);
%%
p=nan(k,nrepeat);
pmean=nan(k,1);
pstd=nan(k,1);
h=nan(k,1);

x1=x(~isnan(x));
if ~isempty(x1)
    x2=x1(randi(numel(x1),nsample,nrepeat));%Repeat capture subsample
    for i=1:nrepeat
        [pi,~,~]=histcounts(x2(:,i),[1:k+1],'normalization','probability');%Calculating probability of subsample
        p(:,i)=pi;
        clear pi
    end
% else
%        error(message('InputsNAN'));
end

pmean=nanmean(p,2);%Calculating the average
pstd=nanstd(p,0,2);%Calculating the standard deviation

if pmean>pstd %Determine if the mean is greater than the standard deviation
    h=1;
else
    h=0;
end 
