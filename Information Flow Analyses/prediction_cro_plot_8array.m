function prediction_cro_plot_8array(Bin,yMat,aID)
% prediction_cro_plot_8array.m - Plot y & yh for decoding-prediction of what&where task.
% WriyMaten by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH in September 2019.
% last updated: September 17,2019.
%__________________________________________________________________________
% INPUT
% Bin:      Bin information.
% yMat:     10 x bins matrix. 
% % % yyh:  y value of liner model. 1:8 partial model; 9, real y; 10, full model
% aID:      arary ID.
%
% OUTPUT
%
%__________________________________________________________________________

dx=0.001;
bincen2=Bin.period(1):dx*Bin.step:Bin.period(2);
colors={'r','g','b',[0.6 .6 0],'c','m','y',[0.6 0 0.6]};
tl=[];

figure
hold on
for i=1:8
    plot(Bin.cen,yMat(10,:)-yMat(i,:),'color',colors{i},'linewidth',2) 
%     plot(Bin.cen,yMat(i,:),'color',colors{i},'linewidth',2)
    tl{i}=['d\_' num2str(i)];
end


% [yp, ~] = smooth1d(yMat(9,:)', (1:length(yMat(9,:)))', floor(length(yMat(9,:))/10), dx); % real posterior probability
% plot(bincen2,yp,'color',[0.3 0.3 0.3],'linewidth',1)
% plot(Bin.cen,yMat(10,:),'--','color',[0 0 0],'linewidth',1)

title(['posterior probability: real & prediction, array', num2str(aID)])
legend([tl,'real value','full array'],'AutoUpdate','off');
xlabel('Time from cue','fontsize',12)
ylabel('Posterior probability','fontsize',12)
end