%Find Events Script
% PURPOSE
%     Find calcium recording events from threshold set for each animal
%     given by the 3 x the std deviation (output from stdDev_Script). Save
%     events in a mat file. Also get characteristics of events: Count,
%     Freq Time, Freq Sampled Points, Amplitude, Area under curve
%     4 conditions:
%        - baseline
%               WT vs AD model
%        - increase CCK activity (activated hM3D with CNO)
%               WT vs AD model
% INPUT
%    - mat files with filtered data for each experimental session labeled as such:
%       baseline_CCK_sessionInfo.mat
%           this contains a ca_data struct for chan1 and chan2:
%                                  .time
%                                  .chan1_ref   (reference signal)
%                                  .chan1_gcamp (raw gcamp signal)
%                                  .chan1_ratio (gcamp to ref signal)
%                                  .chan1_dg    (deltaF/F)
%                                  .chan1_filt  (filtered data)
%   - std deviation over baseline and CNO recording,
%       CCK_sessionInfo_stdDev.mat
%              stdDev.chan1, stdDev.chan2

% OUTPUTS
%   baseline_CCK_sessionInfo_events.mat with 2 structs
%       events.chan1_idx
%       events.chan1_values
%       eventChrts.chan1_amp, .chan1_timeFreq, .chan1_ptFreq, .chan1_auc,
%                 .chan1_ct
% DEPENDENCIES
%   Run First: Preprocessing, Filtering, Get Std Dev
% HISTORY
%   2.3.2022 Reagan Bullins
clear;
clc;
%% Set conditions
MODELS           = {'CCK','CCKAD'}; %WT and AD models
EXPER_CONDITIONS = {'baseline','CNO'};
INDICATOR_FOLDER = 'hM3D_DioGC\'; %L_hM3D_DioGC_R_hM3D_GFAPGC
MONTHS           = {'3mon'};
%% Set Paths
BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

addpath(genpath(CODE_REAGAN));
addpath(genpath(ANALYZED_DATA));

SetGraphDefaults;
%% Run preprocessing
% Preprocessing_Script;
%% Run Filtering
% Filtering_Script;
%% Get std dev for each animal
% GetStdDev_Script;
%%

