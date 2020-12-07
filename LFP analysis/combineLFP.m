% combining the lfp data form all UAs with event markers.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH.
% last update: June 19, 2020

% created for Vinny, need to be deleted later



clear; close all; clc;
fname='v20161005'

% load behavior data
cd 'C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Database';
load([fname,'_neuron.mat'], 'beh')
iwhat=find(beh.blockType==1);
iwhere=find(beh.blockType==2);

% load nip 1 data
cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\What&where DATA\', fname, 'data\', fname, 'NIP1\matFiles']);
LFP=[];
for i=1:4
    load([fname, '_nip1_LFP_trial_UA' num2str(i), '_no60.mat'])
    LFP=[LFP, LFP_trial];
    clear LFP_trial
end

% load nip 2 data
cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\What&where DATA\', fname, 'data\', fname, 'NIP2\matFiles']);
LFP2=[];
for i=1:4
    load([fname, '_nip2_LFP_trial_UA' num2str(i), '_no60.mat'])
    LFP2=[LFP2, LFP_trial];
    clear LFP_trial
end

LFP=[LFP,LFP2]; % LFP data!!!
clear LFP2

tt=0
for j=1:size(LFP,2)
    chn=j;
    if j<385
        nip=1;
    elseif j>384
        nip=2;
        chn=chn-384;
    end
    tt=tt+1;
    [Neurons{tt,2},C{tt,1}] = GetArrayID(chn,nip);
    Neurons{tt,1}=fname(1); %'v'
end

[lArrayw, lArrayv] = indexIdentify_Array8_lfp(Neurons)
tarray=eval(['lArray', fname(1)]); % electrode indexes in each array.
