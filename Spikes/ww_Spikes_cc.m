function autoc = ww_Spikes_cc(cellResponse, Bin,indCells)
% This function is used to caculate the correlation coefficient of each
% pair of neurons within each array.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 18, 2019.
% last updated: November 18, 2019.

%%% TrialInfo
%%% 14  Timing fixation
%%% 15  Timing Stim On
%%% 16  Timing Stim acquired
%%% 17  Timing reward


% fix=trialInfo(:,14);
% cue=trialInfo(:,15);
% choice=trialInfo(:,16);
% reward=trialInfo(:,17);

cSpike=[];

for iTrial=1:size(cellResponse,2) % trials
    nn=0;
    for iCell=indCells'
        nn=nn+1;
        TS = cellResponse{iCell, iTrial}.stimSpikes; %%aligned to cue
        cSpike(nn,iTrial,:)=histcounts(TS,Bin.cen); % spike count
    end
end


ncho=nchoosek(1:length(indCells),2);
for iTrial=1:size(cellResponse,2) % trials
    for ipCell=1:size(ncho,1)
        autoc(iTrial,ipCell)=corr(squeeze(cSpike(ncho(ipCell,1),iTrial,:)),squeeze(cSpike(ncho(ipCell,2),iTrial,:)));
    end
end
end