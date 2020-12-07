% used to plot single session file.
% last update: June 19, 2020

clear; close all; clc;
fnames={'v20160929','v20160930','v20161005','v20161017','w20160112','w20160113','w20160121','w20160122'}
conds={'left_what','left_where','right_what','right_where'};
hemis={'left','right'}
cd 'C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\LFPtest\predict_200'

for i=1:4
    fname=fnames{i};
    for j=1:length(conds)
        load(['lfp_predict_', fname,'_', conds{j},'_200'])
        eval(['tMat_', conds{j}, '=Maar;'])
        tMat=Maar;
        
        %% plot
        figure
        for ii=1:6%size(ncho,1)
            subplot(2,3,ii)
            imagesc(nf,nf,mean(tMat{1, ii},3));
            set(gca,'ydir','normal')  % ‘reverse’
            xlabel('A - Frequency (Hz)')
            ylabel('B - Frequency (Hz)')
            colorbar
            title(['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))])
            
            diagv(ii,:)=diag(mean(tMat{1, ii},3));
        end
        
        figure
        hold on
        for ii=1:6%size(ncho,1)
            plot(nf,diagv(ii,:),'linewidth',2)
            lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
        end
        
        xlabel('Frequency (Hz)')
        ylabel('canonical coefficients')
        legend(lens)
        xlim([0 100])
        title(strrep([fname,'_', conds{j}],'_','\_'))
        
        %% minus
        figure
        for ii=1:6
            subplot(2,3,ii)
            imagesc(nf,nf,mean(tMat{1, ii},3)-mean(tMat{1, 6+ii},3));
            set(gca,'ydir','normal')  % ‘reverse’
            xlabel('A - Frequency (Hz)')
            ylabel('B - Frequency (Hz)')
            colorbar
            title(['(array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2)),') - (array', num2str(ncho(ii,2)), ' - array', num2str(ncho(ii,1)),')'])
            
            diagv(ii,:)=diag(mean(tMat{1, ii},3));
            %     caxis([-0.00005 0.00005])
        end
    end
    
    %% between tasks
    for k=1:length(hemis)
        eval(['tMat_what=tMat_', hemis{k}, '_what;'])
        eval(['tMat_where=tMat_', hemis{k}, '_where;'])
        
        figure
        for ii=1:12
            subplot(3,4,ii)
            Mat_task(:,:,ii)=mean(tMat_what{1, ii},3)-mean(tMat_where{1, ii},3);
            imagesc(nf,nf,Mat_task(:,:,ii));
            set(gca,'ydir','normal')  % ‘reverse’
            xlabel('A - Frequency (Hz)')
            ylabel('B - Frequency (Hz)')
            colorbar
            title(['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))])
            diagv(ii,:)=diag(Mat_task(:,:,ii));
            %     caxis([-0.00005 0.00005])
        end
        
        colors={'r','g','b','c','m','y'};
        
        figure
        subplot(2,2,1)
        hold on
        for ii=1:6%size(ncho,1)
            twhat= mean(tMat_what{1, ii},3)-mean(tMat_what{1, ii+6},3);
            twhere= mean(tMat_where{1, ii},3)-mean(tMat_where{1, ii+6},3);
            h1(ii)=plot(nf,  mean(twhat(2:3,:)),colors{ii},'linewidth',2)
            plot(nf,  mean(twhere(2:3,:)),colors{ii},'linewidth',1)
            lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
        end
        xlabel('Frequency (Hz)')
        ylabel('canonical coefficients')
        legend(h1,lens{1:6})
        xlim([0 100])
        title(strrep([fname,'_', hemis{k}, ': 4-8 HZ (X)'],'_','\_'))
        
        subplot(2,2,2)
        hold on
        for ii=1:6%size(ncho,1)
            twhat= mean(tMat_what{1, ii},3)-mean(tMat_what{1, ii+6},3);
            twhere= mean(tMat_where{1, ii},3)-mean(tMat_where{1, ii+6},3);
            h1(ii)=plot(nf,mean(twhat(:,2:3),2),colors{ii},'linewidth',2)
            plot(nf,  mean(twhere(:,2:3),2),colors{ii},'linewidth',1)
            lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
        end
        xlabel('Frequency (Hz)')
        ylabel('canonical coefficients')
        legend(h1,lens{1:6})
        xlim([0 100])
        title(strrep([fname,'_', hemis{k}, ': 4-8 HZ (Y)'],'_','\_'))
        
        subplot(2,2,3)
        hold on
        for ii=1:6%size(ncho,1)
            twhat= mean(tMat_what{1, ii},3)-mean(tMat_what{1, ii+6},3);
            twhere= mean(tMat_where{1, ii},3)-mean(tMat_where{1, ii+6},3);
            h1(ii)=plot(nf,  mean(twhat(4:6,:)),colors{ii},'linewidth',2)
            plot(nf,  mean(twhere(4:6,:)),colors{ii},'linewidth',1)
            lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
        end
        xlabel('Frequency (Hz)')
        ylabel('canonical coefficients')
        legend(h1,lens{1:6})
        xlim([0 100])
        title(strrep([fname,'_', hemis{k}, ': 12-20 HZ (X)'],'_','\_'))
        
        subplot(2,2,4)
        hold on
        for ii=1:6%size(ncho,1)
            twhat= mean(tMat_what{1, ii},3)-mean(tMat_what{1, ii+6},3);
            twhere= mean(tMat_where{1, ii},3)-mean(tMat_where{1, ii+6},3);
            h1(ii)=plot(nf,mean(twhat(:,4:6),2),colors{ii},'linewidth',2)
            plot(nf,  mean(twhere(:,4:6),2),colors{ii},'linewidth',1)
            lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
        end
        xlabel('Frequency (Hz)')
        ylabel('canonical coefficients')
        legend(h1,lens{1:6})
        xlim([0 100])
        title(strrep([fname,'_', hemis{k}, ': 12-20 HZ (Y)'],'_','\_'))
        
        
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
        title(strrep([fname,'_', hemis{k}, ': what - where'],'_','\_'))
        
        figure
        for ii=1:6
            subplot(2,3,ii)
            imagesc(nf,nf,Mat_task(:,:,ii)-Mat_task(:,:,6+ii));
            set(gca,'ydir','normal')  % ‘reverse’
            xlabel('A - Frequency (Hz)')
            ylabel('B - Frequency (Hz)')
            colorbar
            title(['(array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2)),') - (array', num2str(ncho(ii,2)), ' - array', num2str(ncho(ii,1)),')'])
            %     caxis([-0.00005 0.00005])
        end
    end
end


for i=1:9
    subplot(3,3,i)
    imagesc(nf,nf,tMat_left_what{1, 6}(:,:,i));
    set(gca,'ydir','normal')  % ‘reverse’
    xlabel('A - Frequency (Hz)')
    ylabel('B - Frequency (Hz)')
    colorbar
    title([fname, ' - left - (array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2)),'): bin ', num2str(Bin.cen(i+1))])
end
