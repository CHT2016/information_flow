% Used to do analysis for decoding-prediction of what&where task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% with hemispheres combined. Nov 4,2019.
% last updated: Oct 22,2020.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017


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
tit={'block'};

% tit: dir, obj, value, reward, dirxval

% loading data
for i=1:length(list)
    load(list{i}, 'omniSig','Neurons');
    [Arrayw, Arrayv] = indexIdentify_Array8(Neurons);
    
    if isempty(Arrayw{1})
        tarray=Arrayv;
    else
        tarray=Arrayw;
    end

   all.sigblock=omniSig.sigblock;

    
    [fpAll, ~, ~, nIndAll]= Ww_nAnova_fp(tarray,all,tit);
  
    
%     [overlapMat,pnumM]=neuron_index_compare(nIndAll,nIndWhere);
    
    
    for j=1:size(fpAll,1)
        for k=1:size(fpAll,2)
            block.all{j,k}(i,:)=fpAll{j,k}(1,:);
        end
    end
end

%% plot
colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
legends={'Array 1','Array 2','Array 3','Array 4'};

para.binstep=0.01; % bin step of data
para.xlim=[-2 2]; %time zone
para.ylim=[0.0 .4];
para.saxis=[0.5 0.1]; %%step of axis
para.line=[0; nan]; %lines to indicate the task epochs
para.colors=colors;
para.xlabel='Time from cue (s)';
% para.ylabel='Proportion of neurons (p < 0.05)';
para.ylabel='Percent of neurons';
para.smooth='Gaussian';

mtitle={'block.all'};

for m=1:length(mtitle)
    eval(['tMat='  mtitle{m} ';'])
    ttitle=mtitle{m};
    % ttitle='overlap(where.dir-where.obj)';
    para.title=ttitle;
    
    for k=1:size(tMat,2)
        temD=[tMat{1,k};tMat{2,k}];
%          temD=[tMat{1,k}+tMat{2,k}]/2;
        nanInd=find(isnan(temD));
        temD(nanInd)=0;
        Data{k}=temD;
    end
    
    %% plot
    para.legend=legends;
    para.baseline=[-1.5 -0.5];
    para.precue=[-0.5 0];
    
    [taveIntp, taveBasep, tavePrecue, onset] = ANOVA_ave_latency_plot(Data,para);
    
    xlim([-1 1.5])
end

% aveIntp{3,1}=aaveIntp; aveBasep{3,1}=aaveBasep;avePrecue{3,1}=aavePrecue;

tt=0;
for i=1:size(tMat,1)
    for j=1:size(tMat,2)
        for m=1:8
        tt=tt+1;
        ihemi(tt)=i;
        iarray(tt)=j;
        Y(tt)=mean(tMat{i,j}(m,201:351),2)
        end
    end
end


Xmat = {ihemi,iarray};

[p,tbl,stats] = anovan(Y,Xmat,'display','on','model','interaction','varnames',{'hemi','array'});%,,'model','interaction'
% [p,tbl,stats] = anovan(tY,Xmat,'nested',nestvar,'model','interaction','display','on','varnames',{'task','AP','al','domain'});%,,'model','interaction'


