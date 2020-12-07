% This function is used to caculate the correlation coefficient of each
% pair of neurons between each array.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 18, 2019.
% last updated: November 18, 2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;

Mk='v';
Date='20160929';

%% load files
cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\' Mk,Date,'\'])
load([Mk,Date],'trialInfo','cellResponse');

% 
cd('D:\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding')
load([Mk,Date,'_deco'],'Neurons','Bin')

% % % %%
% % %%% phased locked to cue!!!
Bin.period = [-500 1500]; % raw neural file only +- 1000 ms;
Bin.size = 20;
Bin.step = 20;
Bin.cen=Bin.period(1):Bin.step:Bin.period(2);
Bin.center='cue';

[Arrayw, Arrayv] = indexIdentify_Array8(Neurons);

tArray= eval(['Array' Mk]);
arrarL={'L1','L2','L3','L4';'R1','R2','R3','R4'};

ncho=nchoosek([1,2,3,4],2);

for i=1:size(tArray,1)
    for j=1:size(ncho,1) 
        indCells1=tArray{i, ncho(j,1)};
        indCells2=tArray{i, ncho(j,2)};
        mixc{i,j}=ww_Spikes_cc_mix(cellResponse, Bin,indCells1,indCells2);   
    end
end

save('mixc_v20160929.mat','mixc')
% 
% 
% [~,centers]=hist(nanmean(mixc{1, 3}),100);
colors={'r','g','b','c','m','y'};


% 
%%
figure
hold on
nn=0;
for i=1:size(mixc,1)
    for j=1:size(mixc,2)
        nn=nn+1;
        meanb{i,j}=nanmean(mixc{i, j})';
    end
end

barplot_cgroup(meanb)
legend('1-2','1-3','1-4','2-3','2-4','3-4')
