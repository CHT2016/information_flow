% Used to do analysis for decoding-prediction of what&where task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: July 25,2019.

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017
% last updated: July 25,2019

close all; clear; clc;

% loading filelist
cd('C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\whatwhere\Analysis\Decoding')

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
    %% what & where task
    
    load(list{i}, 'deco_dira', 'deco_obja','Bin','beh');
    for j=1:size(deco_dira.what,1)
        for k=1:size(deco_dira.what,2)
            adeco_dira.what{j,k}(i,:)=deco_dira.what{j,k};
            adeco_dira.where{j,k}(i,:)=deco_dira.where{j,k};
            adeco_obja.what{j,k}(i,:)=deco_obja.what{j,k};
            adeco_obja.where{j,k}(i,:)=deco_obja.where{j,k};
        end
    end
    numTri(i)=length(beh.reward);
    
    % % % % %     % what & where task %% reward
    % % %     load(list{i}, 'deco_rewa','Bin','beh');
    % % %     for j=1:size(deco_rewa.what,1)
    % % %         for k=1:size(deco_rewa.what,2)
    % % %             adeco_rewa.what{j,k}(i,:)=deco_rewa.what{j,k};
    % % %             adeco_rewa.where{j,k}(i,:)=deco_rewa.where{j,k};
    % % %         end
    % % %     end
    % % %     numTri(i)=length(beh.reward);
    
    % % %     % what & where task  %% block type
    % % %     load(list{i}, 'deco_bloa','Bin','beh');
    % % %     for j=1:size(deco_bloa.what,1)
    % % %         for k=1:size(deco_bloa.what,2)
    % % %             adeco_bloa.what{j,k}(i,:)=deco_bloa.what{j,k};
    % % %             adeco_bloa.where{j,k}(i,:)=deco_bloa.where{j,k};
    % % %         end
    % % %     end
    % % %     numTri(i)=length(beh.reward);
    % % %
    
    % % %     %% novelty task
    % % %
    % % %     load(list{i}, 'doco_dira', 'doco_obja','Bin','Coder');
    % % %     for j=1:size( doco_dira,1)
    % % %         for k=1:size( doco_dira,2)
    % % %             adeco_dira{j,k}(i,:)=doco_dira{j,k};
    % % %             adeco_obja{j,k}(i,:)=doco_obja{j,k};
    % % %         end
    % % %     end
    % % %     numTri(i)=length(Coder.reward);
    
    % % %     % %% novelty task  %% reward
    % % %     load(list{i}, 'deco_rewa','Bin','Coder');
    % % %     for j=1:size( deco_rewa,1)
    % % %         for k=1:size( deco_rewa,2)
    % % %             adeco_rewa{j,k}(i,:)=deco_rewa{j,k};
    % % %         end
    % % %     end
    % % %     numTri(i)=length(Coder.reward);
end


colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
legends={'L1','L2','L3','L4','R1','R2','R3','R4'}


%% two-proportions test
ioa=[1,2,3,4]
ncho=nchoosek(ioa,2);

para.binstep=20; % bin step of data
para.xlim=[-2000 2000]; %time zone
para.ylim=[.4 .9];
para.saxis=[500 0.05]; %%step of axis
para.line=[0; nan]; %lines to indicate the task epochs
para.colors=colors;
para.xlabel='Time from cue (ms)';
para.ylabel='Decoding accuracy';
% para.smooth='Gaussian';
% para.title=ttitle;
para.bins=para.xlim(1):para.binstep:para.xlim(2);

% mtitle={'adeco_rewa.what','adeco_rewa.where'}
mtitle={'adeco_dira.what','adeco_dira.where','adeco_obja.what','adeco_obja.where'};


