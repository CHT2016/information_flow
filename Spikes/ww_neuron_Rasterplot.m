% This function is used to plot 1) rasters aligned by neurons' distance to
% choice options; 2)posterioral probability.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 18, 2019.
% last updated: Jun 2, 2020.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;
%% load files
cd (['C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Database'])
fnames={'v20160929','v20160930','v20161005','v20161017','w20160112','w20160113','w20160121','w20160122'};

%%% phased locked to cue!!!
Bin.period = [-2000 2000]; % raw neural file only +- 1000 ms;
Bin.size = 20;
Bin.step = 20;
Bin.cen=Bin.period(1):Bin.step:Bin.period(2);
Bin.center='cue';

tt=0; psth=[];Neuron=[];
for kk=1:length(fnames)
    kk
    load([fnames{kk},'_neuron'],'cellResponse','Neurons','beh','Bin');
    Neuron=[Neuron; Neurons];
    
    iWW{1}=find(beh.blockType==1 & beh.trialObject==0); % what1
    iWW{2}=find(beh.blockType==1 & beh.trialObject==1); % what2
    iWW{3}=find(beh.blockType==1 & beh.trialDirection==0); % where1
    iWW{4}=find(beh.blockType==1 & beh.trialDirection==1); % where2
    
    %% raster plot
    for k = 1: size(Neurons,1)
        tt=tt+1;
        for m=1:4
            temInd=iWW{m};
            allTS=[];
            for j=1:length(temInd)
                TS = cellResponse{k, temInd(j)}.stimSpikes; %%aligned to cue
                allTS = [allTS,TS];
            end
            
            parfor b = 1:size(Bin.cen,2)
                ispkden(b,:) = sum(allTS>=Bin.cen(b)-Bin.size/2 & allTS<(Bin.cen(b)+Bin.size/2))/(Bin.size*length(temInd)/1000);
            end
            psth(m,:,tt)=ispkden;
        end
    end
end
% save('PSTH_allneurons_100_20','psth','Neuron')

%% significant neurons
cd 'C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Anova';
load('sigCells.mat')

ypValue(1,:,:)=sigdir;
ypValue(2,:,:)=sigobject;

% identify Index of array, hemispere and moneky for each neuron
[iArray] = indexIdentify_Array8_allmonkeys(Neuron);

% index for all significat bins for each neuron: indBin
[fp, fps, fpa,indBin] = NS_nAnova_fp(iArray,ypValue);

% define significant neurons: showing a significant effect in at least 5
% continual windows after cue or reward onset
[ivArray,nindex]=NS_nAnova_sign(indBin,Bin,iArray,5);
ivArray{1,2}='dir';
ivArray{2,2}='obj';

%% plot
para.bins=Bin.cen/1000;
para.colors={'r','g','b','m'};
para.xlabel='Time from cue onset (s)';
para.ylabel='Spikes/s';
para.legend={'What/A','What/B','Where/Left','Where/Right'};
para.xlim=[-1 1.5];
para.ylim=[4 10];
para.saxis=[0.5, 2];
para.smooth=5;
para.subplot='true';

figure
for i=1:2
    for j=1:4
        psth_what=psth(1:2,:,ivArray{2, 1}{i, j});
        psth_where=psth(3:4,:,ivArray{1, 1}{i, j});
        
        Data{1,1}=squeeze(psth_what(1,:,:))';
        Data{2,1}=squeeze(psth_what(2,:,:))';
        Data{3,1}=squeeze(psth_where(1,:,:))';
        Data{4,1}=squeeze(psth_where(2,:,:))';
        
        subplot(2,4,(i-1)*4+j)
        para.title=['Hemi ', num2str(i),' - Array ', num2str(j)];
        LINE_nPlot(Data,para)
    end
end

%% plot single neurons
%%% to detect good neurons
for i=1:2
    for j=1:4
        tindex=union(ivArray{1, 1}{i, j},ivArray{2, 1}{i, j});
        for m=1:length(tindex)
            figure
            set(gcf,'visible','off');
            [Yp, xvi]=smooth1d_matrix(psth(:,:,tindex(m))',(1:201)',5,1);
            plot(Bin.cen/1000,Yp,'linewidth',2)
            legend('where1', 'where2', 'what1', 'what2')
            saveas(gcf,[num2str(i),'_',num2str(j),'_',num2str(tindex(m)),'.png'])
        end
    end
end

