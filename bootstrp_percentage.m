function [pmean, pstd,h] = bootstrp_percentage(x,k,nsample,nrepeat)
%BOOTSTRP Bootstrap statistics.
% input
% x -  A vector, contains integer values from 1 to k, representing different categories
% k -  Number of categories to be sorted
% nrepeat - Number of repeat captures of samples
% nsample - Number of samples per capture
% output
% pmean -  The average of the estimated probabilities of occurrence of these categories
% pstd -  The variance of the estimated probability of occurrence of these categories
% h - Number of repeat captures of samples
%
% Example
% x=randi([1 5],1,100);
% k=5;nsample=25;nrepeat=100;
% [pmean, pstd,h] = bootstrp_percentage(x,k,nsample,nrepeat);
p=nan(k,nrepeat);
pmean=nan(k,1);
pstd=nan(k,1);
h=nan(k,1);

x1=x(~isnan(x));
if ~isempty(x1)
    x2=x1(randi(numel(x1),nsample,nrepeat));
    for i=1:nrepeat
        [pi,~,~]=histcounts(x2(:,i),[1:k+1],'normalization','probability');
        p(:,i)=pi;
        clear pi
    end
end

pmean=nanmean(p,2);
pstd=nanstd(p,0,2);

h(pmean>pstd)=1;
end 
