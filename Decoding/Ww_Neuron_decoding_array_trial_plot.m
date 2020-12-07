% This function is used to do decoding trial by trial (1 to 80) for noverty task
% Not separated by small group, ectract decoding results from whole-session decoding file.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in March 2019.
% last updated: September 4,2019.

close all; clear; clc;

% loading filelist
cd 'C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding\deco_trial'

[sourcefilename, pathname] = uigetfile('*.mat', 'multiselect','on');
if isequal(sourcefilename,0)
    error 'No file was selected'
    return
end

list=[];
for n=1:length(sourcefilename)
    list{n,1}=sourcefilename{n}(1:end-4);
end

% loading data
for i=1:length(list)
    % what & where task
    load(list{i}, 'dTri_obj', 'dTri_dir','dTri_blo','Bin');
    for j=1:size(dTri_obj.what,1)
        for k=1:size(dTri_obj.what,2)
            adTri_obj.what{j,k}(:,:,i)=dTri_obj.what{j,k};
            adTri_obj.where{j,k}(:,:,i)=dTri_obj.where{j,k};
            
            adTri_dir.what{j,k}(:,:,i)=dTri_dir.what{j,k};
            adTri_dir.where{j,k}(:,:,i)=dTri_dir.where{j,k};
            
            adTri_blo.what{j,k}(:,:,i)=dTri_blo.what{j,k};
            adTri_blo.where{j,k}(:,:,i)=dTri_blo.where{j,k};
        end
    end
end



%% heatmap
ptMat=nanmean(adTri_blo.where{1,4},3);
ptMat(1,:)=0.5;
tMat=[];

for n=1:size(ptMat,2)
    ttt=ptMat(:,n);
    [tMat(:,n), ~] =  smooth1d(ttt, (1:length(ttt))', 5, 1);
end
for m=1:size(ptMat,1)
    ttt=tMat(m,:);
    [tMat(m,:), ~] = smooth1d(ttt', (1:length(ttt))', 5, 1);
end

figure
imagesc(Bin.cen,1:80,tMat)
colorbar
caxis([0.5 .6])
hold on
plot([0 0],[ 1 80],'k--')

xlabel('Time from cue (ms)','fontsize',12)
ylabel('Trial number','fontsize',12)
title(strrep('L4','_','\_'))


%% 
tt=adTri_obj.what;
avT=[];
nnn=0;
for i=1:2
    for j=1:4
        nnn=nnn+1;
        avT(nnn,:)=nanmean(nanmean(tt{i,j}(:,1:201),3),2)';
    end
end
    
colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
arrarL={'L1','L2','L3','L4','R1','R2','R3','R4'};

figure
hold on
for m=1:8
    [yp, ~] = smooth1d(avT(m,:)', (1:length(avT(m,:)))', floor(length(avT(m,:))/5), 1);
    plot(1:80,yp,'color',colors{m},'linewidth',2)
end

legend(arrarL)
xlabel('Trial number','fontsize',12)
ylabel('decoding accuracy','fontsize',12)
title(strrep('obj.what','_','\_'))

