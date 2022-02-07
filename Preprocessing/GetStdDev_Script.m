% Get Std Deviation
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
% DEPENDENCIES (already ran the following scripts)
%   Filtering_Script
%        filter_2sIIR (Hechen code)
%   Preprocessing_Script
% HISTORY
%   2.3.2022 Reagan Bullins
clear;
clc;
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
%% Set conditions
MODELS           = {'CCK','CCKAD'}; %WT and AD models
EXPER_CONDITIONS = {'baseline','CNO'};
INDICATOR_FOLDER = 'hM3D_DioGC\'; %L_hM3D_DioGC_R_hM3D_GFAPGC
MONTHS           = {'3mon'};
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
        
        for isession = 1:length(SESSIONS_BL)
            thisSession = SESSIONS_BL{isession};
            %take off baseline and filtered.mat
            thisSession = thisSession(10:end-13);
            % define directories to load
            THIS_SESSION_BL = [thisDir 'baseline_' thisSession '_filtered.mat'];
            THIS_SESSION_CNO = [thisDir 'CNO_' thisSession '_filtered.mat'];
            %% Load data
            load(THIS_SESSION_BL);
            bl_chan1 = ca_data.chan1_filt;
            bl_chan2 = ca_data.chan2_filt;
            load(THIS_SESSION_CNO);
            CNO_chan1 = ca_data.chan1_filt;
            CNO_chan2 = ca_data.chan2_filt;
            %% Concatenate the data
            % channel 1
            concat_data_chan1 = [bl_chan1 CNO_chan1];
            stdDev.chan1 = std(concat_data_chan1);
            dataMean.chan1 = mean(concat_data_chan1);
            % channel 2
            concat_data_chan2 = [bl_chan2 CNO_chan2];
            stdDev.chan2 = std(concat_data_chan2);   
            dataMean.chan2 = mean(concat_data_chan2);
            %% Save the std
            save([ANALYZED_DATA INDICATOR_FOLDER thisMonth '\' thisSession '_stdDev.mat'],'stdDev','dataMean');
        end %session
    end %model
end %month


