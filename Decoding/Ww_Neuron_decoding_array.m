% This function is used to do decoding for noverty task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in March 2019.
% last updated: July 24,2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;

Mk='w';
Date='20160121';

%% load files
cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\' Mk,Date,'\'])
load([Mk,Date]);
load(['sigCells_' Mk,Date, '_1.mat'], 'Neurons')

% % % %%
% % % %%% phased locked to cue!!!
% % % Bin.period = [-2000 2000]; % raw neural file only +- 1000 ms;
% % % Bin.size = 20;
% % % Bin.step = 20;
% % % Bin.cen=Bin.period(1):Bin.step:Bin.period(2);
% % % Bin.center='cue';

cd ('D:\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding')
load([Mk,Date, '_deco.mat'], 'Bin','spikeCount','beh')

% % % % % calculate psth
% % if size(trialInfo,1)>1920
% % [beh, spikeCount, spikeSDF] = binSpikes(trialInfo(1:1920,:), cellResponse(:,1:1920), modelData(1:1920,:), reversePoint(1:24), Bin);
% % else
% % [beh, spikeCount, spikeSDF] = binSpikes(trialInfo, cellResponse, modelData, reversePoint, Bin);
% % end
cSpike=permute(spikeCount,[2,1,3]); % it's spike count, not psth

%% Array map
[Arrayw, Arrayv] = indexIdentify_Array8(Neurons);

object=beh.trialObject;
direction=beh.trialDirection+1;
blockIndex=beh.blockIndex;
blockType=beh.blockType;
stimdir= repmat([1,2],[length(object) 1]); % in what & where task, only has two chioce options
reversal=beh.reversal;

% detect block/switch spots
block_switch=[-1; diff(beh.reversal)];%-1:start of block; 1:switch
sblock=find(block_switch==-1);
gBlock=[sblock; length(blockIndex)+1]; % gap of blocks

sreversal=find(block_switch==1);
arrarL={'L1','L2','L3','L4';'R1','R2','R3','R4'};
tArray= eval(['Array' Mk]);

%% decoding: saccade direction
%%% splite by reversal
indDir.what_d1= find( blockType==1 & direction==1);
indDir.what_d2= find( blockType==1 & direction==2);
indDir.where_d1= find( blockType==2 & direction==1);
indDir.where_d2= find( blockType==2 & direction==2);

