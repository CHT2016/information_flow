% Used to do analysis for decoding-prediction of what&where task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% with hemispheres combined. Nov 4,2019.
% last updated: Nov 4,2019.

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
% % %     %% what & where task
% % %     
% % %     load(list{i}, 'deco_dira', 'deco_obja','Bin','beh');%
% % %     for j=1:size(deco_dira.what,1)
% % %         for k=1:size(deco_dira.what,2)
% % %             adeco_dira.what{j,k}(i,:)=deco_dira.what{j,k};
% % %             adeco_dira.where{j,k}(i,:)=deco_dira.where{j,k};
% % %             adeco_obja.what{j,k}(i,:)=deco_obja.what{j,k};
% % %             adeco_obja.where{j,k}(i,:)=deco_obja.where{j,k};
% % %         end
% % %     end
% % %     numTri(i)=length(beh.reward);
    
% % %         % what & where task %% reward
% % %         load(list{i}, 'deco_rewa','Bin','beh');
% % %         for j=1:size(deco_rewa.what,1)
% % %             for k=1:size(deco_rewa.what,2)
% % %                 adeco_rewa.what{j,k}(i,:)=deco_rewa.what{j,k};
% % %                 adeco_rewa.where{j,k}(i,:)=deco_rewa.where{j,k};
% % %             end
% % %         end
% % %         numTri(i)=length(beh.reward);
    
        % what & where task  %% block type
        load(list{i}, 'deco_bloa','Bin','beh');
        for j=1:size(deco_bloa.what,1)
            for k=1:size(deco_bloa.what,2)
                adeco_bloa.what{j,k}(i,:)=deco_bloa.what{j,k};
                adeco_bloa.where{j,k}(i,:)=deco_bloa.where{j,k};
            end
        end
        numTri(i)=length(beh.reward);
    
    
    %% novelty task
    
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
legends={'L/R1','L/R2','L/R3','L/R4'};
%% two-proportions test
ioa=[1,2,3,4]
ncho=nchoosek(ioa,2);

para.binstep=20; % bin step of data
para.xlim=[-2000 2000]; %time zone
para.ylim=[.45 .65];
para.saxis=[500 0.05]; %%step of axis
para.line=[0; nan]; %lines to indicate the task epochs
para.colors=colors;
para.xlabel='Time from cue (ms)';
para.ylabel='Decoding accuracy';
para.smooth='Gaussian';

% mtitle={'adeco_rewa.what','adeco_rewa.where'}
mtitle={'adeco_bloa.what','adeco_bloa.where'}
% mtitle={'adeco_dira.what','adeco_dira.where','adeco_obja.what','adeco_obja.where'};

nc=3;%% continual number of bins
ttt=0
for m=1:length(mtitle)
    eval(['tMat='  mtitle{m} ';'])
    ttitle=mtitle{m};
    para.title=ttitle;
    
    %%% SEM plot
    for k=1:size(tMat,2)
        temD=[tMat{1,k};tMat{2,k}];
        nanInd=find(isnan(temD));
        temD(nanInd)=0.5;
        Data{k}=temD;
    end
    
    para.legend=legends;
    para.baseline=[-1500 -500];
    para.precue=[-500 0];
    [taveIntp, taveBasep,tavePrecue, indp,realP] = ANOVA_ave_latency_plot_matriax(Data,para);
  
    xlim([-500 1500])
    
    %%% one side and paired t-test
    Ylim=get(gca,'ylim');
    ylim([Ylim(1) Ylim(2)])
    for i=1:size(ncho,1)
        tncho=ncho(i,:);
        x1=Data{1,tncho(1)}; x2=Data{1,tncho(2)};
        
        %%
        nc=3;
        for k=1:length(Bin.cen)
            [~,P(k),~,~] = ttest(x1(:,k),x2(:,k));
        end
        
        sigP=P<0.01;
        [ind,ind1, ~]=continual_n(sigP',nc);
        indp(:,m)=ind;
        realP(:,m)=(P)';
        
        for k=1:length(Bin.cen)
            if ind(k) == 1
                plot(Bin.cen(k),Ylim(2)-i*0.008,'*','color',colors{i},'MarkerSize',6)
            end
        end
    end
end
