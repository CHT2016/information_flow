function [x,y] = Ww_decoding_pred_array(array,nbin,bins)
% last updated: Oct 22, 2020

x=[]; y=[];
nInd=3; nGap=6;
for i=bins
    mInd=array{1,i}(:,nInd);
    sx=[]; sy=[];
    for j =1:length(mInd)
        sy(j,1)=array{1,i}(j,mInd(j)+nGap);
        
        % add t0: ; k = 1:nbin+1; array{1,i-k+1}
        for k = 1:nbin+1 % without t0: 1:nbin & i-k
            sx(j,k)=array{1,i-k+1}(j,mInd(j)+nGap);
        end
        
% %         % without t0: ; k = 1:nbin; array{1,i-k}
% %         for k = 1:nbin+1
% %             sx(j,k)=array{1,i-k+1}(j,mInd(j)+nGap);
% %         end
    end
    x=[x;sx]; y=[y;sy];
end