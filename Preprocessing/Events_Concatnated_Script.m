 %Events_Concatnated_Script;
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
        
    end %model
end %month