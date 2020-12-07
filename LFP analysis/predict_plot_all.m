% used to plot all session files.
% last update: Oct 28, 2020

clear; close all; clc;
fnames={'v20160929','v20160930','v20161005','v20161017','w20160112','w20160113','w20160121','w20160122'}
% fnames={'v20160929','v20160930','w20160121','w20160122'}
conds={'left_what','left_where','right_what','right_where'};
hemis={'left','right'}
colors={'r','g','b','c','m','y'};
cd 'C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\LFP\predict_256'

for i=1:length(fnames)
    fname=fnames{i};
    for j=1:length(conds)
        load(['lfp_predict_', fname,'_', conds{j}])
        
        % only select several bins
        for iii=1:size(Maar,2)
            Maar{iii}=Maar{iii}(:,:,1:7);% 1:7 for raw
        end
        
        eval(['tMat_', conds{j}, '(', num2str(i),',:)=Maar;'])
    end
end

%% combine two hemisphere
for j=1:length(conds)
    for m=1:size(tMat_left_what,1)
        for n=1:size(tMat_left_what,2)
            tMat_what{m,n}=(tMat_left_what{m,n}+tMat_right_what{m,n})/2;
            tMat_where{m,n}=(tMat_left_where{m,n}+tMat_right_where{m,n})/2;
            tMat_all{m,n}=(tMat_left_what{m,n}+tMat_right_what{m,n}+tMat_left_where{m,n}+tMat_right_where{m,n})/4;
        end
    end
end

%% plot
% conds={'what','where'};
conds={'all'};

