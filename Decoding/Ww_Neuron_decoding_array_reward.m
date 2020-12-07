% This function is used to do decoding for noverty task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in March 2019.
% last updated: August 24,2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;

Mk='v';
Date='20160929';

%% load files
cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\' Mk,Date,'\'])
load([Mk,Date]);
load(['sigCells_' Mk,Date, '_1.mat'], 'Neurons')

%%
%%% phased locked to cue!!!
Bin.period = [-2000 2000]; % raw neural file only +- 1000 ms;
Bin.size = 20;
Bin.step = 20;
Bin.cen=Bin.period(1):Bin.step:Bin.period(2);
Bin.center='reward';

% % % calculate psth
if size(trialInfo,1)>1920
[beh, spikeCount, spikeSDF] = binSpikes(trialInfo(1:1920,:), cellResponse(:,1:1920), modelData(1:1920,:), reversePoint(1:24), Bin);
else
[beh, spikeCount, spikeSDF] = binSpikes(trialInfo, cellResponse, modelData, reversePoint, Bin);
end
cSpike=permute(spikeCount,[2,1,3]); % it's spike count, not psth

%% Array map
[Arrayw, Arrayv] = indexIdentify_Array8(Neurons);

%% decoding: reward
object=beh.trialObject;
direction=beh.trialDirection+1;
blockIndex=beh.blockIndex;
blockType=beh.blockType;
reward=beh.reward;
stimdir= repmat([1,2],[length(object) 1]); % in what & where task, only has two chioce options
reversal=beh.reversal;

% detect block/switch spots
block_switch=[-1; diff(beh.reversal)];%-1:start of block; 1:switch
sblock=find(block_switch==-1);
sswitch=find(block_switch==1);


indRew.what_r1= find( blockType==1 & reward==1);
indRew.what_r0= find( blockType==1 & reward==0);
indRew.where_r1= find( blockType==2 & reward==1);
indRew.where_r0= find( blockType==2 & reward==0);

group_rew={'what_r1','what_r0';'where_r1','where_r0'};

arrarL={'L1','L2','L3','L4';'R1','R2','R3','R4'};
isReversal={'bReversal','aReversal'};
tBlock={'what','where'};

tArray= eval(['Array' Mk]);
for i=1:size(group_rew,1)
    for j = 1:size(group_rew,2)
        nIndex=['indRew.' group_rew{i,j}];
        tIndexDir{j} =eval([nIndex]);
    end
    
    for h=1:size(tArray,1) % hemisphere: l/r
        % plot by array
        figure
        fname=[Mk,Date,'_decoding_reward_array-',arrarL{h,1}(1),'_', group_rew{i,1}(1:end-3)]; % '_numN-',num2str(length(tArray{h,l}))
        colors={'r','g','b',[0.6 .6 0]};
        hold on
        
        for l=1:size(tArray,2)  %location: 1:4
            cSpike2= cSpike(tArray{h,l},:,:);
            [decoa,deco_mat]=ww_decoding_block(cSpike2,tIndexDir,Bin.cen,stimdir);% stimdir used for 1/0 reward
            
            adeco_rew{h,l}=decoa;
            tdeco_rew{h,l}=deco_mat;
            % [yp, xvi] = smooth1d(deco, bin_edges', .05, .05);
            plot(Bin.cen,decoa,'LineWidth',2,'color',colors{l}) %%deco
            
        end
        legend(arrarL(h,:),'AutoUpdate','off');
        xlabel('Time from reward (s)','fontsize',12)
        ylabel('Decording accuracy','fontsize',12)
        title(strrep(fname,'_','\_'))
        ylim([0.3,1])
%         xlim([-500,1500])
    end
    aa=['deco_rewa.',group_rew{i,1}(1:end-3)] ;
    eval([aa '= adeco_rew;'])
    
    bb= ['deco_rew.',group_rew{i,1}(1:end-3)] ;
    eval([bb '= tdeco_rew;'])
end


save([Mk,Date, '_deco_reward', ],'beh','spikeCount','tArray','Bin','indRew',...
    'deco_rewa','deco_rew')