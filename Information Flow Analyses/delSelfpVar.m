function nY=delSelfpVar(Y)
for i=1:size(Y,1)
    for k=1:size(Y,3)
        pp=[];
        for j=1:size(Y,2)
            pp=[pp,Y(i,j,k)];
        end
        sump=sum(pp);        
        for j=1:size(Y,2)
            nY(i,j,k)=Y(i,j,k)/(sump-Y(i,i,k));
        end
    end
end