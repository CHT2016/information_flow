% Used to do analysis for decoding-prediction of what&where task
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
%__________________________________________________________________________
% last updated: September 13,2019.
%__________________________________________________________________________
% % related scripts:
% % % Ww_decoding_pred_array.m
% % % Ww_decoding_prediction_cro_objdir.m
%__________________________________________________________________________

close all; clear; clc;
% loading filelist
cd('C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding\pred_dTask')

[sourcefilename, pathname] = uigetfile('*.mat', 'multiselect','on');
if isequal(sourcefilename,0)
    error 'No file was selected'
    return
end

cd (pathname)

list=[];
for n=1:length(sourcefilename)
    list{n,1}=sourcefilename{n}(1:end-4);
end

%% loading data
for i=1:length(list)
    load(list{i});
    
    apVar.dir_what(:,:,i)=pVar.dir_what;
    apVar.dir_where(:,:,i)=pVar.dir_where;
    apVar.obj_what(:,:,i)=pVar.obj_what;
    apVar.obj_where(:,:,i)=pVar.obj_where;
    
    atpVar.dir_what(:,:,i)=tpVar.dir_what;
    atpVar.dir_where(:,:,i)=tpVar.dir_where;
    atpVar.obj_what(:,:,i)=tpVar.obj_what;
    atpVar.obj_where(:,:,i)=tpVar.obj_where;
    
    afVar.dir_what(:,:,i)=repmat(fVar.dir_what,8,1);
    afVar.dir_where(:,:,i)=repmat(fVar.dir_where,8,1);
    afVar.obj_what(:,:,i)=repmat(fVar.obj_what,8,1);
    afVar.obj_where(:,:,i)=repmat(fVar.obj_where,8,1);
    
    atfVar.dir_what(:,:,i)=repmat(tfVar.dir_what,8,1);
    atfVar.dir_where(:,:,i)=repmat(tfVar.dir_where,8,1);
    atfVar.obj_what(:,:,i)=repmat(tfVar.obj_what,8,1);
    atfVar.obj_where(:,:,i)=repmat(tfVar.obj_where,8,1);
    
    for j=1:8
        ayyh.dir_what{1,j}(:,:,i)=yyh.dir_what{1,j};
        ayyh.dir_where{1,j}(:,:,i)=yyh.dir_where{1,j};
        ayyh.obj_what{1,j}(:,:,i)=yyh.obj_what{1,j};
        ayyh.obj_where{1,j}(:,:,i)=yyh.obj_where{1,j};
    end
    
    afb.dir_what(:,:,i)=fb.dir_what;
    afb.dir_where(:,:,i)=fb.dir_where;
    afb.obj_what(:,:,i)=fb.obj_what;
    afb.obj_where(:,:,i)=fb.obj_where;
    
    anumPx.dir_what(:,:,i)=numPx.dir_what;
    anumPx.dir_where(:,:,i)=numPx.dir_where;
    anumPx.obj_what(:,:,i)=numPx.obj_what;
    anumPx.obj_where(:,:,i)=numPx.obj_where;
end

%% fVar/tfVar
group={'dir_what','dir_where','obj_what','obj_where'}

for i=1:length(group)
    ttfVar=['fVar.', group{i}]; ttafVar=['afVar.', group{i}];
    eval([ttfVar '=squeeze(' ttafVar,'(1,:,:));'])%(array x session)
    
    tttfVar=['tfVar.', group{i}]; ttatfVar=['atfVar.', group{i}];
    eval([tttfVar '=squeeze(' ttatfVar,'(1,:,:));'])%(array x session)
    
%     eval(['Y=' ttfVar './' tttfVar ';'])
     eval(['Y='  tttfVar ';'])
    %     eval(['Y=' ttfVar ';'])
    meanVar(i,:)=mean(Y,1);
end

para.ylabel='fVar / tfVar';
para.title=['What & Where'];
% para.ylim=[0 1];
para.group=group;

figure
barplot_group_2D(meanVar',para)

%% dVar
para.legend={'array1','array2','array3','array4','array5','array6','array7','array8'};
para.group={'array1','array2','array3','array4','array5','array6','array7','array8'};

colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};

%% dir_what
para.title='adVar.dir_what'
Y=(apVar.dir_what-afVar.dir_what)./afVar.dir_what;
para.ylabel='\Delta Var / fVar';

