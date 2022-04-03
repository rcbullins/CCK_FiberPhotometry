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
INDICATOR_FOLDER1 =  'hM3D_DioGC\'; 
INDICATOR_FOLDER2 = 'L_hM3D_DioGC_R_hM3D_GFAPGC\';
MONTHS           = {'4mon'};

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
 samplingRate = 10;
% %plotDeltaF(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER, samplingRate)
 %Preprocessing_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER1, samplingRate);
% Preprocessing_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER2, samplingRate);
% %% Run Filtering
% % Filtering_Script; OR FilteringConcat_Script
% % FilteringTestScript(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER)
% FilteringConcat_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER1);
% FilteringConcat_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER2);
% %% Get std dev and mean for each animal
 GetStdDev_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER1);
% GetStdDev_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER2);
% %% Get Events\
%FindEvents_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER1);
% FindEvents_Script(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER2);
%% Powerspectrum
%getPowerSpectrum(MODELS,EXPER_CONDITIONS,MONTHS, INDICATOR_FOLDER1);
%% Get boxplots of CCK cells

%getBoxPlots_CaEvents_all(MONTHS,INDICATOR_FOLDER1, INDICATOR_FOLDER2);

% 
% if strcmp(INDICATOR_FOLDER,'hM3D_DioGC\')
% getBoxPlots_CaEvents(MODELS,MONTHS,'hM3D_DioGC\');
% elseif strcmp(INDICATOR_FOLDER,'L_hM3D_DioGC_R_hM3D_GFAPGC\')
% % Boxplots of CCK vs Glia
% getBoxPlots_CaEvents_CCKvsGlia(MODELS,MONTHS,'L_hM3D_DioGC_R_hM3D_GFAPGC\');
% end

