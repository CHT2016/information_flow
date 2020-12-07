function predict_plot_lines(Mat_what,Mat_where,band,fname,hemis,nf,colors,ncho)
% Last update: June 21, 2020

hold on
for ii=1:6%size(ncho,1)
    twhat= mean(Mat_what{1, ii},3)-mean(Mat_what{1, ii+6},3);
    twhere= mean(Mat_where{1, ii},3)-mean(Mat_where{1, ii+6},3);
    
    if band==1
        mtwhat=mean(twhat(2:3,:));
        mtwhere=mean(twhere(2:3,:));
        ttl=strrep([fname,'_', hemis, ': 2-10 HZ (X)'],'_','\_');
    elseif band==2
        mtwhat=mean(twhat(:,2:3),2);
        mtwhere=mean(twhere(:,2:3),2);
        ttl=strrep([fname,'_', hemis, ': 2-10 HZ (Y)'],'_','\_');
    elseif band==3
        mtwhat=mean(twhat(4:6,:));
        mtwhere=mean(twhere(4:6,:));
        ttl=strrep([fname,'_', hemis, ': 10-22 HZ (X)'],'_','\_');
    elseif band==4
        mtwhat=mean(twhat(:,4:6),2);
        mtwhere=mean(twhere(:,4:6),2);
        ttl=strrep([fname,'_', hemis, ': 10-22 HZ (Y)'],'_','\_');
    end
    
    h1(ii)=plot(nf, mtwhat, colors{ii},'linewidth',2);
    plot(nf, mtwhere, colors{ii},'linewidth',1);
    lens{ii}=['array', num2str(ncho(ii,1)), ' - array', num2str(ncho(ii,2))];
end
xlabel('Frequency (Hz)')
ylabel('canonical coefficients')
legend(h1,lens{1:6})
xlim([0 100])
title(ttl)
end