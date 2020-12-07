
function [x,y] = Ww_decoding_pred_array_single(tArray,nbin,bins,trial_id)
% last updated: nov 22,2019

x=[]; y=[];
nInd=3; nGap=6;
for i=bins
    mInd=tArray{1,i}(:,nInd);
    sx=[]; sy=[];
    for j =trial_id%1:length(mInd) %% single trial model!!
        sy(1,1)=tArray{1,i}(j,mInd(j)+nGap);
        % add t0
        for k = 1:nbin+1 % without t0: 1:nbin & i-k
            sx(1,k)=tArray{1,i-k+1}(j,mInd(j)+nGap);
        end
    end
    x=[x;sx]; y=[y;sy];
end