nY=delSelfpVar(Y);

% Y=apVar.dir_what-afVar.dir_what;
% para.ylabel='\Delta Var';

% Y= apVar.dir_what./atpVar.dir_what - afVar.dir_what./atfVar.dir_what;
% epara.ylabel='dR^2: pVar/tpVar - fVar/tfVar';

%%% bar plot
para.ylim=[0 .002]
para.gType='aHemi'
prediction_cro_plot_Ybar(Y,para)

% % para.gType='sHemi'
% % prediction_cro_plot_Ybar(Y,para)

%%% nANOVA: barplot
[p,tbl,stats] = prediction_var_array_anova_task_bar_hemi(Y);

%%% sorted by array distance
aGroup=[1,2,3,4;5,6,7,8];
[shVar1,ohVar1]=prediction_var_array(Y,aGroup);

epara.xlabel='anterior to posterior / posterior to anterior';
epara.legend={'same hemisphere','opposite hemisphere'};
epara.title=['adVar.dir_what']

x=-3:3;
gY1=[shVar1(1,3),shVar1(1,2),shVar1(1,1),nan,shVar1(2,:);...
    ohVar1(1,3),ohVar1(1,2),ohVar1(1,1),ohVar1(3,1),ohVar1(2,:)]

epara.bins=x;
epara.cells=true;
epara.colors=colors;
epara.SEM='errorbar';
LINE_nPlot(gY1,epara)

%% dir_where
para.title='adVar.dir_where'
Y=(apVar.dir_where-afVar.dir_where)./afVar.dir_where;
% Y= apVar.dir_where./atpVar.dir_where - afVar.dir_where./atfVar.dir_where;
% Y=afVar.dir_where;

%%% bar plot
para.gType='aHemi'
prediction_cro_plot_Ybar(Y,para)

% % para.gType='sHemi'
% % prediction_cro_plot_Ybar(Y,para)

%%% nANOVA: barplot
[p,tbl,stats] = prediction_var_array_anova_task_bar_hemi(Y);

%%% sorted by array distance
[shVar2,ohVar2]=prediction_var_array(Y,aGroup);
epara.title=['adVar.dir_where']

x=-3:3;
gY2=[shVar2(1,3),shVar2(1,2),shVar2(1,1),nan,shVar2(2,:);...
    ohVar2(1,3),ohVar2(1,2),ohVar2(1,1),ohVar2(3,1),ohVar2(2,:)]
LINE_nPlot(gY2,epara)

%% nested n-way anova
Y1=[shVar1(1,3),shVar1(1,2),shVar1(1,1),shVar1(2,:); ohVar1(1,3),ohVar1(1,2),ohVar1(1,1),ohVar1(2,:)];
Y2=[shVar2(1,3),shVar2(1,2),shVar2(1,1),shVar2(2,:); ohVar2(1,3),ohVar2(1,2),ohVar2(1,1),ohVar2(2,:)];
prediction_var_array_anova_task(Y1,Y2)

%% hemispheres combined
% x=[-3:-1,1:3];
x=[-3:2];
tk=[1:3,5:7];
for k=1:6 % exclude the arrry of same order on the other hemisphere
    gY{1,k}=[gY1{1,tk(k)};gY1{2,tk(k)}];
    gY{2,k}=[gY2{1,tk(k)};gY2{2,tk(k)}];
end

% for k=1:6 % exclude the arrry of same order on the other hemisphere
%     gY{1,k}=mean([gY1{1,tk(k)},gY1{2,tk(k)}],2);
%     gY{2,k}=mean([gY2{1,tk(k)},gY2{2,tk(k)}],2);
% end

epara.title  = 'Predict direction with object';
epara.legend = {'what block','where block'};
epara.bins=x;
para.stat='true';
LINE_nPlot(gY,epara)


% % % % ttest: nearby vs. remote array
ttVar1=[gY{1, 3};gY{1, 4};gY{2, 3};gY{2, 4}];
ttVar23=[gY{1, 1};gY{1, 2};gY{1, 5};gY{1, 6};gY{2, 1};gY{2, 2};gY{2, 5};gY{2, 6}];
[h,p,ci,stats] = ttest2(ttVar1,ttVar23);
%

