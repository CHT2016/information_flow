function [tY,hemi,AP,al]=prediction_var_array_anova_task_var(Y)
% Used to extract variance
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: July 30,2019.

count=0;
for i=1 : size(Y,1)
    for j=1:size(Y,2)      
        for k=1:length(Y{i,j})
            count=count+1;
            tY(count,1)=Y{i,j}(k);
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
