function [p,tbl,stats]=prediction_var_array_anova_task_bar_hemi(Y)
% Used to do n-way anova (hemisphere & ..) for bar plot of prediction of all 8 arrays.
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in November 17, 2019.
% last updated: November 17, 2019.

cY=permute(Y,[2,1,3]);  % cY strcture: [response array, predictor array, sessions]
eY=eyeY(cY);

count=0;
for i=1 : size(Y,1)
    for j=1:size(Y,2)
        for k=1:size(Y,3)
            count=count+1;
            tY(count,1)=Y(i,j,k);
            session(count,1)=k; % 1,what block; 0, where block
            
            if k<5
                monkey(count,1)=0;
            elseif k>4
                monkey(count,1)=1;
            end
                      
            if i < 5
                if j < 5
                    rArray(count,1)=i; %response array
                    pArray(count,1)=j; %predictor array
                    sHemi(count,1)=1; % same hemisphere
                elseif j>4
                    rArray(count,1)=i; %response array
                    pArray(count,1)=j-4; %predictor array
                    sHemi(count,1)=0; % same hemisphere
                end
            elseif i>4
                if j < 5
                    rArray(count,1)=i-4; %response array
                    pArray(count,1)=j; %predictor array
                    sHemi(count,1)=0; % same hemisphere
                elseif j>4
                    rArray(count,1)=i-4; %response array
                    pArray(count,1)=j-4; %predictor array
                    sHemi(count,1)=1; % same hemisphere
                end
            end
        end
    end
end


Xmat = {session,sHemi};%,rArray,pArray};
% nestvar = zeros(max(size(Xmat)),max(size(Xmat)));
% nestvar(3,2) = 1; % al nested to AP

[p,tbl,stats] = anovan(tY,Xmat,'model','interaction','display','on','varnames',{'session','sHemi'});%,'rArray','pArray'
% [p,tbl,stats] = anovan(tY,Xmat,'nested',nestvar,'model','interaction','display','on','varnames',{'task','AP','al','domain'});%,,'model','interaction'


