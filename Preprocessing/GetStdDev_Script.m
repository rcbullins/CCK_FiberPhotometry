function [] = GetStdDev_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER)
% PURPOSE
%     Combine baseline and CNO sessions for each animal into one vector of
%     data. Then find std dev and mean of whole concatenated recording and save to
%     mat file
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
% OUTPUTS
%     stdDev.chan1  , stdDev.chan2  (struct with standard deviation for
%     each channel for one animal across baseline and CNO recordings)
%     mean.chan1, mean.chan2
%     concat_data struct
%               .time, .chan1, .chan2
% DEPENDENCIES (already ran the following scripts)
%   Filtering_Script
%        filter_2sIIR (Hechen code)
%   Preprocessing_Script
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
%% Run preprocessing
% Preprocessing_Script;
%% Run Filtering
% Filtering_Script;
%% Loop through each month
for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    % loop through each model
    for imodel = 1:length(MODELS)
        thisModel = MODELS{imodel};
        thisDir = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\'];
        % for baseline
        animalSessionsSearch_bl = sprintf('baseline_%s_*_filtered.mat',thisModel);
        allAnimalFolders_bl = dir(fullfile(thisDir, animalSessionsSearch_bl));
        SESSIONS_BL = {allAnimalFolders_bl.name};
        % for CNO
        animalSessionsSearch_CNO = sprintf('CNO_%s_*_filtered.mat',thisModel);
        allAnimalFolders_CNO = dir(fullfile(thisDir, animalSessionsSearch_CNO));
        SESSIONS_CNO = {allAnimalFolders_CNO.name};
        previousSession = '';
        for isession = 1:length(SESSIONS_BL)
            thisSessionCurrent = SESSIONS_BL{isession};
            %take off baseline and filtered.mat
            lengthModelName = length(thisModel);
            thisSession = thisSessionCurrent(10:end-13);
            titleSession = thisSessionCurrent(10:10+lengthModelName+6);
            if strcmp(titleSession,previousSession)
                continue;
            end
            % define directories to load
            THIS_SESSION_BL = [thisDir 'baseline_' thisSession '_filtered.mat'];
            THIS_SESSION_CNO = [thisDir 'CNO_' thisSession '_filtered.mat'];
            %% Load data
            load(THIS_SESSION_BL);
            bl_chan1 = ca_data.chan1_filt;
            bl_chan2 = ca_data.chan2_filt;
            bl_time_chan1 = ca_data.chan1_time;
            bl_time_chan2 = ca_data.chan2_time;
            load(THIS_SESSION_CNO);
            CNO_chan1 = ca_data.chan1_filt;
            CNO_chan2 = ca_data.chan2_filt;
            CNO_time_chan1 = ca_data.chan1_time;
            CNO_time_chan1 = CNO_time_chan1 + bl_time_chan1(end);
            
            CNO_time_chan2 = ca_data.chan2_time;
            CNO_time_chan2 = CNO_time_chan2 + bl_time_chan2(end);
            %% Concatenate the data
            % channel 1
            concat_data.chan1 = [bl_chan1 CNO_chan1];
            concat_data.chan1_time = [bl_time_chan1' CNO_time_chan1'];
            stdDev.chan1 = std(concat_data.chan1);
            dataMean.chan1 = mean(concat_data.chan1);
            % channel 2
            concat_data.chan2 = [bl_chan2 CNO_chan2];
            concat_data.chan2_time = [bl_time_chan2' CNO_time_chan2'];
            stdDev.chan2 = std(concat_data.chan2);
            dataMean.chan2 = mean(concat_data.chan2);
            %% Find super large events over a threshold value of 3 std from mean  (over butterworth filtered data)
            SuperSD.chan1 = stdDev.chan1;
            SuperSD.chan2 = stdDev.chan2;
            SuperThr.chan1 = 3*stdDev.chan1;
            SuperThr.chan2 = 3*stdDev.chan2;
            SuperMean.chan1 = dataMean.chan1;
            SuperMean.chan2 = dataMean.chan2;
            
            SuperEvents_concat.chan1_idx = find(concat_data.chan1 >= (SuperMean.chan1+SuperThr.chan1));
            SuperEvents_concat.chan1_values = concat_data.chan1(SuperEvents_concat.chan1_idx);
            SuperEvents_concat.chan2_idx = find(concat_data.chan2 >= (SuperMean.chan2+SuperThr.chan2));
            SuperEvents_concat.chan2_values = concat_data.chan2(SuperEvents_concat.chan2_idx);
            %% Fing large events
            % Take out super large events
            concat_noSuper.chan1 = concat_data.chan1;
            concat_noSuper.chan1(SuperEvents_concat.chan1_idx) = [];
            concat_noSuper.chan2 = concat_data.chan2;
            concat_noSuper.chan2(SuperEvents_concat.chan2_idx) = [];
            
            LargeSD.chan1 = std(concat_noSuper.chan1);
            LargeSD.chan2 = std(concat_noSuper.chan2);
            LargeThr.chan1 = 3*LargeSD.chan1;
            LargeThr.chan2 = 3*LargeSD.chan2;
            LargeMean.chan1 = mean(concat_noSuper.chan1);
            LargeMean.chan2 = mean(concat_noSuper.chan2);
            
            LargeEvents_concat.chan1_idx = find(concat_data.chan1 >= (LargeMean.chan1+LargeThr.chan1)...
                & concat_data.chan1 < (SuperMean.chan1+SuperThr.chan1));
            LargeEvents_concat.chan1_values = concat_data.chan1(LargeEvents_concat.chan1_idx);
            LargeEvents_concat.chan2_idx = find(concat_data.chan2 >= (LargeMean.chan2+LargeThr.chan1)...
                & concat_data.chan2 < (SuperMean.chan2+SuperThr.chan2));
            LargeEvents_concat.chan2_values = concat_data.chan2(LargeEvents_concat.chan2_idx);
            %% Find small events_concat only
            % Take out large events and super large events
            % Take out super large events
            superAndLargeIdx.chan1 = [SuperEvents_concat.chan1_idx LargeEvents_concat.chan1_idx];
            superAndLargeIdx.chan2 = [SuperEvents_concat.chan2_idx LargeEvents_concat.chan2_idx];
            concat_noSuperLarge.chan1 = concat_data.chan1;
            concat_noSuperLarge.chan1(superAndLargeIdx.chan1) = [];
            concat_noSuperLarge.chan2 = concat_data.chan2;
            concat_noSuperLarge.chan2(superAndLargeIdx.chan2) = [];
            
            SmallSD.chan1 = std(concat_noSuperLarge.chan1);
            SmallSD.chan2 = std(concat_noSuperLarge.chan2);
            SmallThr.chan1 = 3*SmallSD.chan1;
            SmallThr.chan2 = 3*SmallSD.chan2;
            SmallMean.chan1 = mean(concat_noSuperLarge.chan1);
            SmallMean.chan2 = mean(concat_noSuperLarge.chan2);
            
            
            SmallEvents_concat.chan1_idx = find(concat_data.chan1 >= (SmallMean.chan1+SmallThr.chan1)...
                & concat_data.chan1 < (LargeMean.chan1+LargeThr.chan1)...
                & concat_data.chan1 < (SuperMean.chan1+SuperThr.chan1));
            SmallEvents_concat.chan1_values = concat_data.chan1(SmallEvents_concat.chan1_idx);
            SmallEvents_concat.chan2_idx = find(concat_data.chan2 >= (SmallMean.chan2+SmallThr.chan1)...
                & concat_data.chan2 < (LargeMean.chan2+LargeThr.chan2)...
                & concat_data.chan2 < (SuperMean.chan2+SuperThr.chan2));
            SmallEvents_concat.chan2_values = concat_data.chan2(SmallEvents_concat.chan2_idx);
            %% Plot concatenated with event more than 3 Std deviations
            
            % Plot channel 1 concatenated
            figure;
            sgtitle({[thisMonth ' ' strrep(titleSession,'_',' ') ': BL + CNO']});
            
            %% Plot small events concatenated with event more than 1 and less than 3 Std deviations
            
            % Plot channel 1 concatenated
            subplot(3,2,1);
            plot(concat_data.chan1_time,concat_data.chan1,'b');
            hold on;
            scatter(concat_data.chan1_time(SmallEvents_concat.chan1_idx),SmallEvents_concat.chan1_values,'k');
            title('Small Events: Channel 1');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            xline(concat_data.chan1_time(length(bl_time_chan1)+1));
            % Plot channel 2 concatenated
            subplot(3,2,2);
            plot(concat_data.chan2_time,concat_data.chan2,'b');
            hold on;
            scatter(concat_data.chan2_time(SmallEvents_concat.chan2_idx),SmallEvents_concat.chan2_values,'k');
            title('Small Events: Channel 2');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            xline(concat_data.chan2_time(length(bl_time_chan2)+1));
            %% Plot large events concatenated with event more than 1 and less than 3 Std deviations
            
            % Plot channel 1 concatenated
            subplot(3,2,3);
            plot(concat_data.chan1_time,concat_data.chan1,'b');
            hold on;
            scatter(concat_data.chan1_time(LargeEvents_concat.chan1_idx),LargeEvents_concat.chan1_values,'k');
            title('Large Events: Channel 1');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            xline(concat_data.chan1_time(length(bl_time_chan1)+1));
            % Plot channel 2 concatenated
            subplot(3,2,4);
            plot(concat_data.chan2_time,concat_data.chan2,'b');
            hold on;
            scatter(concat_data.chan2_time(LargeEvents_concat.chan2_idx),LargeEvents_concat.chan2_values,'k');
            title('Large Events: Channel 2');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            xline(concat_data.chan2_time(length(bl_time_chan2)+1));
            %% Plot Super
            subplot(3,2,5);
            plot(concat_data.chan1_time,concat_data.chan1,'b');
            hold on;
            scatter(concat_data.chan1_time(SuperEvents_concat.chan1_idx),SuperEvents_concat.chan1_values,'k');
            title('Super Events: Channel 1');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            xline(concat_data.chan1_time(length(bl_time_chan1)+1));
            % Plot channel 2 concatenated
            subplot(3,2,6);
            plot(concat_data.chan2_time,concat_data.chan2,'b');
            hold on;
            scatter(concat_data.chan2_time(SuperEvents_concat.chan2_idx),SuperEvents_concat.chan2_values,'k');
            title('Super Events: Channel 2');
            box off;
            ylabel('\Delta F/F (%)');
            xlabel('Time (ms)');
            xline(concat_data.chan2_time(length(bl_time_chan2)+1));
            
            %% Save the std
            %save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\' thisSession '_stdDev.mat'],'stdDev','dataMean','concat_data');
            save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\' thisSession '_stdDev.mat'],...
                'concat_data',...
                'SmallSD','SmallMean','SmallThr',...
                'LargeSD','LargeMean','LargeThr',...
                'SuperSD','SuperMean','SuperThr');
            
            previousSession = titleSession;
        end %session
    end %model
end %month

end
