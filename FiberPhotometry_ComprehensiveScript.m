%% Comprehensive script for fiber photometry CCK IN project
% PURPOSE
%     Compare calcium recording from CCK interneurons in dentate gyrus of
%     hippocampus baseline vs CNO.
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
%
% DEPENDENCIES
%   filter_2sIIR (Hechen code to bandpass filter calcium traces)
% HISTORY
%   2.1.2022 Reagan Bullins
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
RAW_DATA = [BASEPATH 'Data\'];
ANALYZED_DATA= [BASEPATH 'Analyzed_Data\'];
FIGURES = [BASEPATH 'Figures\'];

addpath(genpath(CODE_REAGAN));
addpath(genpath(RAW_DATA));
addpath(genpath(ANALYZED_DATA));

SetGraphDefaults;
%% Run preprocessing
% Preprocessing_Script;
%% Run Filtering
% Filtering_Script;
%% Get std dev and mean for each animal
% GetStdDev_Script;
%% Get Events
% FindEvents_Script;
%%
for imonth = 1:length(MONTHS)
    thisMonth = MONTHS{imonth};
    for imodel = 1:length(MODELS)
        thisModel = MODELS{imodel};
        GROUP_EVENT_BL = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\baseline_' thisModel '_groupEvents.mat'];
        GROUP_EVENT_CNO = [ANALYZED_DATA INDICATOR_FOLDER thisMonth '\Events\CNO_' thisModel '_groupEvents.mat'];
        %% Load Group Events
        load(GROUP_EVENT_BL, 'groupEvents','smallGroupEvents');
        groupEventsBL = groupEvents;
        smallGroupEventsBL = smallGroupEvents;
        load(GROUP_EVENT_CNO, 'groupEvents','smallGroupEvents');
        groupEventsCNO = groupEvents;
        smallGroupEventsCNO = smallGroupEvents;
        %% Color Map
        colorMap(1,:) = [0 0 1];
        colorMap(2,:) = [1 0 0];
        %% One big plot
        figure;
        sgtitle(['Large Events - ' thisModel ': Baseline vs CNO']);
        %% Plot time Freq
        timeFreq(:,1) = vertcat(groupEventsBL.timeFreq)';
        timeFreq(:,2) = vertcat(groupEventsCNO.timeFreq)';
        subplot(2,2,1);
        boxplot(timeFreq,'Color',colorMap);
        hold on;
        ylabel('Frequency (Events/sec)');
        title('Event Frequency');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(groupEventsBL.timeFreq)'),1), vertcat(groupEventsBL.timeFreq)');
        scatter(2*ones(length(vertcat(groupEventsCNO.timeFreq)'),1), vertcat(groupEventsCNO.timeFreq)');
       
        %% Plot point freq
        ptFreq(:,1) = vertcat(groupEventsBL.ptFreq)';
        ptFreq(:,2) = vertcat(groupEventsCNO.ptFreq)';
        subplot(2,2,2);
        boxplot(ptFreq,'Color',colorMap);
        hold on;
        ylabel('Frequency (Events/samples)');
        title('Event Frequency Samples');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(groupEventsBL.ptFreq)'),1), vertcat(groupEventsBL.ptFreq)');
        scatter(2*ones(length(vertcat(groupEventsCNO.ptFreq)'),1), vertcat(groupEventsCNO.ptFreq)');
       
        %% Plot count
        ct(:,1) = vertcat(groupEventsBL.ct)';
        ct(:,2) = vertcat(groupEventsCNO.ct)';
        subplot(2,2,3);
        boxplot(ct,'Color',colorMap);
        hold on;
        ylabel('Count');
        title('Number of Events');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(groupEventsBL.ct)'),1), vertcat(groupEventsBL.ct)');
        scatter(2*ones(length(vertcat(groupEventsCNO.ct)'),1), vertcat(groupEventsCNO.ct)');
       
        %% Plot auc
        auc(:,1) = vertcat(groupEventsBL.auc)';
        auc(:,2) = vertcat(groupEventsCNO.auc)';
        subplot(2,2,4);
        boxplot(auc,'Color',colorMap);
        hold on;
        ylabel('AUC');
        title('AUC of Events');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(groupEventsBL.auc)'),1), vertcat(groupEventsBL.auc)');
        scatter(2*ones(length(vertcat(groupEventsCNO.auc)'),1), vertcat(groupEventsCNO.auc)');
       
        %% Plot amplitudes
%         amp(:,1) = vertcat(groupEventsBL.amp)';
%         amp(:,2) = vertcat(groupEventsCNO.amp)';
%         figure;
%         boxplot(amp,'Color',colorMap);
%         ylabel('Amplitude');
%         title({'Event Amplitude', [thisModel ': Baseline vs CNO']});
%         box off;
%         xticklabels({'Baseline','CNO'});
clear timeFreq ptFreq ct amp auc;

  %% One big plot for small events
        figure;
        sgtitle(['Small Events - ' thisModel ': Baseline vs CNO']);
        %% Plot time Freq
        timeFreq(:,1) = vertcat(smallGroupEventsBL.timeFreq)';
        timeFreq(:,2) = vertcat(smallGroupEventsCNO.timeFreq)';
        subplot(2,2,1);
        boxplot(timeFreq,'Color',colorMap);
        hold on;
        ylabel('Frequency (Events/sec)');
        title('Event Frequency');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(smallGroupEventsBL.timeFreq)'),1), vertcat(smallGroupEventsBL.timeFreq)');
        scatter(2*ones(length(vertcat(smallGroupEventsCNO.timeFreq)'),1), vertcat(smallGroupEventsCNO.timeFreq)');
       
        %% Plot point freq
        ptFreq(:,1) = vertcat(smallGroupEventsBL.ptFreq)';
        ptFreq(:,2) = vertcat(smallGroupEventsCNO.ptFreq)';
        subplot(2,2,2);
        boxplot(ptFreq,'Color',colorMap);
        hold on;
        ylabel('Frequency (Events/samples)');
        title('Event Frequency Samples');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(smallGroupEventsBL.ptFreq)'),1), vertcat(smallGroupEventsBL.ptFreq)');
        scatter(2*ones(length(vertcat(smallGroupEventsCNO.ptFreq)'),1), vertcat(smallGroupEventsCNO.ptFreq)');
       
        %% Plot count
        ct(:,1) = vertcat(smallGroupEventsBL.ct)';
        ct(:,2) = vertcat(smallGroupEventsCNO.ct)';
        subplot(2,2,3);
        boxplot(ct,'Color',colorMap);
        hold on;
        ylabel('Count');
        title('Number of Events');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(smallGroupEventsBL.ct)'),1), vertcat(smallGroupEventsBL.ct)');
        scatter(2*ones(length(vertcat(smallGroupEventsCNO.ct)'),1), vertcat(smallGroupEventsCNO.ct)');
       
        %% Plot auc
        auc(:,1) = vertcat(smallGroupEventsBL.auc)';
        auc(:,2) = vertcat(smallGroupEventsCNO.auc)';
        subplot(2,2,4);
        boxplot(auc,'Color',colorMap);
        hold on;
        ylabel('AUC');
        title('AUC of Events');
        box off;
        xticklabels({'Baseline','CNO'});
        scatter(ones(length(vertcat(smallGroupEventsBL.auc)'),1), vertcat(smallGroupEventsBL.auc)');
        scatter(2*ones(length(vertcat(smallGroupEventsCNO.auc)'),1), vertcat(smallGroupEventsCNO.auc)');
       clear timeFreq ptFreq ct amp auc;
    end %model
end %month
