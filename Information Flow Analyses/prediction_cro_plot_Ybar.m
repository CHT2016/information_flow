function [ceY]=prediction_cro_plot_Ybar(Y,para)
% prediction_cro_plot_Ybar.m - Plot the relationship between each arrays for
% decoding-prediction of what&where task.
% WriyMaten by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in September 2019.
% last updated: September 18,2019.
%__________________________________________________________________________
% INPUT
% Y:        arrary x arrary x subjects (8x8x8)matrix.
%
% OUTPUT
% Y :     normal bars with all 8 arrarys
% eY :    normal bars with all 8 arrarys, but exclude self arrary
% ceY :   combined bars across two hemispheres (4x4x8), and exclude self arrary
%__________________________________________________________________________

cY=permute(Y,[2,1,3]);  % Y strcture: [predictor array, response array, sessions]
eY=eyeY(cY);

% para.ylim=([0 .003])
%% high risky!!! combining array all (within & across) hemispheres %%%%%
for iz=1:size(cY,3)
    for ix=1:4
        for iy=1:4
            ceY(ix,iy,iz)=nanmean([eY(ix,iy,iz),eY(ix,iy+4,iz),eY(ix+4,iy,iz),eY(ix+4,iy+4,iz)]);
        end
    end
end

%% high risky!!! combining array by splitting (within vs across) hemispheres %%%%%
for iz=1:size(cY,3)
    for ix=1:4
        for iy=1:4
            ceYwi(ix,iy,iz)=nanmean([eY(ix,iy,iz),eY(ix+4,iy+4,iz)]);
            ceYbe(ix,iy,iz)=nanmean([eY(ix,iy+4,iz),eY(ix+4,iy,iz)]);
        end
    end
end

figure
if para.gType == 'aHemi' % all hemi
    barplot_group_3D(ceY,para)
    
    % %
    % % rM = [squeeze(ceY(1,1,:)); squeeze(ceY(1,2,:));squeeze(ceY(2,1,:));squeeze(ceY(2,2,:))]; %rostral interaction
    % % cM = [squeeze(ceY(3,3,:)); squeeze(ceY(3,4,:));squeeze(ceY(4,3,:));squeeze(ceY(4,4,:))]; %caudal interaction
    % % [h,p,ci,stats] = ttest(rM,cM)
elseif para.gType == 'sHemi' % split hemi
    otitle=para.title;
    para.title=[otitle,'_within_hemispheres'];
    barplot_group_3D(ceYwi,para);
    
    figure
    para.title=[otitle,'_across_hemispheres'];
    barplot_group_3D(ceYbe,para);
    
    %%
    count=0;
    for i=1:size(ceYwi,1)
        for j=1:size(ceYwi,2)
            for k=1:size(ceYwi,3)
                count=count+1;
                tceYwi(count,1)=ceYwi(i,j,k);
                tceYbe(count,1)=ceYbe(i,j,k);
                outarray(count,1)=i;
                inarray(count,1)=j;
                session(count,1)=k;
                ceYind(count,1)=1;
            end
        end
    end
    
    tY=[tceYwi;tceYbe];
    outar=[inarray;inarray];
    inar=[outarray;outarray];
    sessions=[session;session];
    wahemi=[ceYind;ceYind+1];% 1:within hemi; 2: across hemi

    Xmat = {inar,outar,wahemi};
    [p,tbl,stats] = anovan(tY,Xmat,'model','interaction','display','on','varnames',{'inar','outar','wahemi'});%,,'model','interaction'
    
end
end