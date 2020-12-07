% Used to do analysis for decoding-prediction of what&where task
%%%% split by both the hemisphere of arrary and target.%%%%
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: March 2,2020.

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
    %% what & where task
    load(list{i}, 'deco_dir', 'deco_obj','Bin','beh');
    
    for j=1:size(deco_obj.where,1)
        for k=1:size(deco_obj.what,2)
            temArray=deco_obj.what{j,k};
            for l=1:length(temArray)
                temBin=temArray{1,l};
                deco_obja.what{j,k}(1,l)=mean(temBin(temBin(:,3)==1,2));%%monkey chose left
                deco_obja.what{j,k}(2,l)=mean(temBin(temBin(:,3)==2,2));%%monkey chose right
            end
            
            adeco_obja.what_tleft{j,k}(i,:)=deco_obja.what{j,k}(1,:);
            adeco_obja.what_tright{j,k}(i,:)=deco_obja.what{j,k}(2,:);
        end
    end
           
% %     for j=1:size(deco_dir.where,1)
% %         for k=1:size(deco_dir.where,2)
% %             temArray=deco_dir.where{j,k};
% %             for l=1:length(temArray)
% %                 temBin=temArray{1,l};
% %                 deco_dira.where{j,k}(1,l)=mean(temBin(temBin(:,3)==1,2));%%monkey chose left
% %                 deco_dira.where{j,k}(2,l)=mean(temBin(temBin(:,3)==2,2));%%monkey chose right
% %             end
% %             
% %             adeco_dira.where_tleft{j,k}(i,:)=deco_dira.where{j,k}(1,:);
% %             adeco_dira.where_tright{j,k}(i,:)=deco_dira.where{j,k}(2,:);
% %         end
% %     end
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
para.smooth='Gaussian';
% para.title=ttitle;


mtitle={'adeco_obja.what_tleft','adeco_obja.what_tright'};

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
        %     SEM_nPlot(Data,para)
        
        para.baseline=[-1500 -500];
        para.precue=[-500 0];
        
        [taveIntp, taveBasep,tavePrecue, indp,realP] = ANOVA_ave_latency_plot_matriax(Data,para);
        
        %         [taveIntp, taveBasep, tavePrecue, onset] = Decoding_ave_latency_plot(Data,para);
        
        aveIntp{j,m}=taveIntp; aveBasep{j,m}=taveBasep; avePrecue{j,m}=tavePrecue; averP{j,m}=realP;
        ttt=ttt+1;
        aaveIntp(:,:,ttt)=taveIntp; aaveBasep(:,:,ttt)=taveBasep; aavePrecue(:,:,ttt)=tavePrecue;
        
        % % %     %%% two-proportions test
        % % %     Ylim=get(gca,'ylim');
        % % %     ylim([Ylim(1) Ylim(2)+.05])
        % % %     for i=1:size(ncho,1)
        % % %         tncho=ncho(i,:);
        % % %         sp1= tMat{j,tncho(1)}; sp2= tMat{j,tncho(2)};
        % % %         X1=sum(sp1.*numTri'); X2=sum(sp2.*numTri');
        % % %         n1=sum(numTri); n2=n1;
        % % %         p1=X1/n1; p2=X2/n2;
        % % %
        % % %         p=(X1+X2)/(n1+n2);
        % % %         q=1-p;
        % % %
        % % %         Z=(p1-p2)./sqrt(2*p.*q/n1); % p2 (posterior) - p1 (anterior)
        % % %         logp=log10(erfc(Z));
        % % %
        % % %         for k=1:length(Bin.cen)
        % % %             if logp(k)<-2
        % % %                 plot(Bin.cen(k),Ylim(2)+.05-i*0.008,'*','color',colors{i},'MarkerSize',6)
        % % %             end
        % % %         end
        % % %     end
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
            
            % % %             %% plot continual * # 5
            % % %             sigP=P < 0.01;
            % % %             [ind,ind1, ~]=continual_n(sigP',nc);
            % % %
            % % %             for k=1:length(Bin.cen)
            % % %                 if ind(k) == 1
            % % %                     plot(Bin.cen(k),Ylim(2)-i*0.008,'*','color',colors{i},'MarkerSize',6)
            % % %                 end
            % % %             end
        end 
        xlim([-500 1500])
    end
end
% aveIntp{3,1}=aaveIntp; aveBasep{3,1}=aaveBasep; avePrecue{3,1}=aavePrecue;