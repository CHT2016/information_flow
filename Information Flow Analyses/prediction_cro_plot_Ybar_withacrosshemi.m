function prediction_cro_plot_Ybar_withacrosshemi(Y1,Y2,Y3,Y4,para)
cY1=permute(Y1,[2,1,3]);  % Y strcture: [predictor array, response array, sessions]
eY1=eyeY(cY1);

cY2=permute(Y2,[2,1,3]); eY2=eyeY(cY2);
cY3=permute(Y3,[2,1,3]); eY3=eyeY(cY3);
cY4=permute(Y4,[2,1,3]); eY4=eyeY(cY4);


%% high risky!!! combining array by splitting (within vs across) hemispheres %%%%%
for ig=3:4
    eY=eval(['eY' num2str(ig) ';'])
    for iz=1:size(cY1,3)
        for ix=1:4
            for iy=1:4
                ceYwi{ig}(ix,iy,iz)=nanmean([eY(ix,iy,iz),eY(ix+4,iy+4,iz)]);
                ceYbe{ig}(ix,iy,iz)=nanmean([eY(ix,iy+4,iz),eY(ix+4,iy,iz)]);
            end
        end
    end
end


count=0;
for g = 1:size(ceYwi,2)
    ttceYwi=ceYwi{g};
    for i=1:size(ttceYwi,1)
        for j=1:size(ttceYwi,2)
            for k=1:size(ttceYwi,3)
                count=count+1;
                tceYwi(count,1)=ceYwi{g}(i,j,k);
                tceYbe(count,1)=ceYbe{g}(i,j,k);
                outarray(count,1)=i;
                inarray(count,1)=j;
                session(count,1)=k;
                ceYind(count,1)=1;
                
                if g==1
                    domain(count,1)=1;
                    block(count,1)=1;
                elseif g==2
                    domain(count,1)=1;
                    block(count,1)=2;
                elseif g==3
                    domain(count,1)=2;
                    block(count,1)=1;
                elseif g==4
                    domain(count,1)=2;
                    block(count,1)=2;
                end
            end
        end
    end
end

tY=[tceYwi;tceYbe];
outar=[inarray;inarray];
inar=[outarray;outarray];
sessions=[session;session];
domains=[domain;domain];
blocks=[block;block]
wahemi=[ceYind;ceYind+1];% 1:within hemi; 2: across hemi

   Xmat = {inar,outar,wahemi,blocks};
    [p,tbl,stats] = anovan(tY,Xmat,'model','interaction','display','on','varnames',{'inar','outar','wahemi','block'});%,,'model','interaction'
end
