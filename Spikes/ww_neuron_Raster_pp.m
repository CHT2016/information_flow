% This function is used to plot 1) rasters aligned by neurons' distance to
% choice options; 2)posterioral probability.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 18, 2019.
% last updated: November 18, 2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

clear;close all;clc;

Mk='w';
Date='20160121';

%% load files
cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\' Mk,Date,'\'])
load([Mk,Date],'trialInfo','cellResponse');


cd('D:\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding')
load([Mk,Date,'_deco_uNeuron'],'deco_dir','uNeuron_dir', 'Neurons','Bin')

% %%
%%% phased locked to cue!!!
Bin.period = [-2000 2000]; % raw neural file only +- 1000 ms;
Bin.size = 20;
Bin.step = 20;
Bin.cen=Bin.period(1):Bin.step:Bin.period(2);
Bin.center='cue';

[Arrayw, Arrayv] = indexIdentify_Array8(Neurons);

tArray= eval(['Array' Mk]);
arrarL={'L1','L2','L3','L4';'R1','R2','R3','R4'};

for i=1:size(tArray,1)
    for j=4:-1:1%size(tArray,2)
        fName2=arrarL{i,j};
        indCells=tArray{i,j};
        
        fName=[Mk,Date,'_raster_where']; % '_numN-',num2str(length(tArray{h,l}))
        tu=uNeuron_dir.where{i,j};
        pp=deco_dir.where{i,j};
        ww_getSpikes(trialInfo, cellResponse, Bin, tu, pp,indCells,fName,fName2);
        
        fName=[Mk,Date,'_raster_what']; % '_numN-',num2str(length(tArray{h,l}))
        tu=uNeuron_dir.what{i,j};
        pp=deco_dir.what{i,j};
        ww_getSpikes(trialInfo, cellResponse, Bin, tu, pp,indCells,fName,fName2);
    end
end

clear uNeuron_dir

