% Used to do plot decoding accuracy by learning period
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 2019.
% last updated: November 5,2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017
% last updated: July 25,2019

close all; clear; clc;

% loading filelist
cd('C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding')

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
    load(list{i}, 'deco_obj','deco_dir','Bin','beh');
    
    for j=1:size(deco_dir.what,1)
        for k=1:size(deco_dir.what,2)
            adeco_dir.what{j,k}(:,:,i)=Decoding_accuracy_bytrial(deco_dir.what{j,k});
            adeco_dir.where{j,k}(:,:,i)=Decoding_accuracy_bytrial(deco_dir.where{j,k});
            adeco_obj.what{j,k}(:,:,i)=Decoding_accuracy_bytrial(deco_obj.what{j,k});
            adeco_obj.where{j,k}(:,:,i)=Decoding_accuracy_bytrial(deco_obj.where{j,k});
            
            %             adeco_dir.what{j,k}{i}=deco_dir.what{j,k};
            %             adeco_dir.where{j,k}{i}=deco_dir.where{j,k};
        end
    end
end

% analysis
% tM=adeco_obj.what{2, 3};

tM=adeco_obj.what{2, 1}-adeco_obj.where{2,1};
ttM=mean(tM,3);

para.bins=1:80;
para.ylim=[-.05 0.15];
para.smooth='Gaussian'
SEM_Plot(squeeze(mean(tM(:,75:100,:),2))',para)


figure
[msurf] = smooth2d(ttM, 5, 1, 1);
[X, Y] = meshgrid(Bin.cen, 1:80);
meshz(X, Y, msurf)

nT=20;
colors=linspecer(80/nT);
figure 
hold on
for i=1:80/nT
tttM=mean(ttM((i-1)*nT+1:i*nT,:));
[yp, ~] = smooth1d(tttM', (1:length(tttM))', 10, 1);
plot(Bin.cen,yp,'color', colors(i,:),'linewidth',2)
end
ylim([-0.05 0.1])
legend({'1','2','3','4','5','6','7','8'})