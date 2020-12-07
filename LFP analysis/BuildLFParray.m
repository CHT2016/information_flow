% used to extract LPF data from ripple recording
% Written by Ramon,Postdoc of Dr. Averbeck Lab, @NIMH.
% last update: May 29, 2020. Hua

clear; close all;
RippleDir = 'D:\NIH-Research\PFC_8ARRAY\WhatWhere\What&where DATA\W20160121data\W20160121NIP1\';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Look up for destination folder
SaveDir = fullfile(RippleDir, 'matFiles');
if ~isdir(SaveDir)
    mkdir(SaveDir)
end

%%%% Find Behavioral file name and get Session Name
t = dir(fullfile(RippleDir,'*.bhv'));
if ~isempty(t)
    [~,BHVname,~] = fileparts(t.name);
    BHV = bhv_read(fullfile(RippleDir,t.name));
else
    error('BHV file not found...')
end

% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %%% GET & SORT EVENT MARKERS FROM RIPPLE FILES
% % % t = dir(fullfile(RippleDir,'*.nev'));
% % % if ~isempty(t)
% % %     if numel(t)==1
% % %         [~,RIPPLEname,~] = fileparts(t.name);
% % %     else
% % %         [~,RIPPLEname,~] = fileparts(t(NIP).name);
% % %     end
% % % else
% % %     error('NEUROSHARE (RIPPLE) file not found...')
% % % end
% % % clear t
% % % 
% % % disp('Reading Event Codes from NEV file...')
% % % ff = fullfile(RippleDir,RIPPLEname);
% % % [fileok, EventTimes, EventCode] = ExtractRippleData(ff,'Event',0);
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% Find Neural file name
t = dir(fullfile(RippleDir,'*.nev'));
if ~isempty(t)
    [~,RIPPLEname,~] = fileparts(t.name);
else
    error('NEUROSHARE (RIPPLE) file not found...')
end
clear t


%%%% SET INITIAL PARAMETERS %%%%
ff = fullfile(RippleDir,RIPPLEname);
ElecGroup = {'UA1','UA2','UA3','UA4'};
% ElecGroup = {'UA1-1','UA1-2','UA1-3',...
%              'UA2-1','UA2-2','UA2-3',...
%              'UA3-1','UA3-2','UA3-3',...
%              'UA4-1','UA4-2','UA4-3'};
splitbytrial = false;

%%% GET & SORT LFP FROM RIPPLE FILES
disp('Reading LFP data...')
for i = 1:numel(ElecGroup)
    parfor chn = 1:96  %%% LFPs from 1 array in each file
        iii = 96*(i-1)+chn;
        disp([num2str(chn) ' - ' num2str(iii)])
        tic
        [fileok, WaveTimes{chn}, WaveData{chn}] = ExtractRippleData(ff,'LFP',iii);
        RealChan(chn) = iii;
        toc
    end
    disp(['Saving data from array ' ElecGroup{i}])
    save(fullfile(SaveDir,[BHVname(1:end-4) '-' ElecGroup{i} '-LFP.mat']),'WaveTimes','WaveData','RealChan','splitbytrial')
%     clear WaveTimes WaveData

end

% disp('Reading Eye Data...')
% parfor chn = 1:2
%     disp(num2str(chn))
%     tic
%     [fileok, AnlgTimes(:,chn), AnlgData(:,chn)] = ExtractRippleData(ff,'Analog',chn);
%     toc
% end
% BHVeye.sr = BHV.AnalogInputFrequency;
% BHVeye.trial = BHV.TrialNumber;
% BHVeye.error = BHV.TrialError;
% BHVeye.eyeSignal(1:length(BHVeye.trial)) = struct('d',[]);
% for i = 1:length(BHVeye.trial)
%     BHVeye.eyeSignal(i).d = BHV.AnalogData{i}.EyeSignal;
% end
% save(fullfile(SaveDir,[BHVname '-ANALOGDATA.mat']),'AnlgTimes','AnlgData','BHVeye','splitbytrial')