% ttest: rostral-caudal vs. caudal-rostral
ttVar_cr=[gY{1, 4};gY{1, 5};gY{1, 6};gY{2, 4};gY{2, 5};gY{2, 6}];
ttVar_rc=[gY{1, 1};gY{1, 2};gY{1, 3};gY{2, 1};gY{2, 2};gY{2, 3}];
[h,p,ci,stats] = ttest2(ttVar_cr,ttVar_rc);
%

[p,tbl,stats] = prediction_var_array_anova_task_chemi(gY)

%% obj_what
para.title='adVar.obj_what'
Y=(apVar.obj_what-afVar.obj_what)./afVar.obj_what;
% Y= apVar.obj_what./atpVar.obj_what - afVar.obj_what./atfVar.obj_what;

%%% bar plot
para.gType='aHemi'
prediction_cro_plot_Ybar(Y,para)

% para.gType='sHemi'
% prediction_cro_plot_Ybar(Y,para)

%%% nANOVA: barplot
[p,tbl,stats] = prediction_var_array_anova_task_bar_hemi(Y);

%%% sorted by array distance
aGroup=[1,2,3,4;5,6,7,8];
[shVar1,ohVar1]=prediction_var_array(Y,aGroup);
epara.title=['adVar.obj_what']

x=-3:3;
gY1=[shVar1(1,3),shVar1(1,2),shVar1(1,1),nan,shVar1(2,:);...
    ohVar1(1,3),ohVar1(1,2),ohVar1(1,1),ohVar1(3,1),ohVar1(2,:)]
% line_nPlot_cell(x,gY1,epara)

epara.bins=x;
LINE_nPlot(gY1,epara)

%% obj_where
para.title='adVar.obj_where'
Y=(apVar.obj_where-afVar.obj_where)./afVar.obj_where;
% Y= apVar.obj_where./atpVar.obj_where - afVar.obj_where./atfVar.obj_where;

%%% bar plot
para.gType='aHemi'
prediction_cro_plot_Ybar(Y,para)
% 
% para.gType='sHemi'
% prediction_cro_plot_Ybar(Y,para)

%%% nANOVA: barplot
[p,tbl,stats] = prediction_var_array_anova_task_bar_hemi(Y);


%%% sorted by array distance
aGroup=[1,2,3,4;5,6,7,8];
[shVar2,ohVar2]=prediction_var_array(Y,aGroup);
epara.title=['adVar.obj_where']

x=-3:3;
gY2=[shVar2(1,3),shVar2(1,2),shVar2(1,1),nan,shVar2(2,:);...
    ohVar2(1,3),ohVar2(1,2),ohVar2(1,1),ohVar2(3,1),ohVar2(2,:)]
epara.bins=x;
LINE_nPlot(gY2,epara)

%% nested n-way anova
Y1=[shVar1(1,3),shVar1(1,2),shVar1(1,1),shVar1(2,:); ohVar1(1,3),ohVar1(1,2),ohVar1(1,1),ohVar1(2,:)];
Y2=[shVar2(1,3),shVar2(1,2),shVar2(1,1),shVar2(2,:); ohVar2(1,3),ohVar2(1,2),ohVar2(1,1),ohVar2(2,:)];
prediction_var_array_anova_task(Y1,Y2)

%% hemispheres combined
% x=[-3:-1,1:3];
x=[-3:2];
tk=[1:3,5:7];
for k=1:6 % exclude the arrry of same order on the other hemisphere
    gY{1,k}=[gY1{1,tk(k)};gY1{2,tk(k)}];
    gY{2,k}=[gY2{1,tk(k)};gY2{2,tk(k)}];
end
epara.title  = 'Predict object with direction';
epara.legend = {'what block','where block'};
epara.bins=x;
LINE_nPlot(gY,epara)

[p,tbl,stats]=prediction_var_array_anova_task_chemi(gY)

%% y-yh: average across session
aGroup=[1,2,3,4;5,6,7,8];
ty=ayyh.dir_what;
[shdy1,ohdy1]=prediction_var_array_yyh(ty,aGroup)
ty=ayyh.dir_where;
[shdy2,ohdy2]=prediction_var_array_yyh(ty,aGroup)

dy1=[shdy1(1,3),shdy1(1,2),shdy1(1,1),shdy1(2,:); ohdy1(1,3),ohdy1(1,2),ohdy1(1,1),ohdy1(2,:)];
dy2=[shdy2(1,3),shdy2(1,2),shdy2(1,1),shdy2(2,:); ohdy2(1,3),ohdy2(1,2),ohdy2(1,1),ohdy2(2,:)];

