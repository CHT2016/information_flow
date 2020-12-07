function [fp, fps, fpa, nIndex] = Ww_nAnova_fp(Array,sP,tit)
% This function is used to calculate the fraction of p-value < 0.05
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH on July 5, 2019.

for i=1:size(Array,1)
    for j=1:size(Array,2)
        for m=1:size(tit,2)
            nP=['sP.sig',tit{m}];
            eval(['mP = ' nP ';'])
            mP=mP';
            fp{i,j}(m,:)=sum(mP(Array{i,j},:)<0.05)./sum(~isnan(mP(Array{i,j},:)));
            fps{i,j}(m,:)=sum(mP(Array{i,j},:)<0.05);
            fpa{i,j}(m,:)=sum(~isnan(mP(Array{i,j},:)));
            
            %% overlap rate
            if m==1
                nIndex.dir{i,j}= mP(Array{i,j},:)<0.05;
            elseif m==2
                nIndex.obj{i,j}= mP(Array{i,j},:)<0.05;
            end
        end
    end
end