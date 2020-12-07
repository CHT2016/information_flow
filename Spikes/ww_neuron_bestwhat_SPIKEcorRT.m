% what 1 / 2, base on best choice
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 18, 2019.
% last updated: Oct 22, 2020.


%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;
%% load files
cd (['C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Database'])
fnames={'v20160929','v20160930','v20161005','v20161017','w20160112','w20160113','w20160121','w20160122'};
bhvnames={'voltaire-09-29-2016','voltaire-09-30-2016','voltaire-10-05-2016','voltaire-10-17-2016'...
    'waldo-01-12-2016','waldo-01-13-2016','waldo-01-21-2016','waldo-01-22-2016'};
nc=5;
%%% phased locked to cue!!!
Bin.period = [-2000 2000]; % raw neural file only +- 1000 ms;
Bin.size = 20;
Bin.step = 20;
Bin.cen=Bin.period(1):Bin.step:Bin.period(2);
Bin.center='cue';

colors={'r','g','b','k'};


for kk=1:length(fnames)
    kk
    load([fnames{kk},'_neuron'],'cellResponse','Neurons','beh','Bin','spikeCount');
    
    BHV = bhv_read(['rlPlaceImg-',bhvnames{kk}]);
    RT=BHV.ReactionTime (BHV.TrialError==0);
    
    iWW{1}=[]; % what1
    iWW{2}=[]; % what2
    iWW{3}=find(beh.blockType==1 & beh.trialDirection==0); % where1
    iWW{4}=find(beh.blockType==1 & beh.trialDirection==1); % where2
    
    %% raster plot
    for k = 1: size(Neurons,1)
        tts=cellResponse(k,:);
        
        % sort what blocks by neuron activity
        bindx=beh.blockIndex;
        ubindx=unique(bindx);
        whatind_max=[];whatind_min=[];
        for ib=1:length(ubindx)
            whatindx0 = find(bindx==ubindx(ib) & beh.blockType==1 & beh.trialObject==0);
            whatindx1 = find(bindx==ubindx(ib) & beh.blockType==1 & beh.trialObject==1);
            
            allTS0=[];allTS1=[];
            for j=1:length(whatindx0)
                TS = tts{1, whatindx0(j)}.stimSpikes; %%aligned to cue
                allTS0 = [allTS0,TS];
            end
            for j=1:length(whatindx1)
                TS = tts{1, whatindx1(j)}.stimSpikes; %%aligned to cue
                allTS1 = [allTS1,TS];
            end
            
            if numel(find(allTS0>0 & allTS0<500))>= numel(find(allTS1>0 & allTS1<500)) 
                whatind_max=[whatind_max;whatindx0];
                whatind_min=[whatind_min;whatindx1];
            else
                whatind_max=[whatind_max;whatindx1];
                whatind_min=[whatind_min;whatindx0];
            end
        end
        iWW{1}=whatind_max; % what1
        iWW{2}=whatind_min; % what2
    end
    
    
    
    
% %     for k = 1: size(Neurons,1)
% %         for j=1:length(RT)
% %             TS = cellResponse{k, j}.choiceSpikes; %%aligned to choice
% %             parfor b = 1:size(Bin.cen,2)
% %                 SS(j,k,b) = sum(TS>=Bin.cen(b)-Bin.size/2 & TS<(Bin.cen(b)+Bin.size/2))/(Bin.size*1/1000);
% %             end
% %         end
% %     end
% %         
% %     spikeCount=SS;
% %     
    
    
    
  
    figure
    hold on
    %     for m=1:2
    %         temInd=[iWW{m};iWW{m+1}];
    %         mFR=squeeze(mean(spikeCount,2));
    %         parfor b = 1:size(Bin.cen,2)
    %             [rho(b),pval(b)]=corr(mFR(temInd,b),RT(temInd)');
    %         end
    %         plot(Bin.cen/1000,smooth(rho,5),'color',colors{m})
    %     end
    
    for m=1:2
        temInd=[iWW{m};iWW{m+1}];
        for b = 1:size(Bin.cen,2)
            for it=1:size(spikeCount,1) 
              tnorm(it)=norm(spikeCount(it,:,b));
            end
            [rho(b),pval(b)]=corr(tnorm(temInd)',RT(temInd)');
        end
        plot(Bin.cen/1000,smooth(rho,5),'color',colors{m})
    end
    
    ylim([-0.2 0.6])
    xlabel('Time from cue onset (s)')
    ylabel('correlation_r')
    title(fnames{kk})
    %     legend({'What/A','What/B','Where/Left','Where/Right'})
    legend({'What','Where'})
    
    clear cellResponse spikeCount
end
% save('PSTH_allneurons_100_20_bestwhat','psth','Neuron')