nc=3;%% continual number of bins
ttt=0
for m=1:length(mtitle)
    eval(['tMat='  mtitle{m} ';'])
    ttitle=mtitle{m};
    para.title=ttitle;
    
    for j=1:size(tMat,1)
        %%% SEM plot
        for k=1:size(tMat,2)
            temD=tMat{j,k};
            nanInd=find(isnan(temD));
            temD(nanInd)=0.5;
            Data{k}=temD;
        end
        
        % % % %         %% onset time, kick one off
        % % % %         para.legend=legends((j-1)*4+1:j*4);
        % % % %         para.baseline=[-1500 -500];
        % % % %         para.precue=[-500 0];
        % % % %         for ii=1:8
        % % % %             ps = setdiff([1:8],ii);
        % % % %             for k=1:size(tMat,2)
        % % % %                 nData{k} =  Data{k} (ps,:);
        % % % %             end
        % % % %             [taveIntp, taveBasep, tavePrecue, tonset] = Decoding_ave_latency_plot(nData,para);
        % % % %             onset{j,m}(ii,:)=tonset;
        % % % %         end
        
        %%
        para.legend=legends((j-1)*4+1:j*4);
        LINE_nPlot(Data,para)
        xlim([-500 1500])
        
        para.baseline=[-1500 -500];
        para.precue=[-500 0];
        
        %         [taveIntp, taveBasep,tavePrecue, indp,realP] = ANOVA_ave_latency_plot_matriax(Data,para);
        [taveIntp, taveBasep, tavePrecue, onset] = Decoding_ave_latency_plot(Data,para);
        
        % % %         aveIntp{j,m}=taveIntp; aveBasep{j,m}=taveBasep; avePrecue{j,m}=tavePrecue; averP{j,m}=realP;
        % % %         ttt=ttt+1;
        % % %         aaveIntp(:,:,ttt)=taveIntp; aaveBasep(:,:,ttt)=taveBasep; aavePrecue(:,:,ttt)=tavePrecue;
        % % %
        %%% one side and paired t-test
        Ylim=get(gca,'ylim');
        ylim([Ylim(1) Ylim(2)])
        for i=1:size(ncho,1)
            tncho=ncho(i,:);
            x1=tMat{j,tncho(1)}; x2=tMat{j,tncho(2)};
            
            for k=1:length(Bin.cen)
                % [~,p,~,~] = ttest(x1(:,k),x2(:,k),'Tail','left');
                [~,P(k),~,~] = ttest(x1(:,k),x2(:,k));
            end
            
            %% plot continual * # 5
            sigP=P < 0.01;
            [ind,ind1, ~]=continual_n(sigP',nc);
            
            if ~isnan(ind)
                for k=1:length(Bin.cen)
                    if ind(k) == 1
                        plot(Bin.cen(k),Ylim(2)-i*0.008,'*','color',colors{i},'MarkerSize',6)
                    end
                end
            end
        end
        
    end
end
% aveIntp{3,1}=aaveIntp; aveBasep{3,1}=aaveBasep; avePrecue{3,1}=aavePrecue;


%% cross-correlation
% % % legends={'L1-2','R1-2','L1-3','R1-3','L1-4','R1-4','L2-3','R2-3','L2-4','R2-4','L3-4','R3-4'}
% % %
% % % figure
% % % hold on
% % % for i=1:size(ncho,1)
% % %     tncho=ncho(i,:);
% % %
% % %     for j=1:size(tMat,1)
% % %         for k=1:length(Bin.cen)
% % %             r(k) = corr(tMat{j,tncho(1)}(:,k),tMat{j,tncho(2)}(:,k));
% % %         end
% % %         [yp, ~] = smooth1d(r', (1:length(r))', floor(length(r)/5), 1);
% % %         if j==1
% % %             plot(Bin.cen,yp,'color',colors{i},'linewidth',2);
% % %         elseif j==2
% % %             plot(Bin.cen,yp,'--','color',colors{i},'linewidth',1);
% % %         end
% % %     end
% % %     title([ttitle])
% % %     legend(legends,'AutoUpdate','off');
% % %     xlabel('Time from cue (s)','fontsize',12)
% % %     ylabel('Cross-correlation','fontsize',12)
% % % end