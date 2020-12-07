function [aveIntp, aveBasep, avePrecue, onset]=Decoding_ave_latency_plot(Data,para)
%__________________________________________________________________________
% ANOVA_ave_latency_plot.m - comparing significant neurons index between
% tasks and obj/dir encoding.
% Last update: September 27, 2019
% Hua Tang,Postdoc of Dr. Averbeck Lab @NIMH.
% original: SEM_nPlot.m
%__________________________________________________________________________
% INPUT
% whatInd:      2 x 4 (group) Cellarry with elements arrange as neurons x bins matrix.
% whereInd:     2 x 4 (group) Cellarry with elements arrange as neurons x bins matrix.
%
% OUTPUT
% numM:   number of overlap neurons.
% pnumM:  propertion of overlap neurons.2 x 4 (group) Cellarry with elements
%         arrange as neurons x bins matrix. formula: 2*overlap/(group1 + group2)
%__________________________________________________________________________

% clear all;close all; clc;Data=[];
if nargin < 2
    para.binstep=0.05; % bin step of data
    para.xlim=[0 4]; %time zone
    para.ylim=[1 2];
    para.saxis=[0.5 0.2]; %%step of axis
    para.line=[1 2.5 3.5; 1.5 3 nan]; %lines to indicate the task epochs
    para.colors={'b','r','m','g','k'}
    para.xlabel='Trials Since Novel Option';
    para.ylabel='Fraction Chosen';
    para.legend={'Novel','Best','worst'};
    para.smooth='Gaussian';
end

bins=para.xlim(1):para.binstep:para.xlim(2);
basebin=para.baseline(1):para.binstep:para.baseline(2);

intbin=[101:176] % 101:176 for decoding; 201:351 for anova

xlimend=para.xlim(2);

sbinb=(para.baseline(1)-para.xlim(1))/para.binstep+1;
ebinb=(para.baseline(2)-para.xlim(1))/para.binstep+1;

spinb=(para.precue(1)-para.xlim(1))/para.binstep+1;
epinb=(para.precue(2)-para.xlim(1))/para.binstep+1;


if  ~isfield(para,'subplot') % determine whether need to plot sub figures.
    figure
    set(gcf,'visible','off');
end

for m=1:length(Data)
    tData=Data{m};
    ave_fResult=nanmean(tData,1);
    SEM_fResult=nanstd(tData,1)./sqrt(sum(~isnan(tData),1));
    
    aveIntp(:,m)=nanmean(tData(:,intbin),2); % average value of [0 1.5], aligned to cue on.
    %%% Gaussian smooth
    if isfield(para,'smooth') & para.smooth=='Gaussian'
        [gs_ave_fResult, ~] = smooth1d(ave_fResult', (1:length(ave_fResult))', 5, 1);
        [gs_SEM_fResult, ~] = smooth1d(SEM_fResult', (1:length(SEM_fResult))', 5, 1);
        ave_fResult= gs_ave_fResult';
        SEM_fResult=gs_SEM_fResult';
    end
    
    hold on
    % plot SEM
    y3=ave_fResult+SEM_fResult;
    y4=ave_fResult-SEM_fResult;
    fill([bins, fliplr(bins)],[y3 fliplr(y4)],para.colors{m},'edgecolor',para.colors{m},'FaceAlpha',0.5,'linestyle','none')
    %plot average
    H(m)=plot(bins,ave_fResult,'color',para.colors{m},'linewidth',2);%para.LineStyle{m}
    
    %% latency
    abaseline=mean(tData(:,sbinb:ebinb),2);
    aveBasep(:,m)=abaseline;
    avePrecue(:,m)=mean(tData(:,spinb:epinb),2);
    
    nc=3;%% continual number of bins
    for k=1:length(bins)
        [~,P(k),~,~]=ttest2(abaseline,tData(:,k));
    end
    
    sigP=P < 0.01;
    [ind,ind1, ~]=continual_n(sigP',nc);
    
    % % %     for k=1:length(bins)
    % % %         if ind(k) == 1
    % % %             plot(bins(k),para.ylim(2)-m*0.01,'*','color',para.colors{m},'MarkerSize',6)
    % % %         end
    % % %     end
    % % %
    try
        tonset=bins(ind1);
        col = find(tonset> -500 & tonset< 1500);
        onset(m,1) = tonset(col(1));
    catch
        onset(m,1) = nan;
    end
    
    %     text(0+m*200, para.ylim(2)-0.1-m*0.01,num2str(bins(ind1)'),'color',para.colors{m})
end

%get additional input parameters (para)
if exist('para')
    if isfield(para,'xlim'); xlim(para.xlim); end
    if isfield(para,'ylim'); ylim(para.ylim); end
    if isfield(para,'ylabel'); ylabel(para.ylabel,'fontsize',12,'fontweight','b'); end
    if isfield(para,'xlabel'); xlabel(para.xlabel,'fontsize',12,'fontweight','b'); end
    if isfield(para,'group'); set(gca, 'XTickLabel',para.group, 'FontSize', 12); end
    if isfield(para,'legend'); legend(para.legend,'AutoUpdate','off'); end
    if isfield(para,'title'); title(strrep(para.title,'_','\_')); end
    if isfield(para,'saxis'); set(gca, 'XTick', [para.xlim(1):para.saxis(1):para.xlim(2)]);
        set(gca, 'YTick', [para.ylim(1):para.saxis(2):para.ylim(2)]); end
end

%% plot lines: solide & dash
if isfield(para,'line') % determine whether need to plot lines first.
    for n = 1:size(para.line,2)
        if ~isnan(para.line(1,n))
            line([para.line(1,n) para.line(1,n)],para.ylim,'Color','k')
        end
        if ~isnan(para.line(2,n))
            line([para.line(2,n) para.line(2,n)],para.ylim,'Color','k','LineStyle','--')
        end
    end
end

%% STATISTIC
if length(Data)>2
    for m=1:length(bins)
        Set=[];Gnum=[];
        for n=1:length(Data)
            temSet=Data{n};
            Set=[Set; temSet(:,m)];
            tGnum=ones(length(temSet(:,m)),1)*n;
            Gnum=[Gnum;tGnum];
        end
        [sP(m),~,~]=anova1(Set,Gnum,'off');
    end
elseif length(Data)==2
    Data1=Data{1};
    Data2=Data{2};
    for m=1:length(bins)
        [~,sP(m),~,~]=ttest2(Data1(:,m),Data2(:,m));
    end
elseif length(Data)==1
end

%% plot continual * # 5

sigP=sP < 0.01;
[ind,~, ~]=continual_n(sigP',nc);

if ~isnan(ind)
    for k=1:length(bins)
        if ind(k) == 1
            plot(bins(k),para.ylim(2),'*k','MarkerSize',6)
        end
    end
end

legend([H],para.legend,'Location','best')
end