%% plot spikes
for mm=37:length(nneuron)
    tnum=nneuron(mm);
    Neuron(tnum,:)
    cd (['C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Database'])
    load([Neuron{tnum,1},Neuron{tnum,3},'_neuron'],'trialInfo','cellResponse','beh','Neurons');
    
    indneuron=find([Neurons{:,5}]==Neuron{tnum,5} & [Neurons{:,6}]==Neuron{tnum,6});
    tts=cellResponse(indneuron,:);
    
    %     %% coder
    %     cd 'D:\NIH-Research\PFC_8ARRAY\WhatWhere\What&where DATA\W20160121data\W20160121NIP1\matFiles';
    %     load('rlPlaceImg-waldo-01-21-2016-BHVeventsNIP1.mat')
    %     Coder.BHVinfo=BHVinfo;
    %     Coder.BHVerror=BHVerror;%% error types
    %     Coder.validtrls = find(Coder.BHVerror==0); % completed trials
    %
    %     for h = 1:size(Coder.validtrls,1)
    %         Coder.fixlock(h,1) = NEURALtime{Coder.validtrls(h)}(NEURALevnt{Coder.validtrls(h)}==3);
    %         Coder.stimlock(h,1) = NEURALtime{Coder.validtrls(h)}(NEURALevnt{Coder.validtrls(h)}==4);
    %
    %         if sum(NEURALevnt{Coder.validtrls(h)}==7)>0
    %             Coder.juicelock(h,1) = min(NEURALtime{Coder.validtrls(h)}(NEURALevnt{Coder.validtrls(h)}==7));
    %         elseif sum(NEURALevnt{Coder.validtrls(h)}==8)>0
    %             Coder.juicelock(h,1) = min(NEURALtime{Coder.validtrls(h)}(NEURALevnt{Coder.validtrls(h)}==8));
    %         end
    %     end
    %
    %%
    beh.blockType(1921:end)=[];
    beh.trialObject(1921:end)=[];
    beh.trialDirection(1921:end)=[];
    
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
    
    iww{1}=[whatind_max;whatind_min];
    %     iww{1}=[find(beh.blockType==1 & beh.trialObject==0);find(beh.blockType==1 & beh.trialObject==1)];
    iww{2}=[find(beh.blockType==2 & beh.trialDirection==0);find(beh.blockType==2 & beh.trialDirection==1)];
    lines(1)=length(whatind_max);
    lines(2)=length(find(beh.blockType==2 & beh.trialDirection==0));
    
    dir='C:\Users\tangh4\OneDrive - National Institutes of Health\Manuscript\# rostral-caudal axis\Figures\subfigures\Fig. SX mean_activity\Spikes\';
    ttls={'What Blocks','Where Blocks'};
    for m=1:2
        figure
        %         set(gcf,'visible','off');
        hold on
        iicell=0;
        for k = 1:length(iww{m})
            iicell=iicell+1;
            TS = cellResponse{indneuron,iww{m}(k)}.stimSpikes; %%aligned to cue
            for o = 1:length(TS)
                line([TS(o),TS(o)],[iicell-.9,iicell-.1],'Color', 'b','linewidth',1.5)
            end
        end
        
        iicell=0;
        for k = 1:length(iww{m})
            iicell=iicell+1;
            t_fix=(Coder.fixlock(iww{m}(k))-Coder.stimlock(iww{m}(k)))*1000;
            t_reward=(Coder.juicelock(iww{m}(k))-Coder.stimlock(iww{m}(k)))*1000;
            line([t_fix,t_fix],[iicell-.9,iicell-.1],'Color', 'r','linewidth',1.5)
            line([t_reward,t_reward],[iicell-.9,iicell-.1],'Color', 'r','linewidth',1.5)
        end
        
        line([0 0], [0 960],'Color','red')
        line([-500 1500], [lines(m) lines(m)],'Color','k')
        xlim([-500, 1000])
        ylim([1 960])
        xlabel('Time from cue (ms)')
        ylabel('Trial')
                title(ttls{m})
        %         saveas(gcf, [dir, num2str(tnum), ttls{m}], 'fig');
        %         saveas(gcf, [dir, num2str(tnum), ttls{m}], 'png');
        
        %% psth
        tpsthindx{1}=whatind_max;
        tpsthindx{2}=whatind_min;
        tpsthindx{3}=find(beh.blockType==2 & beh.trialDirection==0);
        tpsthindx{4}=find(beh.blockType==2 & beh.trialDirection==1);
        
        for itpsth=1:4
            temInd=tpsthindx{itpsth};
            allTS=[];
            for j=1:length(temInd)
                TS = tts{1, temInd(j)}.stimSpikes; %%aligned to cue
                allTS = [allTS,TS];
            end
            
            ispkden=[];
            parfor b = 1:size(Bin.cen,2)
                ispkden(b,:) = sum(allTS>=Bin.cen(b)-Bin.size/2 & allTS<(Bin.cen(b)+Bin.size/2))/(Bin.size*length(temInd)/1000);
            end
            tpsth(itpsth,:)=ispkden;
        end
        
        figure
%         set(gcf,'visible','off');
        [Yp, xvi]=smooth1d_matrix((tpsth)',(1:201)',3,1);
        plot(Bin.cen/1000,Yp,'linewidth',2)
        legend( 'what1', 'what2','where1', 'where2')
        xlim([-0.5 1])
        ylim([0 40])
    end
    clear cellResponse
end