group_dir={'what_d1','what_d2';'where_d1','where_d2'};
for i=1:size(group_dir,1)
    for j = 1:size(group_dir,2)
        nIndex=['indDir.' group_dir{i,j}];
        tIndexDir{j} =eval([nIndex]);
    end
    
    for h=1:size(tArray,1) % hemisphere: l/r
        % plot by array
        figure
        fname=[Mk,Date,'_decoding_dir_array-',arrarL{h,1}(1),'_', group_dir{i,1}(1:end-3)]; % '_numN-',num2str(length(tArray{h,l}))
        colors={'r','g','b',[0.6 .6 0]};
        hold on
        
        for l=1:size(tArray,2)  %location: 1:4
            cSpike2= cSpike(tArray{h,l},:,:);
            [decoa,deco_mat,uNeuron]=ww_decoding_dir(cSpike2,tIndexDir,Bin.cen,stimdir);
            % [decoa,deco_mat]=ww_decoding_dir_byblock(cSpike2,tIndexDir,Bin.cen,direction,gBlock);
            
            adeco_dir{h,l}=decoa;
            tdeco_dir{h,l}=deco_mat;
            tuNeuron_dir{h,l}=uNeuron;
            % [yp, xvi] = smooth1d(deco, bin_edges', .05, .05);
            plot(Bin.cen,decoa,'LineWidth',2,'color',colors{l}) %%deco
        end
        legend(arrarL(h,:),'AutoUpdate','off');
        xlabel('Time from cue (s)','fontsize',12)
        ylabel('Decording accuracy','fontsize',12)
        title(strrep(fname,'_','\_'))
        ylim([0.3,1])
    end
    aa=['deco_dira.',group_dir{i,1}(1:end-3)] ;
    eval([aa '= adeco_dir;'])
    
    bb= ['deco_dir.',group_dir{i,1}(1:end-3)] ;
    eval([bb '= tdeco_dir;'])
    
    cc= ['uNeuron_dir.',group_dir{i,1}(1:end-3)] ;
    eval([cc '= tuNeuron_dir;'])
end

% % % %% decoding: object
% % % indObj.what= find( blockType==1);
% % % indObj.where= find( blockType==2);
% % %
% % % group_obj={'what';'where'};
% % %
% % % for i=1:size(group_obj,1)
% % %     nIndex=['indObj.' group_obj{i}];
% % %     tIndexDir=eval([nIndex]);
% % %     for h=1:size(tArray,1) % hemisphere: l/r
% % %         % plot by array
% % %         figure
% % %         fname=[Mk,Date,'_decoding_obj_array-',arrarL{h,1}(1),'_', group_obj{i,1}]; % '_numN-',num2str(length(tArray{h,l}))
% % %         colors={'r','g','b',[0.6 .6 0]};
% % %         hold on
% % %         for l=1:size(tArray,2)  %location: 1:4
% % %             cSpike2= cSpike(tArray{h,l},:,:);
% % %             [decoa,deco_mat]=ww_decoding_obj(cSpike2,tIndexDir,Bin.cen,object,gBlock);
% % %
% % %             adeco_obj{h,l}=decoa;
% % %             tdeco_obj{h,l}=deco_mat;
% % %             plot(Bin.cen,decoa,'LineWidth',2,'color',colors{l}) %%deco
% % %         end
% % %         legend(arrarL(h,:),'AutoUpdate','off');
% % %         xlabel('Time from cue (s)','fontsize',12)
% % %         ylabel('Decording accuracy','fontsize',12)
% % %         title(strrep(fname,'_','\_'))
% % %         ylim([0.3,1])
% % %     end
% % %     aa=['deco_obja.',group_obj{i,1}] ;
% % %     eval([aa '= adeco_obj;'])
% % %
% % %     bb= ['deco_obj.',group_obj{i,1}] ;
% % %     eval([bb '= tdeco_obj;'])
% % % end
% % %
% % % %% decoding: block type
% % % % find the optimal choice
% % % mBlockType = 2-round(modelData(:,3));
% % % % mBlockType = 2-round(modelData(1:1920,3));
% % % % tblocktype=blockType; %blockType;mBlockType
% % % oCho=nan(length(object),2); % real optimal choice
% % % sswitch=[sort([sblock; sreversal]); length(object)+1];
% % % for i=1:length(sswitch)-1
% % %     if blockType(sswitch(i))==1
% % %         tt=[object(sswitch(i):sswitch(i+1)-1);3];
% % %         count = hist(tt,unique(tt));
% % %         [M,im]=max(count);
% % %         oCho(sswitch(i):sswitch(i+1)-1,1)=im-1;
% % %     elseif blockType(sswitch(i))==2
% % %         tt=[direction(sswitch(i):sswitch(i+1)-1);3];
% % %         count = hist(tt,unique(tt));
% % %         [M,im]=max(count);
% % %         oCho(sswitch(i):sswitch(i+1)-1,2)=im;
% % %     end
% % % end
% % %
% % % %%% splite by block
% % % % indBlo1.where_c1=find( direction==oCho(:,2));
% % % % indBlo1.where_c0=find( blockType==2 & direction~=oCho(:,2));
% % % % indBlo1.what_c1=find( object==oCho(:,1));
% % % % indBlo1.what_c0=find( blockType==1 & object~=oCho(:,1));
% % %
% % % %%% based on which imformation (object/direction) the monkey used.
% % % indBlo.where_c1=find(mBlockType==2 & direction==oCho(:,2));
% % % indBlo.where_c0=find(mBlockType==2 & direction~=oCho(:,2));
% % % indBlo.what_c1=find(mBlockType==1 & object==oCho(:,1));
% % % indBlo.what_c0=find(mBlockType==1 & object~=oCho(:,1));
% % %
% % % group_blo={'what_c1','what_c0';'where_c1','where_c0'};
% % % for i=1:size(group_blo,1)
% % %     for j = 1:size(group_blo,2)
% % %         nIndex=['indBlo.' group_blo{i,j}];
% % %         tIndexDir{j} =eval([nIndex]);
% % %     end
% % %
% % %     for h=1:size(tArray,1) % hemisphere: l/r
% % %         % plot by array
% % %         figure
% % %         fname=[Mk,Date,'_decoding_block_array-',arrarL{h,1}(1),'_', group_blo{i,1}(1:end-3)]; % '_numN-',num2str(length(tArray{h,l}))
% % %         colors={'r','g','b',[0.6 .6 0]};
% % %         hold on
% % %         for l=1:size(tArray,2)  %location: 1:4
% % %             cSpike2= cSpike(tArray{h,l},:,:);
% % %             [decoa,deco_mat]=ww_decoding_block(cSpike2,tIndexDir,Bin.cen,stimdir);
% % %
% % %             adeco_blo{h,l}=decoa;
% % %             tdeco_blo{h,l}=deco_mat;
% % %             % [yp, xvi] = smooth1d(deco, bin_edges', .05, .05);
% % %             plot(Bin.cen,decoa,'LineWidth',2,'color',colors{l}) %%deco
% % %
% % %         end
% % %         legend(arrarL(h,:),'AutoUpdate','off');
% % %         xlabel('Time from cue (s)','fontsize',12)
% % %         ylabel('Decording accuracy','fontsize',12)
% % %         title(strrep(fname,'_','\_'))
% % %         ylim([0.3,1])
% % %     end
% % %     aa=['deco_bloa.',group_blo{i,1}(1:end-3)] ;
% % %     eval([aa '= adeco_blo;'])
% % %
% % %     bb= ['deco_blo.',group_blo{i,1}(1:end-3)] ;
% % %     eval([bb '= tdeco_blo;'])
% % % end
% % %
% % % save([Mk,Date, '_deco_all', ],'beh','Neurons','spikeCount','spikeSDF','tArray','Bin','indObj',...
% % %     'indDir','indBlo','deco_obja','deco_obj','deco_bloa','deco_blo','deco_dira','deco_dir')

save([Mk,Date, '_deco_uNeuron', ],'beh','Neurons','tArray','Bin','indDir','deco_dira','deco_dir','uNeuron_dir')