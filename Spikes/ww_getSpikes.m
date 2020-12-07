function ww_getSpikes(trialInfo, cellResponse, Bin, tu, pp, indCells,fName,fName2)
% This function is used to.
% last updated: July 5, 2019. Hua

%%% TrialInfo
%%% 14  Timing fixation
%%% 15  Timing Stim On
%%% 16  Timing Stim acquired
%%% 17  Timing reward

indTrials=pp{1, 1}(:,1)';
nCell=size(tu{1,1}(:,1),1);

fix=trialInfo(:,14);
cue=trialInfo(:,15);
choice=trialInfo(:,16);
reward=trialInfo(:,17);

dir='D:\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Rasters\';
response=[0 1000]; % response time
 Xlim=[-500 1500];
intPeriod=(response(1)-Bin.period(1))/Bin.step+1:(response(2)-Bin.period(1))/Bin.step+1;

iitri=0;
for i = indTrials(1:160)
    temFix=fix(i)-cue(i);
    temRew=reward(i)-cue(i);
    temCho=choice(i)-cue(i);
    
%     iitri=iitri+1;
    iint=0; tdis=[];
    for j=intPeriod
        iint=iint+1;
        tdis(:,iint)=tu{iitri,j}(:,1)-tu{iitri,j}(:,2);
    end
    
    [B,iCells]=sort(mean(tdis,2)); % iCells: cell index in this array, sorted by vector of u.
    iC=indCells(iCells)'; % real iCells in all arrays.
    
    figure
%     set(gcf,'visible','off');
    hold on
    
    %% raster plot
%     subplot('Position',[0.1 0.1 0.7 0.6])
    iicell=0;
    for k = iC(61:end)
        iicell=iicell+1;
        TS = cellResponse{k, i}.stimSpikes; %%aligned to cue
        for o = 1:length(TS)
            line([TS(o),TS(o)],[iicell-.9,iicell-.1],'Color', 'k')
        end
    end
    
%     line([temFix,temFix],[0 ,nCell],'Color', 'b','linewidth',1)
%     line([temCho,temCho],[0 ,nCell],'Color', 'y','linewidth',1)
%     line([temRew,temRew],[0 ,nCell],'Color', 'r','linewidth',1)
    line([0, 0],[0 ,nCell],'Color', 'g','linewidth',1)
    
     xlim(Xlim);
    ylim([0 length(iC)])
    xlabel('Time from cue (s)')
    ylabel('Cells')
    %% perference to one choice
%     subplot('Position',[0.82 0.1 0.1 0.6])
    rB=fliplr(B');
    
    imagesc(rB')
    colorbar
    axis off
    
    %% posteior probability
    decoDir=pp{1,1}(iitri,4);
    for m=1:size(Bin.cen,2)
        pP(1,m)=pp{1,m}(iitri,7);
        pP(2,m)=pp{1,m}(iitri,8);
    end
    [yp1, ~] = smooth1d(pP(1,:)', (1:length(pP(1,:)))', 3, 1);
    [yp2, ~] = smooth1d(pP(2,:)', (1:length(pP(2,:)))', 3, 1);
    
%     subplot('Position',[0.1 0.75 0.7 0.2])
    hold on
    plot(Bin.cen,yp1,'r')
    plot(Bin.cen,yp2,'b')
    box off
    legend({'1','2'},'Location', 'northwest')
    ylim([0 1])
    xlim(Xlim)
    
    nfName=[fName,'_trial', num2str(i),'_',fName2, '_monkey-', num2str(pp{1,1}(iitri,3)), '_decoding-', num2str(pp{1,1}(iitri,4))];
    title(strrep(nfName,'_','\_'))
    set(gca,'xticklabel',[])
    ylabel('Posterior')
        xlabel('Posterior')
    set(gca,'FontSize',10)
    
    
    saveas(gcf, [dir , nfName], 'png');
end
end