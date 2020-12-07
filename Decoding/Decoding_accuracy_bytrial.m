function aveT=Decoding_accuracy_bytrial(Mat)
% used to transfer decoding accuracy to aligned trial by trial
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 2019.
% last updated: November 5,2019.

aveT=nan(80,length(Mat));
for m=1:length(Mat)
    tM=Mat{1, m};
    nBlock=ceil(size(tM,1)/80);
    
    tcr=tM(:,2);
    cr=nan(80,nBlock);
    
    for i=1:nBlock
        
        if i<nBlock
            cr(:,i)=tcr((i-1)*80+1:i*80);
        elseif  i==nBlock
            cr(1:size(tM,1)-(i-1)*80,i)=tcr((i-1)*80+1:end);
        end
    end
    
    aveT(:,m)=nanmean(cr,2);
end

% % mean(aveT(:,75:100),2)
% % 
% % mIp=mean(aveT(:,101:151),2);
% % 
% % 
% %  [yp, ~] = smooth1d(mIp, (1:length(mIp))', 5, 1);
% %  
% %  plot(yp)
% %  