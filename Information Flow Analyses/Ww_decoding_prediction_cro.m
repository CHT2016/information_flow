% Used to decoding-prediction for what&where task.
% predict the other arrays' activity by using the same information.
% within domain prediction
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in September  2019.
%__________________________________________________________________________
% last updated: September 13,2019.
%__________________________________________________________________________

%%% Ramon's files
% w: 20160112; 20160113; 20160121; 20160122
% v: 20160929; 20160930; 20161005; 20161017

close all; clear; clc;
cd('D:\NIH-Research\PFC_8ARRAY\WhatWhere\Analysis\Decoding')

ff={'v20160929_deco','v20160930_deco','v20161005_deco','v20161017_deco',...
    'w20160112_deco','w20160113_deco','w20160121_deco','w20160122_deco'}
for iii=1:8
    filename=ff{iii}
    load(filename)
    
    %% setting parameters
    nbin=10
    period=[-500 1500]; % period
    sbin=(period(1)-Bin.period(1))/Bin.step+1;
    ebin=(period(2)-Bin.period(1))/Bin.step+1;
    bins=sbin:ebin;
    bincen=period(1):Bin.step:period(2);
    
    array=[1,2,3,4,5,6,7,8];
    Bin.period=period; % update Bin information
    Bin.cen=bins;
    Bin.nbin=nbin;
    
    %% dir
    %%% what
    decoM=[deco_dir.what(1,:),deco_dir.what(2,:)];
    [pVar.dir_what,fVar.dir_what,tfVar.dir_what,tpVar.dir_what,yyh.dir_what,fb.dir_what,numPx.dir_what] = Ww_decoding_pred_cro(decoM,nbin,bins,bincen,array);
    
    %%% where
    decoM=[deco_dir.where(1,:),deco_dir.where(2,:)];
    [pVar.dir_where,fVar.dir_where,tfVar.dir_where,tpVar.dir_where,yyh.dir_where,fb.dir_where, numPx.dir_where]  = Ww_decoding_pred_cro(decoM,nbin,bins,bincen,array);
    
    %% obj
    %%% what
    decoM=[deco_obj.what(1,:),deco_obj.what(2,:)];
    [pVar.obj_what,fVar.obj_what,tfVar.obj_what,tpVar.obj_what,yyh.obj_what,fb.obj_what, numPx.obj_what] = Ww_decoding_pred_cro(decoM,nbin,bins,bincen,array);
    
    %%% where
    decoM=[deco_obj.where(1,:),deco_obj.where(2,:)];
    [pVar.obj_where,fVar.obj_where,tfVar.obj_where,tpVar.obj_where,yyh.obj_where,fb.obj_where, numPx.obj_where] = Ww_decoding_pred_cro(decoM,nbin,bins,bincen,array);
    
    save([filename(1:9),'_deco_pred_sTask'],'pVar','fVar','tfVar','tpVar','yyh','fb','numPx','nbin','Bin','period','array')
end
