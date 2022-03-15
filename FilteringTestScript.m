function FilteringTestScript(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER)

% PURPOSE
%     Filter gcamp data with butterworth filter - see what parameters work
%     best.
%     4 conditions:
%        - baseline
%               WT vs AD model
%        - increase CCK activity (activated hM3D with CNO)
%               WT vs AD model
% INPUT
%    - mat files with data for each experimental session labeled as such:
%       baseline_CCK_sessionInfo_data.mat (made with preprocessing script)
%           this contains a ca_data struct for chan1 and chan2:
%                                  .time
%                                  .chan1_ref   (reference signal)
%                                  .chan1_gcamp (raw gcamp signal)
%                                  .chan1_ratio (gcamp to ref signal)
%                                  .chan1_dg    (deltaF/F)
% OUTPUTS
%   - filtered data
% DEPENDENCIES
%   filter_2sIIR (Hechen code to bandpass filter calcium traces)
%   run Preprocessing_Script first (or just make sure to have struct as
%   above)
% HISTORY
%   2.1.2022 Reagan Bullins
%% Set Paths
BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

addpath(genpath(CODE_REAGAN));
addpath(genpath(ANALYZED_DATA));

SetGraphDefaults;
%% Loop through each month
for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    % loop through each model
    for imodel = 1:length(MODELS)
        thisModel = MODELS{imodel};
        thisDir = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\'];
        % for baseline
        animalSessionsSearch_bl = sprintf('baseline_%s_*_data.mat',thisModel);
        allAnimalFolders_bl = dir(fullfile(thisDir, animalSessionsSearch_bl));
        SESSIONS_BL = {allAnimalFolders_bl.name};
        % for CNO
        animalSessionsSearch_CNO = sprintf('CNO_%s_*_data.mat',thisModel);
        allAnimalFolders_CNO = dir(fullfile(thisDir, animalSessionsSearch_CNO));
        SESSIONS_CNO = {allAnimalFolders_CNO.name};
        previousSession = '';
        for isession = 1:length(SESSIONS_BL)
            thisSession = SESSIONS_BL{isession};
            %take off baseline and filtered.mat
            animalInfo = thisSession(10:end-9);
            % animal name
            modelLengthName = length(thisModel);
            titleSession = animalInfo(modelLengthName+1:modelLengthName+7);
            
            if strcmp(titleSession, previousSession)
                continue;
            end
            % define directories to load
            THIS_SESSION_BL = [thisDir thisSession];
            THIS_SESSION_CNO = [thisDir 'CNO_' animalInfo '_data.mat'];
            %% Load data
            load(THIS_SESSION_BL);
            bl_chan1 = ca_data.chan1_dg;
            bl_chan2 = ca_data.chan2_dg;
            bl_time = ca_data.time;
            clear ca_data;
            load(THIS_SESSION_CNO);
            CNO_chan1 = ca_data.chan1_dg;
            CNO_chan2 = ca_data.chan2_dg;
            CNO_time = ca_data.time;
            CNO_time = CNO_time + bl_time(end);
            clear ca_data;
            %% Concatenate the data
            % channel 1
            concat_data.chan1 = [bl_chan1' CNO_chan1'];
            concat_data.time = [bl_time' CNO_time'];
            stdDev.chan1 = std(concat_data.chan1);
            dataMean.chan1 = mean(concat_data.chan1);
            % channel 2
            concat_data.chan2 = [bl_chan2' CNO_chan2'];
            stdDev.chan2 = std(concat_data.chan2);
            dataMean.chan2 = mean(concat_data.chan2);
            %% Filter data
            samp_freq = 10;
            cutoff_freq = .05;
            filter_type = 'high'; %'high' 'low' 'bandpass' 'stop'
            IIR_order = 3;
            concat_data.chan1_filt = filter_2sIIR(concat_data.chan1,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(concat_data.chan1(1:100));
            concat_data.chan2_filt = filter_2sIIR(concat_data.chan2,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(concat_data.chan2(1:100));  %highpass filter
            %% Plot with filter
            figure;
            sgtitle({[thisMonth ': BL + CNO (' strrep(titleSession,'_',' ') ')']});
            % for channel 1
            subplot(2,2,1);
            plot(concat_data.time, concat_data.chan1,'r');
            hold on;
            plot(concat_data.time, concat_data.chan1_filt','b');
            title('Chan 1: High Pass');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            % for channel 2
            subplot(2,2,2);
            plot(concat_data.time, concat_data.chan2,'r');
            hold on;
            plot(concat_data.time, concat_data.chan2_filt','b');
            title('Chan 2: High Pass');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
           %% Bandpass filter
            samp_freq = 10;
            cutoff_freq = [0.05];
            filter_type = 'high'; % 'low' 'bandpass' 'stop';
            IIR_order = 3;
            concat_data_temp.chan1_filt = filter_2sIIR(concat_data.chan1,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(concat_data.chan1(1:100));
            concat_data_temp.chan2_filt = filter_2sIIR(concat_data.chan2,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(concat_data.chan2(1:100));  %highpass filter
             
             cutoff_freq = [2];
             filter_type = 'low' ;% 'low' 'bandpass' 'stop'
             IIR_order = 3;
             concat_data.chan1_filt = filter_2sIIR(concat_data_temp.chan1_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(concat_data_temp.chan1_filt(1:100));
           concat_data.chan2_filt = filter_2sIIR(concat_data_temp.chan2_filt,cutoff_freq,samp_freq,IIR_order,filter_type)+mean(concat_data_temp.chan2_filt(1:100));  %highpass filter
            
            
            
          %% Continue plotting
                      subplot(2,2,3);
            plot(concat_data.time, concat_data.chan1,'r');
            hold on;
            plot(concat_data.time, concat_data.chan1_filt','b');
            title('Chan 1: bandpass');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            % for channel 2
            subplot(2,2,4);
            plot(concat_data.time, concat_data.chan2,'r');
            hold on;
            plot(concat_data.time, concat_data.chan2_filt','b');
            title('Chan 2: bandpass');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            %%
            previousSession = titleSession;
        end %session
    end %model
end %month
end