function predict_plot_lines_dist(Mat_what,Mat_where,band,fname,hemis,nf,colors,ncho)
% Last update: July 14, 2020

for ii=1:size(ncho,1)
    twhat= Mat_what{1, ii};
    twhere= Mat_where{1, ii};
    
    if band==1
        mtwhat(ii,:,:)=squeeze(mean(twhat(:,2:3,:),2));
        mtwhere(ii,:,:)=squeeze(mean(twhere(:,2:3,:),2));
        ttl=strrep([hemis, ': 2-10 HZ (X) to '],'_','\_');
    elseif band==2
        mtwhat(ii,:,:)=squeeze(mean(twhat(:,4:6,:),2));
        mtwhere(ii,:,:)=squeeze(mean(twhere(:,4:6,:),2));
        ttl=strrep([hemis, ': 10-22 HZ (X) to '],'_','\_');
    elseif band==3
        mtwhat(ii,:,:)=squeeze(mean(twhat(:,7:11,:),2));
        mtwhere(ii,:,:)=squeeze(mean(twhere(:,7:11,:),2));
        ttl=strrep([hemis, ': 22-41 HZ (X) to '],'_','\_');
        %     elseif band==4
        %         mtwhat(ii,:,:)=squeeze(mean(twhat(:,12:18,:),2));
        %         mtwhere(ii,:,:)=squeeze(mean(twhere(:,12:18,:),2));
        %         ttl=strrep([hemis, ': 41-68 HZ (X) to '],'_','\_');
    elseif band==4
        mtwhat(ii,:,:)=squeeze(mean(twhat(:,12:27,:),2));
        mtwhere(ii,:,:)=squeeze(mean(twhere(:,12:27,:),2));
        ttl=strrep([hemis, ': 41-100 HZ (X) to '],'_','\_');
    end
    dist(ii,1)=-diff(ncho(ii,:));
end

%% plot
figure

subplot(2,3,1)
hold on
ij=1;
for j=[-3:-1,1:3]
    try
        tind=find(dist==j);
        tmat_what=squeeze(mean(mtwhat(tind,:,:),1));
        plot(nf, mean(tmat_what,2), colors{ij},'linewidth',2);
        peak_what(ij,:,1)=mean(tmat_what(2:3,:),1);
        peak_what(ij,:,2)=mean(tmat_what(4:6,:),1);
        peak_what(ij,:,3)=mean(tmat_what(7:11,:),1);
        %         peak_what(ij,:,4)=mean(tmat_what(12:18,:),1);
        peak_what(ij,:,4)=mean(tmat_what(12:27,:),1);
        ij=ij+1;
    end
end
xlabel('Frequency (Hz)')
ylabel('canonical coefficients')
legend({'-3','-2','-1','1','2','3'})
xlim([0 100])
title('what')

subplot(2,3,2)
hold on
ij=1;
for j=[-3:-1,1:3]
    try
        tind=find(dist==j);
        tmat_where=squeeze(mean(mtwhere(tind,:,:),1));
        plot(nf, mean(tmat_where,2), colors{ij},'linewidth',2);
        peak_where(ij,:,1)=mean(tmat_where(2:3,:),1);
        peak_where(ij,:,2)=mean(tmat_where(4:6,:),1);
        peak_where(ij,:,3)=mean(tmat_where(7:11,:),1);
        %         peak_where(ij,:,4)=mean(tmat_where(12:18,:),1);
        peak_where(ij,:,4)=mean(tmat_where(12:27,:),1);
        ij=ij+1;
    end
end
xlabel('Frequency (Hz)')
ylabel('canonical coefficients')
legend({'-3','-2','-1','1','2','3'})
xlim([0 100])
title('where')


tttl={'2-10 HZ', '10-22 HZ', '22-41 HZ', '41-100 HZ'};
for mm=band:4
    subplot(2,3,2+mm)
    tData=peak_what(:,:,mm)';
    yMean=nanmean(tData,1);
    ySEM=nanstd(tData,1)./sqrt(sum(~isnan(tData),1)); % Compute ‘Standard Error Of The Mean’
    errorbar([-3:2],yMean,ySEM,'r','linewidth',2) % [-3:-1,1:3]
    
    rc=[];cr=[];
    rc=reshape(tData(:,1:3),24,1);
    cr=reshape(tData(:,4:6),24,1);
    
    hold on
    tData=peak_where(:,:,mm)';
    yMean=nanmean(tData,1);
    ySEM=nanstd(tData,1)./sqrt(sum(~isnan(tData),1)); % Compute ‘Standard Error Of The Mean’
    errorbar([-3:2],yMean,ySEM,'b','linewidth',2)
    title([ttl, tttl{mm}])
    legend({'what','where'})
    xlabel('rostral - caudal / caudal rostral')
    ylabel('canonical coefficients')
    xlim([-3.5 2.5])
    
    % unpaired t-test
    rc=[rc; reshape(tData(:,1:3),24,1)];
    cr=[cr; reshape(tData(:,4:6),24,1)];
    [h,p,ci,stats]=ttest2(rc, cr);
    tt{1}=['p=',num2str(p)]; % tt{1}=['p=',num2str(roundn(p,-3))];
    tt{2}=['df=',num2str(stats.df)];
    tt{3}=['stats=',num2str(roundn(stats.tstat,-3))];
    text(-1,mean(yMean), tt);
end
end