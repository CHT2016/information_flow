function autoc = ww_Spikes_cc_mix(cellResponse, Bin,indCells1,indCells2)
% This function is used to caculate the correlation coefficient of each
% pair of neurons between each array.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 18, 2019.
% last updated: November 18, 2019.

cSpike1=[]; cSpike2=[];
for iTrial=1:size(cellResponse,2) % trials
    nn1=0;
    for iCell=indCells1'
        nn1=nn1+1;
        TS = cellResponse{iCell, iTrial}.stimSpikes; %%aligned to cue
        cSpike1(nn1,iTrial,:)=histcounts(TS,Bin.cen); % spike count
    end
    
    nn2=0;
    for iCell=indCells2'
        nn2=nn2+1;
        TS = cellResponse{iCell, iTrial}.stimSpikes; %%aligned to cue
        cSpike2(nn2,iTrial,:)=histcounts(TS,Bin.cen); % spike count
    end
end

for iTrial=1:size(cellResponse,2) % trial
    nn3=0;
    for i=1:length(indCells1)
        for j=1:length(indCells2)
            nn3=nn3+1;
            autoc(iTrial,nn3)=corr(squeeze(cSpike1(i,iTrial,:)),squeeze(cSpike2(j,iTrial,:)));
        end
    end
end