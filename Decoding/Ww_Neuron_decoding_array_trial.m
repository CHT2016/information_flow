% This function is used to do decoding trial by trial (1 to 80) for noverty task
% Not separated by small group, ectract decoding results from whole-session decoding file.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in March 2019.
% last updated: September 4,2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;
Mk='w';
Date='20160122';

%% load files
cd ('C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding')
load([Mk,Date,'_deco']);

%% % detect block/switch spots
block_switch=[-1; diff(beh.reversal)];%-1:start of block; 1:switch
sblock=find(block_switch==-1);
sreversal=find(block_switch==1);

blockType=beh.blockType;
object=beh.trialObject;
direction=beh.trialDirection+1;

%% decoding: saccade direction
blockIndex=beh.blockIndex;
stimdir= repmat([1,2],[length(object) 1]); % in what & where task, only has two chioce options
reversal=beh.reversal;
mBlockType = 2-round(modelData(:,3));

dTri_dir=[]; dTri_obj=[]; dTri_blo=[];
for j=1:80
    %%% splite by reversal
    otrial=sblock+j-1;
    indDir.what = intersect(find(blockType==1),otrial);
    indDir.where= intersect(find(blockType==2),otrial);
    
    indObj.what = intersect(find(blockType==1),otrial);
    indObj.where= intersect(find(blockType==2),otrial);
    
    indBlo.what=intersect(find(mBlockType==1),otrial);
    indBlo.where=intersect(find(mBlockType==2),otrial);
    
    for m=1:size(deco_dir.what,1)
        for n=1:size(deco_dir.what,2)
            for k=1:length(Bin.cen)
                dwhat=deco_dir.what{m,n}{k};
                [~,loc]=ismember(indDir.what,dwhat(:,1));
                dTri_dir.what{m,n}(j,k)=mean(dwhat(loc,2));              
                dwhere=deco_dir.where{m,n}{k};
                [~,loc]=ismember(indDir.where,dwhere(:,1));
                dTri_dir.where{m,n}(j,k)=mean(dwhere(loc,2));
                
                owhat=deco_obj.what{m,n}{k};
                [~,loc]=ismember(indObj.what,owhat(:,1));
                dTri_obj.what{m,n}(j,k)=mean(owhat(loc,2));
                owhere=deco_obj.where{m,n}{k};
                [~,loc]=ismember(indObj.where,owhere(:,1));
                dTri_obj.where{m,n}(j,k)=mean(owhere(loc,2));
                
                bwhat=deco_blo.what{m,n}{k};
                [~,loc]=ismember(indBlo.what,bwhat(:,1));
                dTri_blo.what{m,n}(j,k)=mean(bwhat(loc,2));
                bwhere=deco_blo.where{m,n}{k};
                [~,loc]=ismember(indBlo.where,bwhere(:,1));
                dTri_blo.where{m,n}(j,k)=mean(bwhere(loc,2));
            end  
        end
    end
end

% %% heatmap
% ptMat=dTri_blo.where{1,3};
% tMat=[];
% for m=1:size(ptMat,1)
%     ttt=ptMat(m,:);
%     [tMat(m,:), ~] = smooth1d(ttt', (1:length(ttt))', floor(length(ttt)/10), 1);
% end
% for n=1:size(tMat,2)
%     ttt=ptMat(:,n);
%     [tMat(:,n), ~] =  smooth1d(ttt, (1:length(ttt))', floor(length(ttt)/10), 1);
% end
% 
% figure
% imagesc(Bin.cen,1:80,ptMat)
% colorbar
% caxis([0 1])
% hold on
% plot([0 0],[ 1 80],'k--')
% 
% xlabel('Time from cue (ms)','fontsize',12)
% ylabel('Trial number','fontsize',12)
% title(strrep('R3','_','\_'))

save([Mk,Date, '_deco_trial', ],'beh','Neurons','Bin','dTri_dir','dTri_obj','dTri_blo')