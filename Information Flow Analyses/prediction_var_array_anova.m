function prediction_var_array_anova(shVar,ohVar)


shVar=[shVar(1,3),shVar(1,2),shVar(1,1),shVar(2,:);...
    ohVar(1,3),ohVar(1,2),ohVar(1,1),ohVar(2,:)]

count=0
for i=1 : size(shVar,1)
    for j=1:size(shVar,2)
        
        for k=1:length(shVar{i,j})
            count=count+1;
            tY(count,1)=shVar{i,j}(k);
            hemi(count,1)=abs(i-2); % 1,same hemisphere; 0, opposite hemisphere
            
            if j<4
                al(count,1)=j-4; % array location
                AP(count,1)=0; % 1: posterior to anterior; 0, anterior to posterior
            elseif j>3
                al(count,1)=j-3;
                AP(count,1)=1;
            end
        end
    end
end


Xmat = {hemi,AP,al};
nestvar = zeros(max(size(Xmat)),max(size(Xmat)));
nestvar(3,2) = 1; % al nested to AP

[p,tbl,stats] = anovan(tY,Xmat,'nested',nestvar,'varnames',{'hemi','AP','al'});%,'display','off');
 
 