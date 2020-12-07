% Used to do analysis for decoding-prediction of what&where task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: July 25,2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017
% last updated: July 25,2019

close all; clear; clc;

% loading filelist
cd('C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Anova')

[sourcefilename, pathname] = uigetfile('*.mat', 'multiselect','on');
if isequal(sourcefilename,0)
    error 'No file was selected'
    return
end

list=[];
for n=1:length(sourcefilename)
    list{n,1}=sourcefilename{n}(1:end-4);
end
tit={'dir','obj'};

% tit: dir, obj, value, reward, dirxval

% loading data
for i=1:length(list)
    load(list{i}, 'cellSig','Neurons');
    [Arrayw, Arrayv] = indexIdentify_Array8(Neurons);
    
    if isempty(Arrayw{1})
        tarray=Arrayv;
    else
        tarray=Arrayw;
    end
    %
    %         what.sigdir=squeeze(cellSig.sigdirxval(1,:,:));
    %         what.sigobj=squeeze(cellSig.sigvalue(1,:,:));
    %         where.sigdir=squeeze(cellSig.sigdirxval(2,:,:));
    %         where.sigobj=squeeze(cellSig.sigvalue(2,:,:));
    
    what.sigdir=squeeze(cellSig.sigdir(1,:,:));
    what.sigobj=squeeze(cellSig.sigobject(1,:,:));
    where.sigdir=squeeze(cellSig.sigdir(2,:,:));
    where.sigobj=squeeze(cellSig.sigobject(2,:,:));
    
    [fpWhat, ~, ~, nIndWhat]= Ww_nAnova_fp(tarray,what,tit);
    [fpWhere, ~, ~, nIndWhere]= Ww_nAnova_fp(tarray,where,tit);
    
    [overlapMat,pnumM]=neuron_index_compare(nIndWhat,nIndWhere);
    
    
    for j=1:size(fpWhat,1)
        for k=1:size(fpWhat,2)
            dira.what{j,k}(i,:)=fpWhat{j,k}(1,:);
            obja.what{j,k}(i,:)=fpWhat{j,k}(2,:);
            dira.where{j,k}(i,:)=fpWhere{j,k}(1,:);
            obja.where{j,k}(i,:)=fpWhere{j,k}(2,:);
            
            % oNeuron: overlap neurons
            oNeuron.whatdirwhatobj{j,k}(i,:)=pnumM{j,k}(1,:);
            oNeuron.whatdirwheredir{j,k}(i,:)=pnumM{j,k}(2,:);
            oNeuron.whatdirwhereobj{j,k}(i,:)=pnumM{j,k}(3,:);
            oNeuron.whatobjwheredir{j,k}(i,:)=pnumM{j,k}(4,:);
            oNeuron.whatobjwhereobj{j,k}(i,:)=pnumM{j,k}(5,:);
            oNeuron.wheredirwhereobj{j,k}(i,:)=pnumM{j,k}(6,:);
        end
    end
end

%% plot
colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
legends={'L1','L2','L3','L4','R1','R2','R3','R4'}

para.binstep=0.01; % bin step of data
para.xlim=[-2 2]; %time zone
para.ylim=[0.0 .7];
para.saxis=[0.5 0.1]; %%step of axis
para.line=[0; nan]; %lines to indicate the task epochs
para.colors=colors;
para.xlabel='Time from cue (s)';
% para.ylabel='Proportion of neurons (p < 0.05)';
para.ylabel='Percent of neurons';
para.smooth='Gaussian';

mtitle={'dira.what','dira.where','obja.what','obja.where'};
% mtitle={'oNeuron.whatdirwhatobj','oNeuron.whatdirwheredir','oNeuron.whatobjwhereobj',...
%     'oNeuron.wheredirwhereobj','oNeuron.whatdirwhereobj','oNeuron.whatobjwheredir'}

ttt=0
onset=[]
for m=1:length(mtitle)
    eval(['tMat='  mtitle{m} ';'])
    ttitle=mtitle{m};
    % ttitle='overlap(where.dir-where.obj)';
    para.title=ttitle;
    
    for j=1:size(tMat,1)
        for k=1:size(tMat,2)
            temD=tMat{j,k};
            nanInd=find(isnan(temD));
            temD(nanInd)=0;
            Data{k}=temD;
             Dataa{m,j}{k}=temD;
        end
        
        % % %                 %% onset time, kick one off
        % % %                 para.legend=legends((j-1)*4+1:j*4);
        % % %                 para.baseline=[-1.5 -0.5];
        % % %                 para.precue=[-0.5 0];
        % % %                 for ii=1:8
        % % %                     ps = setdiff([1:8],ii);
        % % %                     for k=1:size(tMat,2)
        % % %                         nData{k} =  Data{k} (ps,:);
        % % %                     end
        % % %                     [taveIntp, taveBasep, tavePrecue, tonset] = ANOVA_ave_latency_plot(nData,para);
        % % %                     onset{j,m}(ii,:)=tonset;
        % % %                 end
        % % %
        % % %                 %%
        
        %% plot
        para.legend=legends((j-1)*4+1:j*4);
        para.baseline=[-1.5 -0.5];
        para.precue=[-0.5 0];
        
        [taveIntp, taveBasep, tavePrecue, onset] = ANOVA_ave_latency_plot(Data,para);
        
        aveIntp{j,m}=taveIntp;
        aveBasep{j,m}=taveBasep;
        avePrecue{j,m}=tavePrecue;
        ttt=ttt+1;
        
        aaveIntp(:,:,ttt)=taveIntp;
        aaveBasep(:,:,ttt)=taveBasep;
        aavePrecue(:,:,ttt)=tavePrecue;
        xlim([-.5 1.5])
    end
end

aveIntp{3,1}=aaveIntp; aveBasep{3,1}=aaveBasep;avePrecue{3,1}=aavePrecue;
