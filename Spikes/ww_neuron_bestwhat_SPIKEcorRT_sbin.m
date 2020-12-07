% what 1 / 2, base on best choice
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 18, 2019.
% last updated: Oct 26, 2020.


%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;
%% load files
cd (['C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Database'])
fnames={'v20160929','v20160930','v20161005','v20161017','w20160112','w20160113','w20160121','w20160122'};
bhvnames={'voltaire-09-29-2016','voltaire-09-30-2016','voltaire-10-05-2016','voltaire-10-17-2016'...
    'waldo-01-12-2016','waldo-01-13-2016','waldo-01-21-2016','waldo-01-22-2016'};
%%% phased locked to cue!!!
Bin.period = [-2000 2000]; % raw neural file only +- 1000 ms;
Bin.size = 20;
Bin.step = 20;
Bin.cen=Bin.period(1):Bin.step:Bin.period(2);
Bin.center='cue';
colors={'r','g','b','k'};


for i=1:2
    for j=1:4
        SRTcor{1}{i,j}=[];  SRTcor{2}{i,j}=[];
    end
end


for kk=1:length(fnames)
    kk
    load([fnames{kk},'_neuron'],'cellResponse','Neurons','beh','Bin','spikeCount');
    BHV = bhv_read(['rlPlaceImg-',bhvnames{kk}]);
    RT=BHV.ReactionTime (BHV.TrialError==0);
    
    iWW{1}=find(beh.blockType==2); % what
    iWW{2}=find(beh.blockType==1); % where
    [iArray] = indexIdentify_Array8_allmonkeys(Neurons);
    
    figure
    hold on
    edges=-.2:0.02:0.2;
    for m=1:2
        temInd=[iWW{m}];
        mFR=squeeze(mean(spikeCount(:,:,86:101),3));
        for n=1:size(mFR,2)
            [rho(n),pval(n)]=corr(mFR(temInd,n),RT(temInd)');
        end
        
        % save cor
        for i=1:size(iArray,1)
            for j=1:size(iArray,2)
                SRTcor{m}{i,j}=[SRTcor{m}{i,j}; rho(iArray{i,j})'];
            end
        end
        histogram(rho,edges,'Normalization','probability')
    end
    
    xlabel('correlation_r')
    ylabel('probability')
    title(fnames{kk})
    legend({'What','Where'})
    
    clear cellResponse spikeCount
end
% save('SpikeRTcor_Fixlast300ms','SRTcor')


edges=-.2:0.02:0.2;
tt=0; pp=[];
figure
for j=1:4
    tt=tt+1;
    subplot(2,2,tt)
    
    hold on
    for m=1:2
        h2=histogram([SRTcor{m}{1,j};SRTcor{m}{2,j}],edges,'Normalization','probability')
        
        Mea(j,m)=nanmean([SRTcor{m}{1,j};SRTcor{m}{2,j}]);
        SD(j,m)=nanstd([SRTcor{m}{1,j};SRTcor{m}{2,j}]);
        pp(1:length(h2.Values),m)=h2.Values';
    end

    % chi-square test
    [p(j,1), Q(j,1)]= chi2test(pp);
    
    
    ylim([0 0.2])
    xlabel('correlation\_r')
    ylabel('probability')
    title(['Array ', num2str(j)])
    legend({'What','Where'})
end




