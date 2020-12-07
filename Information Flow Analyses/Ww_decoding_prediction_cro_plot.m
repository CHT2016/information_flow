% Used to do plot results (yyh) for decoding-prediction of what&where task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in september 2019.
%__________________________________________________________________________
% last updated: September 17,2019.
%__________________________________________________________________________
% % related scripts:
% % % Ww_decoding_prediction_cro_analysis.m % original
%__________________________________________________________________________

close all; clear; clc;
% loading filelist
cd('C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding\pred_dTask\[pred_dTask_-500_1500]')

[sourcefilename, path] = uigetfile('*.mat', 'multiselect','on');
if isequal(sourcefilename,0)
    error 'No file was selected'
    return
end
cd (path)

colors={'r', 'g', 'b', 'c', 'm', 'k', 'y','c'};

list=[];
for n=1:length(sourcefilename)
    list{n,1}=sourcefilename{n}(1:end-4);
end

%% loading data
for i=1:length(list)
    load(list{i});
    for j=1:8
        ayyh.dir_what{1,j}(:,:,i)=yyh.dir_what{1,j};
        ayyh.dir_where{1,j}(:,:,i)=yyh.dir_where{1,j};
        ayyh.obj_what{1,j}(:,:,i)=yyh.obj_what{1,j};
        ayyh.obj_where{1,j}(:,:,i)=yyh.obj_where{1,j};
    end
    
    %% plot
    Bin.period=[-500 1500]; % update Bin information
    step=20;
    Bin.cen=Bin.period(1):step:Bin.period(2);
    Bin.nbin=10;
    Bin.center='cue';
    
    Mat=yyh.dir_where;
    fname=[list{i} '.dir_where']
    
    scrsz = get(groot,'ScreenSize');
    figure('Color','w','OuterPosition',[0, 0, scrsz(3) scrsz(4)]);
    figure
    hold on
    for j=1:8
        yMat=Mat{1, j};
        %         subplot(3,3,j)
        %         prediction_cro_plot_4array(Bin,yMat,j)
        %         prediction_cro_plot_8array(Bin,yMat,j)
        %         ylim([-0.01 0.03])
        
        %%%  real value-full array
        tt=yMat(9,:)-yMat(10,:);
        [yp, ~] = smooth1d(tt', (1:length(tt))', floor(length(tt)/10), 1); % real posterior probability
        plot(Bin.cen,yp,'color',colors{j},'linewidth',2)
        tl{j}=['d\_' num2str(j)];
        ttt(j,:)=tt;
    end
  
    
    % title(['posterior probability: real & prediction, array', num2str(aID)])
    legend({'d-1','d-2','d-3','d-4','real value','full array'},'AutoUpdate','off');
    xlabel('Time from cue','fontsize',12)
    ylabel('Posterior probability','fontsize',12)
    
    saveas(gcf,[path,fname,'.png']) %% Hua add (Feb 6, 2019)
end