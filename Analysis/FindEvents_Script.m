function [] = FindEvents_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER)
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
%% Set Paths
BASEPATH = 'C:\Users\rcbul\OneDrive - University of North Carolina at Chapel Hill\Song_Lab\';
CODE_REAGAN = [BASEPATH 'Code\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

addpath(genpath(CODE_REAGAN));
addpath(genpath(ANALYZED_DATA));

SetGraphDefaults;
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
            largeGroupEvents.timeFreq = zeros(1,2*length(SESSIONS));
            largeGroupEvents.ptFreq   = zeros(1,2*length(SESSIONS));
            largeGroupEvents.ct       = zeros(1,2*length(SESSIONS));
            largeGroupEvents.auc      = zeros(1,2*length(SESSIONS));
            largeGroupEvents.amp      = {};
            largeGroupEvents.s         = zeros(1,2*length(SESSIONS));
            %make structs to store all data in for each channel - small
            %events
            smallGroupEvents.timeFreq = zeros(1,2*length(SESSIONS));
            smallGroupEvents.ptFreq   = zeros(1,2*length(SESSIONS));
            smallGroupEvents.ct       = zeros(1,2*length(SESSIONS));
            smallGroupEvents.auc      = zeros(1,2*length(SESSIONS));
            smallGroupEvents.amp      = {};
            smallGroupEvents.s        = zeros(1,2*length(SESSIONS));
            counter = 0;
            %make structs to store all data in for each channel - super
            %events
            superGroupEvents.timeFreq = zeros(1,2*length(SESSIONS));
            superGroupEvents.ptFreq   = zeros(1,2*length(SESSIONS));
            superGroupEvents.ct       = zeros(1,2*length(SESSIONS));
            superGroupEvents.auc      = zeros(1,2*length(SESSIONS));
            superGroupEvents.amp      = {};
            superGroupEvents.s        = zeros(1,2*length(SESSIONS));
            counter = 0;
            
            previousSession = '';
            for isession = 1:length(SESSIONS)
                thisSession = SESSIONS{isession};
                modelNameLength = length(thisModel);
                experConditionLength = length(thisExperCondition);
                session_sex = thisSession(modelNameLength+experConditionLength+3);
                titleSession = thisSession(experConditionLength+1:experConditionLength+modelNameLength+8);
                
                if strcmp(titleSession, previousSession)
                    continue;
                end
                sessionDir = [thisDir thisSession '\'];
                sessionFolder = dir(fullfile(sessionDir,'*_*'));
                THIS_SESSION_DIR = [thisSession '\' sessionFolder.name '\'];
                %% Load data
                % calcium data
                load([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\' thisSession], 'ca_data');
                ca_data.chan1 = ca_data.chan1_filt;
                ca_data.chan2 = ca_data.chan2_filt;
                % thresholding data (std dev)
                animal_info = thisSession(length(thisExperCondition)+2:end-13);
                stdDev_file = sprintf('%s_stdDev.mat',animal_info);
                load(stdDev_file,...
                    'SmallSD','SmallMean','SmallThr',...
                    'LargeSD','LargeMean','LargeThr',...
                    'SuperSD','SuperMean','SuperThr');
                %% Find events  (over butterworth filtered data)
                
                SuperEvents.chan1_idx = find(ca_data.chan1 >= (SuperMean.chan1+SuperThr.chan1));
                SuperEvents.chan1_values = ca_data.chan1(SuperEvents.chan1_idx);
                SuperEvents.chan2_idx = find(ca_data.chan2 >= (SuperMean.chan2+SuperThr.chan2));
                SuperEvents.chan2_values = ca_data.chan2(SuperEvents.chan2_idx);
                
                LargeEvents.chan1_idx = find(ca_data.chan1 >= (LargeMean.chan1+LargeThr.chan1)...
                    & ca_data.chan1 < (SuperMean.chan1+SuperThr.chan1));
                LargeEvents.chan1_values = ca_data.chan1(LargeEvents.chan1_idx);
                LargeEvents.chan2_idx = find(ca_data.chan2 >= (LargeMean.chan2+LargeThr.chan1)...
                    & ca_data.chan2 < (SuperMean.chan2+SuperThr.chan2));
                LargeEvents.chan2_values = ca_data.chan2(LargeEvents.chan2_idx);
                
                SmallEvents.chan1_idx = find(ca_data.chan1 >= (SmallMean.chan1+SmallThr.chan1)...
                    & ca_data.chan1 < (LargeMean.chan1+LargeThr.chan1)...
                    & ca_data.chan1 < (SuperMean.chan1+SuperThr.chan1));
                SmallEvents.chan1_values = ca_data.chan1(SmallEvents.chan1_idx);
                SmallEvents.chan2_idx = find(ca_data.chan2 >= (SmallMean.chan2+SmallThr.chan1)...
                    & ca_data.chan2 < (LargeMean.chan2+LargeThr.chan2)...
                    & ca_data.chan2 < (SuperMean.chan2+SuperThr.chan2));
                SmallEvents.chan2_values = ca_data.chan2(SmallEvents.chan2_idx);
                
                %% Test plot events
                figure;
                sgtitle([thisMonth ': ' thisExperCondition ' & ' thisModel ' (' strrep(titleSession(modelNameLength+3:end),'_',' ') ')']);
                %% Test plot small events
                % for channel 1
                subplot(3,2,1);
                plot(ca_data.time, ca_data.chan1_filt','b');
                hold on;
                scatter(ca_data.time(SmallEvents.chan1_idx),SmallEvents.chan1_values,'k');
                title('Small Events: Channel 1');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                % for channel 2
                subplot(3,2,2);
                plot(ca_data.time, ca_data.chan2_filt','b');
                hold on
                scatter(ca_data.time(SmallEvents.chan2_idx),SmallEvents.chan2_values,'k');
                title('Small Events: Channel 2');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                
                %% Test plot large events
                % for channel 1
                subplot(3,2,3);
                plot(ca_data.time, ca_data.chan1_filt','b');
                hold on;
                scatter(ca_data.time(LargeEvents.chan1_idx),LargeEvents.chan1_values,'k');
                title('Large Events: Channel 1');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                % for channel 2
                subplot(3,2,4);
                plot(ca_data.time, ca_data.chan2_filt','b');
                hold on
                scatter(ca_data.time(LargeEvents.chan2_idx),LargeEvents.chan2_values,'k');
                title('Large Events: Channel 2');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                %% Super Events
                % for channel 1
                subplot(3,2,5);
                plot(ca_data.time, ca_data.chan1_filt','b');
                hold on
                scatter(ca_data.time(SuperEvents.chan1_idx),SuperEvents.chan1_values,'k');
                title('Super Events: Channel 1');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                % for channel 2
                subplot(3,2,6);
                plot(ca_data.time, ca_data.chan2_filt','b');
                hold on
                scatter(ca_data.time(SuperEvents.chan2_idx),SuperEvents.chan2_values,'k');
                title('Super Events: Channel 2');
                box off;
                ylabel('Filtered \Delta F/F (%)');
                xlabel('Time (ms)');
                xlim([0 ca_data.time(end)]);
                
                %% Super Event Characterisitcs - Count, Freq Time, Freq Sampled Points, Amplitude, Area under curve
                % number of events
                superChrts.chan1_ct = length(SuperEvents.chan1_idx);
                superChrts.chan2_ct = length(SuperEvents.chan2_idx);
                % frequency of events (divide by amount of seconds) (time
                % in ms --> sec)
                superChrts.chan1_timefreq = superChrts.chan1_ct/(ca_data.time(end)/1000);
                superChrts.chan2_timefreq = superChrts.chan2_ct/(ca_data.time(end)/1000);
                % frequency of events (divide by amount of points)
                superChrts.chan1_ptfreq = superChrts.chan1_ct/length(ca_data.time);
                superChrts.chan2_ptfreq = superChrts.chan2_ct/length(ca_data.time);
                % amplitude of events
                superChrts.chan1_amp = SuperEvents.chan1_values;
                superChrts.chan2_amp = SuperEvents.chan2_values;
                % under the curve (add all amplitude values)
                superChrts.chan1_auc = sum(superChrts.chan1_amp);
                superChrts.chan2_auc = sum(superChrts.chan2_amp);
                %% Large Event Characterisitcs - Count, Freq Time, Freq Sampled Points, Amplitude, Area under curve
                % number of events
                largeChrts.chan1_ct = length(LargeEvents.chan1_idx);
                largeChrts.chan2_ct = length(LargeEvents.chan2_idx);
                % frequency of events (divide by amount of seconds) (time
                % in ms --> sec)
                largeChrts.chan1_timefreq = largeChrts.chan1_ct/(ca_data.time(end)/1000);
                largeChrts.chan2_timefreq = largeChrts.chan2_ct/(ca_data.time(end)/1000);
                % frequency of events (divide by amount of points)
                largeChrts.chan1_ptfreq = largeChrts.chan1_ct/length(ca_data.time);
                largeChrts.chan2_ptfreq = largeChrts.chan2_ct/length(ca_data.time);
                % amplitude of events
                largeChrts.chan1_amp = LargeEvents.chan1_values;
                largeChrts.chan2_amp = LargeEvents.chan2_values;
                % under the curve (add all amplitude values)
                largeChrts.chan1_auc = sum(largeChrts.chan1_amp);
                largeChrts.chan2_auc = sum(largeChrts.chan2_amp);
                %% Small Event Characterisitcs - Count, Freq Time, Freq Sampled Points, Amplitude, Area under curve
                % number of events
                smallChrts.chan1_ct = length(SmallEvents.chan1_idx);
                smallChrts.chan2_ct = length(SmallEvents.chan2_idx);
                % frequency of events (divide by amount of seconds) (time
                % in ms --> sec)
                smallChrts.chan1_timefreq = smallChrts.chan1_ct/(ca_data.time(end)/1000);
                smallChrts.chan2_timefreq = smallChrts.chan2_ct/(ca_data.time(end)/1000);
                % frequency of events (divide by amount of points)
                smallChrts.chan1_ptfreq = smallChrts.chan1_ct/length(ca_data.time);
                smallChrts.chan2_ptfreq = smallChrts.chan2_ct/length(ca_data.time);
                % amplitude of events
                smallChrts.chan1_amp = SmallEvents.chan1_values;
                smallChrts.chan2_amp = SmallEvents.chan2_values;
                % under the curve (add all amplitude values)
                smallChrts.chan1_auc = sum(smallChrts.chan1_amp);
                smallChrts.chan2_auc = sum(smallChrts.chan2_amp);
                %% Save Event Characteristics
                save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\' thisSession(1:end-13) '_events.mat'],'SmallEvents','SuperEvents','LargeEvents',...
                                                                                                                'superChrts','largeChrts','smallChrts');
                %% Make group characteristics for large events
                %group chan 1 and chan2 in different vectors, but same
                %struct
                % Channel 1
                largeGroupEvents(isession+counter).timeFreq = largeChrts.chan1_timefreq;
                largeGroupEvents(isession+counter).ptFreq   = largeChrts.chan1_ptfreq;
                largeGroupEvents(isession+counter).ct       = largeChrts.chan1_ct;
                largeGroupEvents(isession+counter).auc      = largeChrts.chan1_auc;
                largeGroupEvents(isession+counter).amp      = largeChrts.chan1_amp;
                largeGroupEvents(isession+counter).s        = session_sex;
                % Channel 2
                largeGroupEvents(isession+counter+1).timeFreq = largeChrts.chan2_timefreq;
                largeGroupEvents(isession+counter+1).ptFreq   = largeChrts.chan2_ptfreq;
                largeGroupEvents(isession+counter+1).ct       = largeChrts.chan2_ct;
                largeGroupEvents(isession+counter+1).auc      = largeChrts.chan2_auc;
                largeGroupEvents(isession+counter+1).amp      = largeChrts.chan2_amp;
                largeGroupEvents(isession+counter+1).s        = session_sex;
                %% Make group characteristics for small events
                %group chan 1 and chan2 in different vectors, but same
                %struct
                % Channel 1
                smallGroupEvents(isession+counter).timeFreq = smallChrts.chan1_timefreq;
                smallGroupEvents(isession+counter).ptFreq   = smallChrts.chan1_ptfreq;
                smallGroupEvents(isession+counter).ct       = smallChrts.chan1_ct;
                smallGroupEvents(isession+counter).auc      = smallChrts.chan1_auc;
                smallGroupEvents(isession+counter).amp      = smallChrts.chan1_amp;
                smallGroupEvents(isession+counter).s        = session_sex;
                % Channel 2
                smallGroupEvents(isession+counter+1).timeFreq = smallChrts.chan2_timefreq;
                smallGroupEvents(isession+counter+1).ptFreq   = smallChrts.chan2_ptfreq;
                smallGroupEvents(isession+counter+1).ct       = smallChrts.chan2_ct;
                smallGroupEvents(isession+counter+1).auc      = smallChrts.chan2_auc;
                smallGroupEvents(isession+counter+1).amp      = smallChrts.chan2_amp;
                smallGroupEvents(isession+counter+1).s        = session_sex;
                %% Make group characteristics for super events
                %group chan 1 and chan2 in different vectors, but same
                %struct
                % Channel 1
                superGroupEvents(isession+counter).timeFreq = superChrts.chan1_timefreq;
                superGroupEvents(isession+counter).ptFreq   = superChrts.chan1_ptfreq;
                superGroupEvents(isession+counter).ct       = superChrts.chan1_ct;
                superGroupEvents(isession+counter).auc      = superChrts.chan1_auc;
                superGroupEvents(isession+counter).amp      = superChrts.chan1_amp;
                superGroupEvents(isession+counter).s        = session_sex;
                % Channel 2
                superGroupEvents(isession+counter+1).timeFreq = superChrts.chan2_timefreq;
                superGroupEvents(isession+counter+1).ptFreq   = superChrts.chan2_ptfreq;
                superGroupEvents(isession+counter+1).ct       = superChrts.chan2_ct;
                superGroupEvents(isession+counter+1).auc      = superChrts.chan2_auc;
                superGroupEvents(isession+counter+1).amp      = superChrts.chan2_amp;
                superGroupEvents(isession+counter+1).s        = session_sex;
                counter = counter +1;
                
                previousSession = titleSession;
            end %session
            save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\' thisExperCondition '_' thisModel '_groupEvents.mat'],'largeGroupEvents','superGroupEvents','smallGroupEvents');
            clear largeGroupEvents superGroupEvents smallGroupEvents;
        end %model
    end %exper conditions
end %month

end