% % % 1. Downsample LFP to 500 Hz
% % % 2. Compute FFT on each trial for each electrode using 256 point non-overlapping windows.
% % % 3. Compute power in each frequency for each trial, bin.
% % % 4. Build regression model that predicts LFP power in one electrode using LFP power in the other electrode across frequencies using canonical correlation analysis.
% % %
% % % X_i (f,t)=a_0+ a_1 X_i (f,t-1)+ a_2 X_j (f,t)

% last update: June 19, 2020

clear; close all; clc;
fname='w20160121'

cd 'C:\Users\tangh4\OneDrive - National Institutes of Health\NIH-Research\PFC_8ARRAY\WhatWhere\Database';
load([fname,'_neuron.mat'], 'beh')
iwhat=find(beh.blockType==1);
iwhere=find(beh.blockType==2);

cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\What&where DATA\', fname, 'data\', fname, 'NIP1\matFiles']);
LFP=[];
for i=1:4
    load([fname, '_nip1_LFP_trial_UA' num2str(i), '_no60.mat'])
    LFP=[LFP, LFP_trial];
    clear LFP_trial
end

cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\What&where DATA\', fname, 'data\', fname, 'NIP2\matFiles']);
LFP2=[];
for i=1:4
    load([fname, '_nip2_LFP_trial_UA' num2str(i), '_no60.mat'])
    LFP2=[LFP2, LFP_trial];
    clear LFP_trial
end

LFP=[LFP,LFP2];
clear LFP2

tt=0
for j=1:size(LFP,2)
    chn=j;
    if j<385
        nip=1;
    elseif j>384
        nip=2;
        chn=chn-384;
    end
    tt=tt+1;
    [Neurons{tt,2},C{tt,1}] = GetArrayID(chn,nip);
    Neurons{tt,1}=fname(1); %'v'
end

[lArrayw, lArrayv] = indexIdentify_Array8_lfp(Neurons)
tarray=eval(['lArray', fname(1)]);

%%
Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 3072;             % Length of signal
t = (0:L-1)*T;        % Time vector

Bin.period=[-1 1.816];
Bin.central='cue';
Bin.step=0.256;
Bin.window=0.256;
Bin.cen=Bin.period(1)+Bin.window/2:Bin.step:Bin.period(2)-Bin.window/2;
Bin.nob=(Bin.period(2)-Bin.period(1))/Bin.step;
L=Bin.window/T;
f = Fs*(0:(L/2))/L;
tend=find(f==101.5625);
nf=f(1:tend);

for ie=1:length(LFP) % number of electrode
    for it=1:size(LFP{1, 1},1) % number of trials
        for j=1:length(Bin.cen)
            twin=(Bin.cen(j)-Bin.window/2-Bin.period(1))/T+(1:Bin.window/T);
            twin=round(twin);
            
            ttarray=LFP{1, ie};
            tY=fft(ttarray(it,twin));
            
            P2 = abs(tY/L);
            tP1 = P2(1:L/2+1);
            tP1(2:end-1) = 2*tP1(2:end-1);
            %         Y(:,j)=tY;
            P1{ie}(:,j,it)=tP1(1:tend);
        end
    end
end

clear LFP

cd (['D:\NIH-Research\PFC_8ARRAY\WhatWhere\What&where DATA\', fname, 'data']);
save(['lfp_predict_', fname],'P1','Bin','Neurons','-v7.3')

% %% spectrum
% params=[];
% params.trialave=1; % average over trials
% params.Fs=1000;
% no60LFP=rmlinesc(mean(data2,3),params,[],[],60);
%
% figure
% imagesc(Bin.cen,f,mean(data2,3))
% set(gca,'ydir','normal')
% xlabel('Time for cue (s)')
% ylabel('Frequency (Hz)')
% h=colorbar;
% set(get(h,'label'),'string','dB')

%% setting parameters
% nbin=1
% period=Bin.period;%%[-0.5 1.5]; % period
% sbin=(period(1)-Bin.cen(1))/Bin.step+1;
% ebin=(period(2)-Bin.cen(1))/Bin.step+1;
% bins=sbin:ebin;
% bincen=period(1):Bin.step:period(2);
bins=2:11; % new period is too colse to the default one.
bincen=Bin.cen;

hemi={'left','right'};
whatwhere={'what','where'};
ncho=nchoosek(1:4,2);
ncho=[ncho;[ncho(:,2),ncho(:,1)]]

for iww=1:2
    iWW=eval(['i',whatwhere{iww}]); % what / where blocks
    for ihemi=1:2
        ihemi
        for ii=1:size(ncho,1)
            tarray1=tarray{ihemi,ncho(ii,1)};
            tarray2=tarray{ihemi,ncho(ii,2)};

            for m=1:length(tarray1)
                data1=10*log10(P1{1, tarray1(m)}(:,:,iWW));
                for n=1:length(tarray2)
                    data2=10*log10(P1{1, tarray2(n)}(:,:,iWW));
                    for iii=1:length(bins)
                        i=bins(iii);
                        X=squeeze(data1(:,i,:))';
                        Y=squeeze(data2(:,i,:))';
                        pY=squeeze(data2(:,i-1,:))'; %previous Y
                        [A,B,~,~,~,stats] = canoncorr(X,Y);
                        
                        [Arp,Brp,~,~,~,~] = canoncorr(pY,Y);
%                         rY=Y-pY*Arp*Brp'; %residual
                        rY=Y-pY*Arp(:,1)*Brp(:,1)'; %residual
                        [Ar,Br,~,~,~,statsr] = canoncorr(X,rY);

                        Meb=B*A';
                        Mebr=Br*Ar';
%                         Meb=B(:,1)*A(:,1)';
%                         Mebr=Br(:,1)*Ar(:,1)';
                        Mee(:,:,iii,m,n)=Meb;
                        Meer(:,:,iii,m,n)=Mebr;
                    end
                end 
            end
            Maa{ii}=squeeze(mean(mean(Mee,5),4));
            Maar{ii}=squeeze(mean(mean(Meer,5),4));
            clear Mee Meer   
        end
        save(['lfp_predict_', fname, '_' hemi{ihemi} '_' whatwhere{iww},'_all'],'Maa','Maar','Bin','tarray','ncho','nf')
    end
end