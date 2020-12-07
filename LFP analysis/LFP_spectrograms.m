% used to plot spectrum & Spectrograms, and coherence between two electrodes
%%% using Chronux toolbox
% Written by Hua Tang,Postdoc of Dr. Averbeck Lab, @NIMH.
% last update: May 29, 2020. Hua

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data: samples x trials

data=LFP_trial_no60{1, 5}'; % data from channel 1
data2=LFP_trial{1, 3}'; % data from channel 1

% LFP_trial_no60

%% spectrum
params=[];
params.trialave=1; % average over trials
params.Fs=1000;
[S,f]=mtspectrumc(data,params);

figure
plot_vector(S,f);
xlim([0 100])

no60LFP=rmlinesc(data1,params,[],[],60);
[S,f]=mtspectrumc(no60LFP,params);
hold on
plot_vector(S,f,'l',[],'r');
xlim([0 100])


%% Spectrograms
params=[];
movingwin=[0.5 0.05]; % set the moving window dimensions
params.Fs=1000; % sampling frequency
params.fpass=[0 100]; % frequencies of interest
params.tapers=[9 19]; % tapers
params.trialave=1; % average over trials
params.err=0;
params.pad=0;

[S1,t,f]=mtspecgramc(data,movingwin,params);

figure
plot_matrix(S1,t-1,f);
xlabel('Time for cue (s)')
ylabel('Frequency (Hz)')
caxis([-10 10]);

%% Coherence: matlab
for m=1:5
    for i=1:20
        data1=filtered{1, i}; % data from channel 1
        data2=filtered{1, i+50}; % data from channel 1
        no60LFP1=rmlinesc(data1,params,[],[],60);
        no60LFP2=rmlinesc(data,params,[],[],60);
        
        [cxy, f]=mscohere(no60LFP1(1001:1500,:),no60LFP2(1001+m*100:1500+m*100,:), [], [], 256, params.Fs);
        mcxy{m}(i,:)=mean(cxy,2);
    end
end

figure
plot(f, mean(mcxy{5}(:,:)))
xlabel('Frequency (Hz)')
ylabel('Coherence')
xlim([0 100])
