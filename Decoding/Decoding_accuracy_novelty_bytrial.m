function aveT=Decoding_accuracy_novelty_bytrial(Mat,fNovel)
% used to transfer decoding accuracy to aligned trial by trial
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 2019.
% last updated: November 5,2019.

aveT=nan(10,length(Mat));
for m=1:length(Mat)
    tM=Mat{1, m};   
    for n=1:10
        tCR=tM(fNovel+n-1,2);    
        aveT(n,m)=mean(tCR);
    end
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