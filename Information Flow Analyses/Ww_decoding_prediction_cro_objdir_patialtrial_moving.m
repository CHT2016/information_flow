% Used to analysis anterior-posterior, array location & task effects with
% n-way ANOVA for decoding-prediction of what&where task.
% using moving windows, and analysis by using all sessions.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in September 2019.
%__________________________________________________________________________

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

close all; clear; clc;
cd('C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding')

% ff={'v20160929_deco','v20160930_deco','v20161005_deco','v20161017_deco'}

ff={'v20160929_deco','v20160930_deco','v20161005_deco','v20161017_deco',...
    'w20160112_deco','w20160113_deco','w20160121_deco','w20160122_deco'}

nbin=10
period=[-500 1500]; % period
array=[1,2,3,4,5,6,7,8];
windows=10;

for ii=[1:80-windows+1]
    ii
    for i=1:length(ff)
        filename=ff{i};
        load(filename,'Bin','beh','deco_dir','deco_obj')
        
        %% setting parameters
        sbin=(period(1)-Bin.period(1))/Bin.step+1;
        ebin=(period(2)-Bin.period(1))/Bin.step+1;
        bins=sbin:ebin;
        bincen=period(1):Bin.step:period(2);
        
        %% % select partial trials
        block_switch=[-1; diff(beh.reversal)];%-1:start of block; 1:switch
        sblock=find(block_switch==-1);
        sreversal=find(block_switch==1);
        
        ttrials=[];
        for iii=1:length(sblock)
            ttrials=[ttrials, sblock(iii)+ii-1:sblock(iii)+ii-2+windows;]; %% 1:10
        end
        
        %% stask
        
        % % %         %% dir
        % % %         %%% what
        % % %         pdecoM=[deco_dir.what(1,:),deco_dir.what(2,:)];
        % % %         [decoM]=Ww_deco_predi_cro_sdomain_ptrial_ind(pdecoM,ttrials);
        % % %         [pVar.dir_what,fVar.dir_what,tfVar.dir_what,tpVar.dir_what,~,~,~] = Ww_decoding_pred_cro(pdecoM,nbin,bins,bincen,array);
        % % %
        % % %         %%% where
        % % %         pdecoM=[deco_dir.where(1,:),deco_dir.where(2,:)];
        % % %         [decoM]= Ww_deco_predi_cro_sdomain_ptrial_ind(pdecoM,ttrials);
        % % %         [pVar.dir_where,fVar.dir_where,tfVar.dir_where,tpVar.dir_where,~,~,~]  = Ww_decoding_pred_cro(pdecoM,nbin,bins,bincen,array);
        % % %
        % % % %         %% obj
        % % % %         %%% what
        % % % %         pdecoM=[deco_obj.what(1,:),deco_obj.what(2,:)];
        % % % %         [decoM]= Ww_deco_predi_cro_sdomain_ptrial_ind(pdecoM,ttrials);
        % % % %         [pVar.obj_what,fVar.obj_what,tfVar.obj_what,tpVar.obj_what,~,~,~] = Ww_decoding_pred_cro(decoM,nbin,bins,bincen,array);
        % % % %
        % % % %         %%% where
        % % % %         pdecoM=[deco_obj.where(1,:),deco_obj.where(2,:)];
        % % % %         [decoM]= Ww_deco_predi_cro_sdomain_ptrial_ind(pdecoM,ttrials);
        % % % %         [pVar.obj_where,fVar.obj_where,tfVar.obj_where,tpVar.obj_where,~,~,~] = Ww_decoding_pred_cro(decoM,nbin,bins,bincen,array);
        % % % %
        
        %% dtask
        % obj to dir
        
                %%% what
                pdecoM=[deco_dir.what(1,:),deco_dir.what(2,:)];
                pdecoMo=[deco_obj.what(1,:),deco_obj.what(2,:)];
        
                [decoM,decoMo]= Ww_deco_predi_cro_objdir_ptrial_ind(pdecoM,pdecoMo,ttrials);
                [pVar.dir_what,fVar.dir_what,tfVar.dir_what,tpVar.dir_what,~,~, ~] = Ww_decoding_pred_cro_objdir(decoM,decoMo,nbin,bins,bincen,array);
        
                %%% where
                pdecoM=[deco_dir.where(1,:),deco_dir.where(2,:)];
                pdecoMo=[deco_obj.where(1,:),deco_obj.where(2,:)];
        
                [decoM,decoMo]= Ww_deco_predi_cro_objdir_ptrial_ind(pdecoM,pdecoMo,ttrials);
                [pVar.dir_where,fVar.dir_where,tfVar.dir_where,tpVar.dir_where,~,~, ~] = Ww_decoding_pred_cro_objdir(decoM,decoMo,nbin,bins,bincen,array);
        