llenge={'-3','-2','-1','1','2','3'}
bins=-500:20:1500;

figure
hold on
for i=1:size(dy1,2)
    %     plot(bins, mean([dy1{1,i};dy1{2,i}])-mean([dy2{1,i};dy2{2,i}]),'color',colors{i},'linewidth',2);%para.LineStyle{m}
    plot(bins, mean([dy2{1,i};dy2{2,i}]),'color',colors{i},'linewidth',2);%para.LineStyle{m}
end
legend(llenge)
xlabel('Time from cue (ms)','fontsize',12)
ylabel('dy','fontsize',12)
title(strrep('dir_what - dir_where','_','\_'))

% ylim([-0.0004 0.0008])
title(strrep('dir_where','_','\_'))

%%% y-yh:2
ty=ayyh.obj_what;
[shdy1,ohdy1]=prediction_var_array_yyh(ty,aGroup)
ty=ayyh.obj_where;
[shdy2,ohdy2]=prediction_var_array_yyh(ty,aGroup)

dy1=[shdy1(1,3),shdy1(1,2),shdy1(1,1),shdy1(2,:); ohdy1(1,3),ohdy1(1,2),ohdy1(1,1),ohdy1(2,:)];
dy2=[shdy2(1,3),shdy2(1,2),shdy2(1,1),shdy2(2,:); ohdy2(1,3),ohdy2(1,2),ohdy2(1,1),ohdy2(2,:)];

colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
llenge={'-3','-2','-1','1','2','3'}
bins=-500:20:1500;

figure
hold on
for i=1:size(dy2,2)
    plot(bins, mean([dy1{1,i};dy1{2,i}])-mean([dy2{1,i};dy2{2,i}]),'color',colors{i},'linewidth',2);%para.LineStyle{m}
    %     plot(bins, mean([dy1{1,i};dy1{2,i}]),'color',colors{i},'linewidth',2);%para.LineStyle{m}
end
legend(llenge)
xlabel('Time from cue (ms)','fontsize',12)
ylabel('dy','fontsize',12)
title(strrep('obj_what-obj_where','_','\_'))
% title(strrep('obj_what','_','\_'))


%% fb
%%% dir
tPx=anumPx.dir_where;
tfb=afb.dir_where;

for l=1:size(tPx,2)
    ttPx=squeeze(tPx(:,l,:));
    ttfb=squeeze(tfb(:,l,:));
    for n=1:size(ttPx,2)
        fsize=1;tsize=0;
        for m=1:size(ttPx,1)
            tsize= ttPx(m,n)
            if tsize==11
                tl=fsize+1:fsize+tsize;
                tttfb{l,m}(n,:)=ttfb(tl,n)';
                fsize=fsize+tsize;
            elseif tsize==10
                tl=fsize+1:fsize+tsize;
                tttfb{l,m}(n,:)=[nan,ttfb(tl,n)'];
                fsize=fsize+tsize;
            elseif isnan(tsize)
                tttfb{l,m}(n,:)=nan(11,1)';
            end
        end
    end
end


%%% plot single array
for i=1:size(tttfb,1)
    ttt=tttfb(i,:);
    
    para.binstep=1; % bin step of data
    para.xlim=[0 10]; %time zone
    para.ylim=[-0.01 .05];
    para.saxis=[1 0.01]; %%step of axis
    para.colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
    para.xlabel='Number of bin before t0';
    para.ylabel='Average coefficients';
    para.legend={'array1','array2','array3','array4','array5','array6','array7','array8'};
    para.title=['array' num2str(i)]
    
    LINE_nPlot(ttt,para)
end

%%% sorted by array distance
aGroup=[1,2,3,4;5,6,7,8];

[shVar,ohVar]=prediction_fb_array(tttfb,aGroup);
shY=[shVar(1,3),shVar(1,2),shVar(1,1),shVar(2,:)];
ohY=[ohVar(1,3),ohVar(1,2),ohVar(1,1),ohVar(2,:)];

para.ylim=[-0.005 .005];
para.legend={'-3','-2','-1','+1','+2','+3'};
para.title=['same hemisphere'];
LINE_nPlot(shY,para)

para.title=['opposite hemisphere'];
LINE_nPlot(ohY,para)
