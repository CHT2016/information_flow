function [p,tbl,stats]=prediction_var_array_anova_task_chemi(Y)
% Used to do nested n-way anova: 2 tasks, 2 hemispheres
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: July 30,2019.

[tY,task,AP,al]=prediction_var_array_anova_task_chemi_var(Y);

Xmat = {task,AP,al};
nestvar = zeros(max(size(Xmat)),max(size(Xmat)));
nestvar(3,2) = 1; % al nested to AP

[p,tbl,stats] = anovan(tY,Xmat,'nested',nestvar,'display','off','varnames',{'task','AP','al'});%,,'model','interaction'
% [p,tbl,stats] = anovan(tY,Xmat,'nested',nestvar,'model','interaction','display','on','varnames',{'task','AP','al','domain'});%,,'model','interaction'