% % %         % dir to obj
% % %         %%% what
% % %         pdecoM=[deco_obj.what(1,:),deco_obj.what(2,:)];
% % %         pdecoMo=[deco_dir.what(1,:),deco_dir.what(2,:)];
% % %         
% % %         [decoM,decoMo]= Ww_deco_predi_cro_objdir_ptrial_ind(pdecoM,pdecoMo,ttrials);
% % %         [pVar.obj_what,fVar.obj_what,tfVar.obj_what,tpVar.obj_what,~,~, ~] =  Ww_decoding_pred_cro_objdir(decoM,decoMo,nbin,bins,bincen,array);
% % %         
% % %         %%% where
% % %         pdecoM=[deco_obj.where(1,:),deco_obj.where(2,:)];
% % %         pdecoMo=[deco_dir.where(1,:),deco_dir.where(2,:)];
% % %         
% % %         [decoM,decoMo]= Ww_deco_predi_cro_objdir_ptrial_ind(pdecoM,pdecoMo,ttrials);
% % %         [pVar.obj_where,fVar.obj_where,tfVar.obj_where,tpVar.obj_where,~,~, ~] =  Ww_decoding_pred_cro_objdir(decoM,decoMo,nbin,bins,bincen,array);
% % %         
        %%
                apVar.dir_what(:,:,i)=pVar.dir_what;
                apVar.dir_where(:,:,i)=pVar.dir_where;
                atpVar.dir_what(:,:,i)=tpVar.dir_what;
                atpVar.dir_where(:,:,i)=tpVar.dir_where;
        
                afVar.dir_what(:,:,i)=repmat(fVar.dir_what,8,1);
                afVar.dir_where(:,:,i)=repmat(fVar.dir_where,8,1);
                atfVar.dir_what(:,:,i)=repmat(tfVar.dir_what,8,1);
                atfVar.dir_where(:,:,i)=repmat(tfVar.dir_where,8,1);
        
%         apVar.obj_what(:,:,i)=pVar.obj_what;
%         apVar.obj_where(:,:,i)=pVar.obj_where;
%         atpVar.obj_what(:,:,i)=tpVar.obj_what;
%         atpVar.obj_where(:,:,i)=tpVar.obj_where;
%         
%         afVar.obj_what(:,:,i)=repmat(fVar.obj_what,8,1);
%         afVar.obj_where(:,:,i)=repmat(fVar.obj_where,8,1);
%         atfVar.obj_what(:,:,i)=repmat(tfVar.obj_what,8,1);
%         atfVar.obj_where(:,:,i)=repmat(tfVar.obj_where,8,1);
    end
    
    %% normalize Var
        Y1=(apVar.dir_what-afVar.dir_what)./afVar.dir_what;
%     Y1=(apVar.obj_what-afVar.obj_what)./afVar.obj_what;
        Y2=(apVar.dir_where-afVar.dir_where)./afVar.dir_where;