wh=nf(2); % t-test box w & h;
for j=1:length(conds)
    eval(['tMat=tMat_', conds{j}, ';'])
    
    for m=1:size(tMat,2) % pairs, 12
        for k=1:size(tMat,1) % session, 8
            ttMat{m}(:,:,:,k)=tMat{k,m};
        end
        tsMat{m}=squeeze(mean(ttMat{m},3)); % mean of bins: (A,B,sessions)
        tmMat{m}=mean(tsMat{m},3); % mean of sessions: (A,B)
    end
    
    %% plot raw cor
    figure
    for ii=1:size(ncho,1)
        subplot(3,4,ii)
        imagesc(nf,nf,tmMat{1, ii});
        set(gca,'ydir','normal')  % ‘reverse’
        xlabel('A - Frequency (Hz)')
        ylabel('B - Frequency (Hz)')
        colorbar
        title(['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))])
        caxis([-0.001 0.008])
        diagv(ii,:)=diag(tmMat{1, ii});
    end
    
    %% plot TU/BU coR
    for ii=1:6
        tmMat_TD(:,:,ii)=tmMat{1, ii};
        tmMat_BU(:,:,ii)=tmMat{1, 6+ii};
    end
    
    tb={'TD','BU'};
    figure
    for itb=1:2
        eval(['tMat_TB=tmMat_', tb{itb}, ';'])
        subplot(1,2,itb)
        imagesc(nf,nf,tril(mean(tMat_TB,3)));
        set(gca,'ydir','normal')  % ‘reverse’
        xlabel('Frequency (Hz) - Source')
        ylabel('Frequency (Hz) - Target')
        colorbar
        title( tb{itb})
        caxis([0 0.006])
    end
    
    
    figure
    tMat_TB=tmMat_TD-tmMat_BU;
    imagesc(nf,nf,tril(mean(tMat_TB,3)));
    set(gca,'ydir','normal')  % ‘reverse’
    xlabel('Frequency (Hz) - Source')
    ylabel('Frequency (Hz) - Target')
    colorbar
    title('RC - CR')
    caxis([-0.0005 0.0005])
    colormap(bluewhitered)
    
    % plot t-test
    hold on
    for im=1:size(tmMat_TD,1)
        for in=1:size(tmMat_TD,2)
            [h,p,ci,stats]=ttest(squeeze(tmMat_TD(im,in,:)),squeeze(tmMat_BU(im,in,:)));
            pMat(im,in)=h;
            if im <= in & p < 0.05 % tril
                rectangle('position',[nf(im)-wh/2,nf(in)-wh/2,wh,wh]);
            end
        end
    end
end

%% plot diagonal
for icho=1:size(ncho,1)
    dist(icho,1)=diff(ncho(icho,:));
end

figure
subplot(1,2,1)
hold on
for ii=1:6%size(ncho,1)
    plot(nf,diagv(ii,:),colors{ii},'linewidth',2)
    lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
end
xlabel('Frequency (Hz)')
ylabel('canonical coefficients')
legend(lens)
xlim([0 50])
title(strrep(['mean-of-8-sessions_', conds{j}],'_','\_'))

% plot diagonal: distance
subplot(1,2,2)
hold on
ij=1;
for j=[-3:-1,1:3]
    try
        tind=find(dist==j);
        tdiagv=mean(diagv(tind,:),1);
        plot(nf, tdiagv, colors{ij},'linewidth',2);
        ij=ij+1;
    end
end
xlabel('Frequency (Hz)')
ylabel('canonical coefficients')
legend({'-3','-2','-1','1','2','3'})
xlim([0 50])
title('distance')

%% TD - BU plot
figure
for ii=1:6
    subplot(2,3,ii)
    imagesc(nf,nf,tril(tmMat{1, ii}-tmMat{1, 6+ii}));
    
    set(gca,'ydir','normal')  % ‘reverse’
    xlabel('A - Frequency (Hz)')
    ylabel('B - Frequency (Hz)')
    colorbar
    title(['(array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2)),') - (array', num2str(ncho(ii,2)), ' - array', num2str(ncho(ii,1)),')'])
    caxis([-0.0005 0.0005])
    colormap(bluewhitered)
    
    % plot t-test
    hold on
    for im=1:size(tsMat{1, ii},1)
        for in=1:size(tsMat{1, ii},2)
            [h,p,ci,stats]=ttest(squeeze(tsMat{1, ii}(im,in,:)),squeeze(tsMat{1, 6+ii}(im,in,:)));
            pMat(im,in)=h;
            if im <= in & p < 0.05 % tril
                rectangle('position',[nf(im)-wh/2,nf(in)-wh/2,wh,wh]);
            end
        end
    end
end


%% creat new mat for what & where
for m=1:size(tMat_what,2)
    for kk=1:size(tMat_what,1)
        ttMat_what{m}(:,:,:,kk)=tMat_what{kk,m};
        ttMat_where{m}(:,:,:,kk)=tMat_where{kk,m};
    end
    tsMat_what{m}=squeeze(mean(ttMat_what{m},3)); % mean of bins: (A,B,sessions)
    tmMat_what{m}=mean(tsMat_what{m},3); % mean of sessions: (A,B)
    
    tsMat_where{m}=squeeze(mean(ttMat_where{m},3)); % mean of bins: (A,B,sessions)
    tmMat_where{m}=mean(tsMat_where{m},3); % mean of sessions: (A,B)
    
    sMat_task{m}=tsMat_what{1, m}-tsMat_where{1, m};
end

% plot diff(what, where)
figure
for ii=1:12
    subplot(3,4,ii)
    Mat_task(:,:,ii)=tmMat_what{1,ii}-tmMat_where{1,ii};
    imagesc(nf,nf,tril(Mat_task(:,:,ii)));
    set(gca,'ydir','normal')  % ‘reverse’
    xlabel('A - Frequency (Hz)')
    ylabel('B - Frequency (Hz)')
    colorbar
    title(['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))])
    diagv(ii,:)=diag(Mat_task(:,:,ii));
    caxis([-0.0004 0.0004])
    colormap(bluewhitered)
    
    % plot t-test
    hold on
    for im=1:size(tsMat_what{1, ii},1)
        for in=1:size(tsMat_what{1, ii},2)
            [h,p,ci,stats]=ttest(squeeze(tsMat_what{1, ii}(im,in,:)),squeeze(tsMat_where{1, ii}(im,in,:)));
            pMat(im,in)=h;
            if im <= in & p < 0.05 % tril
                rectangle('position',[nf(im)-wh/2,nf(in)-wh/2,wh,wh]);
            end
        end
    end
end

%% line plot of bands: what or where: TD - BU
fname='mean-of-8sessions'
figure
for i=1:4
    subplot(2,2,i)
    predict_plot_lines(tmMat_what,tmMat_where,i,fname,'L&R',nf,colors,ncho)
end

% plot by distance
for i=1:4
    predict_plot_lines_dist(tsMat_what,tsMat_where,i,fname,'L&R',nf,colors,ncho)
end

% line plot of diagonal
figure
hold on
for ii=1:6%size(ncho,1)
    plot(nf,diagv(ii,:),'linewidth',2)
    lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
end
for ii=7:12%size(ncho,1)
    plot(nf,diagv(ii,:),'k--','linewidth',1)
    lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
end
xlabel('Frequency (Hz)')
ylabel('canonical coefficients')
legend(lens{1:6})
xlim([0 100])
title(strrep([fname,'_','L&R', ': what - where'],'_','\_'))

%% (what - where) & (TD - BU)
figure
for ii=1:6
    subplot(2,3,ii)
    %     imagesc(nf,nf,tril(Mat_task(:,:,ii)-Mat_task(:,:,6+ii)));
    imagesc(nf,nf,tril(abs(Mat_task(:,:,ii))-abs(Mat_task(:,:,6+ii))));
    set(gca,'ydir','normal')  % ‘reverse’
    xlabel('A - Frequency (Hz)')
    ylabel('B - Frequency (Hz)')
    colorbar
    title(['abs((array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2)),') - (array', num2str(ncho(ii,2)), ' - array', num2str(ncho(ii,1)),'))'])
    caxis([-0.0004 0.0004])
    colormap(bluewhitered)
    
    % plot t-test
    hold on
    
    for im=1:size(sMat_task{1, ii},1)
        for in=1:size(sMat_task{1, ii},2)
            [h,p,ci,stats]=ttest(squeeze(sMat_task{1, ii}(im,in,:)),squeeze(sMat_task{1, 6+ii}(im,in,:)));
            pMat(im,in)=h;
            if im <= in & p < 0.05 % tril
                rectangle('position',[nf(im)-wh/2,nf(in)-wh/2,wh,wh]);
            end
        end
    end
end
