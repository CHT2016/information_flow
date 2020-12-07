% used to  filter (global) 60 Hz noise in LFP data
%%% for multi-electrode recording
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH.
% last update: May 29, 2020. Hua

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% strategy
% % % Bandpass filter each electrode (rs_i) at 60 Hz
% % % Bandpass you can do with filtfilt function in matlab.
% % % Bp60_i
% % % Compute average of the 60 Hz signal, from all electrodes
% % % aBp60 = average(Bp60_i)
% % % aBp60 = aBp60/norm(aBp60);
% % % a_i = rs_i'*aBp60;
% % % filtered_i = rs_i – a_i.*aBp60;
% LFP_trial: 1 x n electrodes cell array, with elements arrange as samples x trials matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fs=1000;
fpass=[55 65]

filtered=[]
for i=1:100%size(LFP_trial{1},1)
    i
    Bp60=[];
    for j=1:length(LFP_trial)
        x=LFP_trial{1,j}(i,:)';
        Bp60(:,j)=bandpass(x,fpass,fs);
    end
    aBp60=mean(Bp60,2);
    aBp60 = aBp60/norm(aBp60);
    
    for j=1:length(LFP_trial)
        rs_i=LFP_trial{1,j}(i,:);
        a_i = rs_i*aBp60;
        filtered{1,j}(:,i) = rs_i' - a_i.*aBp60;
    end
end

data=filtered{1, 3}; % data from channel 1
% data2=filtered{1, 23}; % data from channel 1
%% spectrum
params=[];
params.trialave=1; % average over trials
params.Fs=1000;
[S,f]=mtspectrumc(data,params);

figure
plot_vector(S,f);
xlim([0 100])

no60LFP=rmlinesc(data,params,[],[],60);
[S,f]=mtspectrumc(no60LFP,params);
hold on
plot_vector(S,f,'l',[],'r');
xlim([0 100])