%     Y2=(apVar.obj_where-afVar.obj_where)./afVar.obj_where;
    
    %% ANOVA, hemispheres combined: dorsal-ventral information flow
    dor2ven.what=squeeze([Y1(3,4,:); Y1(7,8,:);Y1(3,8,:); Y1(7,4,:);]);
    ven2dor.what=squeeze([Y1(4,3,:); Y1(8,7,:);Y1(8,3,:); Y1(4,7,:);]);
    dor2ven.where=squeeze([Y2(3,4,:); Y2(7,8,:);Y2(3,8,:); Y2(7,4,:);]);
    ven2dor.where=squeeze([Y2(4,3,:); Y2(8,7,:);Y2(8,3,:); Y2(4,7,:);]);
    
    
    %% information flow, within conditions
    Y = [mean(dor2ven.what);mean(dor2ven.where);mean(ven2dor.what);mean(ven2dor.where)]';
    block=[]; prediction=[]; session=[];
    count=0;
    for i=1 : size(Y,1)
        for j=1:size(Y,2)
            count=count+1;
            tY_dir_ic(count,1)=Y(i,j);
            session(count,1)=i;
            
            if j==1 | j==3
                block(count,1)=1;% what blocks
            elseif j==2 | j==4
                block(count,1)=0% where blocks
            end
            
            if j <3
                prediction(count,1)=1; % 4 TO 3
            elseif j >2
                prediction(count,1)=0; % 3 TO 4
            end
        end
    end
    
    Xmat = {prediction,block};%,rArray,pArray};
    [~,vendor_tbl{ii},~] = anovan(tY_dir_ic,Xmat,'model','interaction','display','off','varnames',{'prediction','block'});%,'rArray','pArray'
    
    nVar(ii).dir_what=Y1;
    nVar(ii).dir_where=Y2;
    
    %% ANOVA, hemispheres combined: task, location & flow direction
    aGroup=[1,2,3,4;5,6,7,8];
    [shVar1,ohVar1]=prediction_var_array(Y1,aGroup);
    [shVar2,ohVar2]=prediction_var_array(Y2,aGroup);
    
    gY1=[shVar1(1,3),shVar1(1,2),shVar1(1,1),nan,shVar1(2,:);ohVar1(1,3),ohVar1(1,2),ohVar1(1,1),ohVar1(3,1),ohVar1(2,:)];
    gY2=[shVar2(1,3),shVar2(1,2),shVar2(1,1),nan,shVar2(2,:);ohVar2(1,3),ohVar2(1,2),ohVar2(1,1),ohVar2(3,1),ohVar2(2,:)];
    
    x=[-3:-1,1:3];
    % x=[-3:2];
    tk=[1:3,5:7];
    for k=1:6 % exclude the arrry of same order on the other hemisphere
        gY{1,k}=[gY1{1,tk(k)};gY1{2,tk(k)}];
        gY{2,k}=[gY2{1,tk(k)};gY2{2,tk(k)}];
    end
    epara.title  = 'Predict object with direction'; % 'Predict direction with object';
    epara.legend = {'what block','where block'};
    line_nPlot_cell(x,gY,epara)
    
    [p,tbl,~] = prediction_var_array_anova_task_chemi(gY); % model: no interaction!! ,'display','off'
    
    GY{ii}=gY;
    pvalue(:,ii)=p; % 'task','AP','al(AP)'
    fvalue(:,ii)= [tbl{2, 6};tbl{3, 6};tbl{4, 6}];
end

save(['pred_sTask_-500_1500_moving_pValue_10bins_obj2dir_new'],'nVar','vendor_tbl','GY','period','nbin','windows','pvalue','fvalue')

%% plot %% loding files
colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
x=6:76;

figure
hold on
for i=[1, 3]
    plot(x, pvalue(i,:),'linewidth',2,'color',colors{i})
end
line([0 80],[0.05 0.05],'color',[0.5 0.5 0.5])

% yyaxis left
% plot(x,-log10(pvalue(1,:)),'-','linewidth',2,'color',colors{1})
% plot(x,-log10(pvalue(3,:)),'linewidth',2,'color',colors{2})
% line([0 80],[-log10(0.05) -log10(0.05)],'color',[0.5 0.5 0.5])

% yyaxis right
% plot(pvalue(2,:),'linewidth',2,'color',colors{2})
% plot(x,-log10(pvalue(2,:)),'linewidth',2,'color',colors{3})
% ylim([5 15])

xlabel('Trial number','fontsize',12)
ylabel('p-value','fontsize',12)
legend('task','al(AP)')
title(strrep('bins: 10, step: 1','_','\_'))

%% p-value of ventral
for m=1:length(vendor_tbl)
    vendor_p(m)=vendor_tbl{1, m}{2,7};
end
x=6:76;

figure
plot(x,vendor_p)
hold on
line([0 80],[0.05 0.05],'color',[0.5 0.5 0.5])

xlabel('Trial number','fontsize',12)
ylabel('p-value','fontsize',12)
legend('ventral - dorsal direction')
title(strrep('dir2obj: 10 bins, 1 step','_','\_'))
