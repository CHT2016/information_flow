function [p,tbl,stats] = prediction_var_array_anova_task(Y1,Y2)
% Used to do nested n-way anova: 2 tasks, 2 hemispheres
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in July 2019.
% last updated: July 30,2019.

[tY1,hemi1,AP1,al1]=prediction_var_array_anova_task_var(Y1);
[tY2,hemi2,AP2,al2]=prediction_var_array_anova_task_var(Y2);

task=[zeros(length(tY1),1);ones(length(tY2),1)]; % task variance

tY=[tY1;tY2];
hemi=[hemi1;hemi2];
AP=[AP1;AP2];
al=[al1;al2];

Xmat = {hemi,AP,al,task};
nestvar = zeros(max(size(Xmat)),max(size(Xmat)));
nestvar(3,2) = 1; % al nested to AP

[p,tbl,stats] = anovan(tY,Xmat,'nested',nestvar,'varnames',{'hemi','AP','al','task'});%,'display','off');
