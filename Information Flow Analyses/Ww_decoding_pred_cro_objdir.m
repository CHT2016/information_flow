function [pVar, fVar,tfVar,tpVar,yyh,afb, numPx] = Ww_decoding_pred_cro_objdir(decoM,decoMo,nbin,bins,bincen,array)
% Test the corration between two arrays.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: July 25,2019.

%__________________________________________________________________________
% Ww_decoding_pred_cro_objdir.m - Test the corration between two arrays.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: September 25,2019.
%__________________________________________________________________________
% INPUT
% decoM:      decoding matriax of self domain. y: 1 x n (group) Cellarry with elements arrange as trial x bins matrix.
% decoMo:     decoding matriax of the other domain. 
%
% OUTPUT
%
% yyh:     y value of liner model. 1:8 partial model; 9, real y; 10, full model
% deco_mat:  decoding matrix:  1 x bin Cellarry with elements arrange as trial x n matrix.
%__________________________________________________________________________

colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
for sa= array % self array
    tArray=decoM{1, sa};
    [px{sa},py{sa}] = Ww_decoding_pred_array(tArray,nbin,bins); % including t0
    
    tArrayo=decoMo{1, sa};
    [pxo{sa},pyo{sa}] = Ww_decoding_pred_array(tArrayo,nbin,bins); % including t0
    clear tArray tArrayo
end

%% caculate variance
pVar=nan(length(array),length(array));
tpVar=nan(length(array),length(array));
numPx=nan(length(array),length(array));
fVar=nan(1,length(array)); %full Var ?y-y~?
tfVar=nan(1,length(array)); %total Var (y)
afb=nan((nbin+1)*8,8); % up to 8 arraries
for sa= array % self array
    y=py{sa};
    tpx=pxo; tpx{sa}=px{sa}; % self array + 7 other arrarys   
    ylen=length(y); blen=length(bins);
    
    % oct 22, 2020. for test
    tarray = array; tpx{1}(:,1)=[]; tpx{2}(:,1)=[]; tpx{3}(:,1)=[]; tpx{4}(:,1)=[]; tpx{5}(:,1)=[]; tpx{6}(:,1)=[]; tpx{7}(:,1)=[]; tpx{8}(:,1)=[]; % delete t0 in all array
%     tarray = array; tpx{sa}(:,1)=[]; % delete t0 in self array %%% normal option
    %     tarray = setdiff(array,sa); % delete whole  self array
    
    
    %% full arraries, be used to set baseline
    pfX=[ones(ylen,1)];
    for fa = tarray
        pfX=[pfX, tpx{fa}];
    end
    
    %%% regression
    [fb,~,~,~,~]=regress(y,pfX);
    fyh=pfX*fb; % y head
    fVar(sa)=nanvar(y-fyh); % variance
    tfVar(sa)=nanvar(y);
    afb(1:length(fb),sa)=fb;
    %% exclude one arrary
    tl=[]; nn=0;
    
%     figure
%     hold on
    for da = tarray % arrary will be deleted
        nn=nn+1;
        pX=[ones(ylen,1)];
        for pa = setdiff(tarray,da)
            pX=[pX, tpx{pa}];
        end
        
        %%% regression
        [b,~,~,~,~]=regress(y,pX);
        [b,bint,r,rint,stats]=regress(y,pX);
        
        % estimation value
        yh=pX*b; % y head
        myh=nanmean(reshape(yh,[ylen/blen,blen]),1);
%         plot(bincen,myh','color',colors{da},'linewidth',2)
        yyh{sa}(da,:)=myh;
        
        % variance
        pVar(da,sa)=nanvar(y-yh);
        tpVar(da,sa)=nanvar(y);
        tl{nn}=['delete array ' num2str(da)];
    end
    % real posterior probability
    my=nanmean(reshape(y,[ylen/blen,blen]),1);
    mfy=nanmean(reshape(fyh,[ylen/blen,blen]),1);
    yyh{sa}=[yyh{sa};my;mfy];
%     plot(bincen,mfy','--','color',[0 0 0],'linewidth',1)
    
    [yp, ~] = smooth1d(my', (1:length(my))', floor(length(my)/10), 1);
%     plot(bincen,yp,'color',[0.3 0.3 0.3],'linewidth',1)
    

%     set(gca, 'YScale', 'log')
%     title(['posterior probability: real & estimation, array' num2str(sa)])
%     legend([tl,'real value','full array'],'AutoUpdate','off');
%     xlabel('Time from cue','fontsize',12)
%     ylabel('Posterior probability','fontsize',12)
    
    %% plot fb
    %         figure
    %         hold on
    nn=0; ftl=[];
    sttpx=1; % 1 for constant, 1 for start
    for l= tarray
        nn=nn+1;
        ssttpx=size(tpx{l},2);
        % % %         if ssttpx==nbin
        % % %             plot(1:nbin,fb(sttpx+1:sttpx+ssttpx),'color',colors{l},'linewidth',2)
        % % %         elseif ssttpx==nbin+1
        % % %             plot(0:nbin,fb(sttpx+1:sttpx+ssttpx),'color',colors{l},'linewidth',2)
        % % %         end
        sttpx=sttpx+ssttpx;
        ftl{nn}=['array ' num2str(l)];
        numPx(l,sa)=ssttpx;
    end
    %         title(['Full arrary prediction: array' num2str(sa)])
    %         legend(ftl,'AutoUpdate','off');
    %         xlabel('Number of bin before t0','fontsize',12)
    %         ylabel('Average coefficients','fontsize',12)
end
end