for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    % Loop through each condition
    for icondition = 1:length(EXPER_CONDITIONS)
        thisExperCondition = EXPER_CONDITIONS{icondition};
        % loop through each model
        for imodel = 1:length(MODELS)
            thisModel = MODELS{imodel};
            thisDir = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\'];
            % See how many sessions are in the folder for this condition and
            % model
            modelSearchFolders = sprintf('%s_%s_*_filtered.mat',thisExperCondition, thisModel);
            allModelFolders = dir(fullfile(thisDir, modelSearchFolders));
            % get all folder names
            SESSIONS = {allModelFolders.name};
            
            %make structs to store all data in for each channel - large
            %events
            groupEvents.timeFreq = zeros(1,2*length(SESSIONS));
            groupEvents.ptFreq   = zeros(1,2*length(SESSIONS));
            groupEvents.ct       = zeros(1,2*length(SESSIONS));
            groupEvents.auc      = zeros(1,2*length(SESSIONS));
            groupEvents.amp      = {};
                        
            %make structs to store all data in for each channel - small
            %events
            smallGroupEvents.timeFreq = zeros(1,2*length(SESSIONS));
            smallGroupEvents.ptFreq   = zeros(1,2*length(SESSIONS));
            smallGroupEvents.ct       = zeros(1,2*length(SESSIONS));
            smallGroupEvents.auc      = zeros(1,2*length(SESSIONS));
            smallGroupEvents.amp      = {};
            counter = 0;
            for isession = 1:length(SESSIONS)
                thisSession = SESSIONS{isession};
                sessionDir = [thisDir thisSession '\'];
                sessionFolder = dir(fullfile(sessionDir,'*_*'));
                THIS_SESSION_DIR = [thisSession '\' sessionFolder.name '\'];
                %% Load data
                % calcium data
                load([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\' thisSession], 'ca_data');
                % thresholding data (std dev)
                animal_info = thisSession(length(thisExperCondition)+2:end-13);
                stdDev_file = sprintf('%s_stdDev.mat',animal_info);
                load(stdDev_file,'stdDev','dataMean');
                %% Find events over a threshold value of 3 std from mean  (over butterworth filtered data)
                thr.chan1 = 3*stdDev.chan1;
                thr.chan2 = 3*stdDev.chan2;
                
                events.chan1_idx = find(ca_data.chan1_filt >= (dataMean.chan1+thr.chan1));
                events.chan1_values = ca_data.chan1_filt(events.chan1_idx);
                events.chan2_idx = find(ca_data.chan2_filt >= (dataMean.chan2+thr.chan2));
                events.chan2_values = ca_data.chan2_filt(events.chan2_idx);
                %% Find small events only
                thr_small.chan1 = 1*stdDev.chan1;
                thr_small.chan2 = 1*stdDev.chan1;
                
                smallEvents.chan1_idx = find(ca_data.chan1_filt >= (dataMean.chan1+thr_small.chan1)...
                                           & ca_data.chan1_filt < (dataMean.chan1+thr.chan1));
                smallEvents.chan1_values = ca_data.chan1_filt(smallEvents.chan1_idx);
                smallEvents.chan2_idx = find(ca_data.chan2_filt >= (dataMean.chan2+thr_small.chan1)...
                                           & ca_data.chan2_filt < (dataMean.chan2+thr.chan2));
                smallEvents.chan2_values = ca_data.chan2_filt(smallEvents.chan2_idx);
                %% Test plot large events
                figure;
                sgtitle([thisMonth ': ' thisExperCondition ' & ' thisModel ' (' strrep(thisSession,'_',' ') ')']);
                % for channel 1
                subplot(2,1,1);
                plot(ca_data.time, ca_data.chan1_filt','b');
                hold on
                scatter(ca_data.time(events.chan1_idx),events.chan1_values,'k');
                title('Channel 1');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                % for channel 2
                subplot(2,1,2);
                plot(ca_data.time, ca_data.chan2_filt','b');
                hold on
                scatter(ca_data.time(events.chan2_idx),events.chan2_values,'k');
                title('Channel 2');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                %% Test plot small events
                figure;
                sgtitle(['Small Events -' thisMonth ': ' thisExperCondition ' & ' thisModel ' (' strrep(thisSession,'_',' ') ')']);
                % for channel 1
                subplot(2,1,1);
                plot(ca_data.time, ca_data.chan1_filt','b');
                hold on;
                scatter(ca_data.time(smallEvents.chan1_idx),smallEvents.chan1_values,'k');
                title('Channel 1');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                % for channel 2
                subplot(2,1,2);
                plot(ca_data.time, ca_data.chan2_filt','b');
                hold on
                scatter(ca_data.time(smallEvents.chan2_idx),smallEvents.chan2_values,'k');
                title('Channel 2');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                %% Large Event Characterisitcs - Count, Freq Time, Freq Sampled Points, Amplitude, Area under curve
                % number of events
                eventChrts.chan1_ct = length(events.chan1_idx);
                eventChrts.chan2_ct = length(events.chan2_idx);
                % frequency of events (divide by amount of seconds) (time
                % in ms --> sec)
                eventChrts.chan1_timefreq = eventChrts.chan1_ct/(ca_data.time(end)/1000);
                eventChrts.chan2_timefreq = eventChrts.chan2_ct/(ca_data.time(end)/1000);
                % frequency of events (divide by amount of points)
                eventChrts.chan1_ptfreq = eventChrts.chan1_ct/length(ca_data.time);
                eventChrts.chan2_ptfreq = eventChrts.chan2_ct/length(ca_data.time);
                % amplitude of events
                eventChrts.chan1_amp = events.chan1_values;
                eventChrts.chan2_amp = events.chan2_values;
                % under the curve (add all amplitude values)
                eventChrts.chan1_auc = sum(eventChrts.chan1_amp);
                eventChrts.chan2_auc = sum(eventChrts.chan2_amp);
                %% Small Event Characterisitcs - Count, Freq Time, Freq Sampled Points, Amplitude, Area under curve
                % number of events
                smallEventChrts.chan1_ct = length(events.chan1_idx);
                smallEventChrts.chan2_ct = length(events.chan2_idx);
                % frequency of events (divide by amount of seconds) (time
                % in ms --> sec)
                smallEventChrts.chan1_timefreq = smallEventChrts.chan1_ct/(ca_data.time(end)/1000);
                smallEventChrts.chan2_timefreq = smallEventChrts.chan2_ct/(ca_data.time(end)/1000);
                % frequency of events (divide by amount of points)
                smallEventChrts.chan1_ptfreq = smallEventChrts.chan1_ct/length(ca_data.time);
                smallEventChrts.chan2_ptfreq = smallEventChrts.chan2_ct/length(ca_data.time);
                % amplitude of events
                smallEventChrts.chan1_amp = events.chan1_values;
                smallEventChrts.chan2_amp = events.chan2_values;
                % under the curve (add all amplitude values)
                smallEventChrts.chan1_auc = sum(smallEventChrts.chan1_amp);
                smallEventChrts.chan2_auc = sum(smallEventChrts.chan2_amp);
                %% Save Event Characteristics
                save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\' thisSession(1:end-13) '_events.mat'],'events','eventChrts','smallEventChrts');
                %% Make group characteristics for large events
                %group chan 1 and chan2 in different vectors, but same
                %struct
                % Channel 1
                groupEvents(isession+counter).timeFreq = eventChrts.chan1_timefreq;
                groupEvents(isession+counter).ptFreq   = eventChrts.chan1_ptfreq;
                groupEvents(isession+counter).ct       = eventChrts.chan1_ct;
                groupEvents(isession+counter).auc      = eventChrts.chan1_auc;
                groupEvents(isession+counter).amp      = eventChrts.chan1_amp;
                % Channel 2
                groupEvents(isession+counter+1).timeFreq = eventChrts.chan2_timefreq;
                groupEvents(isession+counter+1).ptFreq   = eventChrts.chan2_ptfreq;
                groupEvents(isession+counter+1).ct       = eventChrts.chan2_ct;
                groupEvents(isession+counter+1).auc      = eventChrts.chan2_auc;
                groupEvents(isession+counter+1).amp      = eventChrts.chan2_amp;
       
                %% Make group characteristics for small events
                %group chan 1 and chan2 in different vectors, but same
                %struct
                % Channel 1
                smallGroupEvents(isession+counter).timeFreq = smallEventChrts.chan1_timefreq;
                smallGroupEvents(isession+counter).ptFreq   = smallEventChrts.chan1_ptfreq;
                smallGroupEvents(isession+counter).ct       = smallEventChrts.chan1_ct;
                smallGroupEvents(isession+counter).auc      = smallEventChrts.chan1_auc;
                smallGroupEvents(isession+counter).amp      = smallEventChrts.chan1_amp;
                % Channel 2
                smallGroupEvents(isession+counter+1).timeFreq = smallEventChrts.chan2_timefreq;
                smallGroupEvents(isession+counter+1).ptFreq   = smallEventChrts.chan2_ptfreq;
                smallGroupEvents(isession+counter+1).ct       = smallEventChrts.chan2_ct;
                smallGroupEvents(isession+counter+1).auc      = smallEventChrts.chan2_auc;
                smallGroupEvents(isession+counter+1).amp      = smallEventChrts.chan2_amp;
                counter = counter +1;
            end %session
                save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\' thisExperCondition '_' thisModel '_groupEvents.mat'],'groupEvents','smallGroupEvents');
                clear groupEvents smallGroupEvents;
        end %model
    end %exper condition
end %month
